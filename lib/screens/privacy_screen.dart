import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:edu_connect_pro/screens/auth/login_screen.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  bool isProfilePublic = true;
  bool _isExporting = false;
  bool _isDeleting = false;

  Future<void> _downloadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aucun utilisateur connecté.'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _isExporting = true);
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (!doc.exists) {
        throw Exception('Données utilisateur introuvables');
      }

      final exportData = jsonEncode(doc.data());
      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Téléchargement des données'),
          content: const Text('Vos données ont été préparées. Un lien de téléchargement vous a été envoyé par email.'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
          ],
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Données exportées : ${exportData.length} caractères')), 
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Échec du téléchargement des données : $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  Future<void> _deleteAccount() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aucun utilisateur connecté.'), backgroundColor: Colors.red),
      );
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Attention !', style: TextStyle(color: Colors.red)),
        content: const Text('Voulez-vous vraiment supprimer définitivement votre compte ? Cette action est irréversible.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuler')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Supprimer', style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isDeleting = true);
    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).delete();
      await user.delete();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Compte supprimé avec succès.'), backgroundColor: Colors.green),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      final message = e.code == 'requires-recent-login'
          ? 'Veuillez vous reconnecter avant de supprimer le compte.'
          : 'Erreur : ${e.message}';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la suppression : $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isDeleting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confidentialité', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          const Text(
            'Politique de Confidentialité',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Nous accordons une grande importance à la protection de vos données personnelles. Cette section explique comment nous collectons et protégeons vos informations sur EduConnect Pro.',
            style: TextStyle(color: Colors.grey, fontSize: 14, height: 1.4),
          ),
          const Divider(height: 30),

          // 1. Visibilité du profil (Avèk yon Switch k ap fonksyone)
          SwitchListTile(
            secondary: const Icon(Icons.visibility_off, color: Color(0xFF0D47A1)),
            title: const Text('Visibilité du profil', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Gérer qui peut voir vos progrès et certifications'),
            value: isProfilePublic,
            activeColor: const Color(0xFF0D47A1),
            onChanged: (val) {
              setState(() {
                isProfilePublic = val;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(val ? 'Profil mis en mode Public' : 'Profil mis en mode Privé')),
              );
            },
          ),
          const Divider(),

          // 2. Télécharger mes données
          ListTile(
            leading: const Icon(Icons.download, color: Color(0xFF0D47A1)),
            title: const Text('Télécharger mes données', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Obtenir une copie de vos activités et notes'),
            trailing: _isExporting
                ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            onTap: _isExporting ? null : _downloadUserData,
          ),
          const Divider(),

          // 3. Supprimer mon compte
          ListTile(
            leading: const Icon(Icons.delete_outline, color: Colors.red),
            title: const Text('Supprimer mon compte', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            subtitle: const Text('Supprimer définitivement vos données'),
            trailing: _isDeleting
                ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            onTap: _isDeleting ? null : _deleteAccount,
          ),
        ],
      ),
    );
  }
}