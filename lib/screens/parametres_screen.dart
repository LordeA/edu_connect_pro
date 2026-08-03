// ============================================================
// EduConnect Pro — Paramètres & Sous-écrans (Confidentialité & Sécurité)
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:edu_connect_pro/providers/theme_provider.dart';

class ParametresScreen extends StatefulWidget {
  const ParametresScreen({super.key});

  @override
  State<ParametresScreen> createState() => _ParametresScreenState();
}

class _ParametresScreenState extends State<ParametresScreen> {
  bool notificationsEnabled = true;
  String selectedLanguage = 'Français';

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Paramètres',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        children: [
          // 1. Mode Sombre
          _buildParamCard(
            title: 'Mode Sombre',
            trailing: Switch(
              value: themeProvider.isDarkMode,
              activeColor: Colors.deepPurple,
              onChanged: (value) => themeProvider.toggleTheme(value),
            ),
          ),
          const SizedBox(height: 12),

          // 2. Langue
          _buildParamCard(
            title: 'Langue',
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  selectedLanguage,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              ],
            ),
            onTap: () {
              showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('Choisir une langue', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    ListTile(
                      title: const Text("Français"),
                      trailing: selectedLanguage == 'Français' ? const Icon(Icons.check, color: Colors.blue) : null,
                      onTap: () {
                        setState(() => selectedLanguage = 'Français');
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      title: const Text("Kreyòl"),
                      trailing: selectedLanguage == 'Kreyòl' ? const Icon(Icons.check, color: Colors.blue) : null,
                      onTap: () {
                        setState(() => selectedLanguage = 'Kreyòl');
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 12),

          // 3. Notifications
          _buildParamCard(
            title: 'Notifications',
            trailing: Switch(
              value: notificationsEnabled,
              activeColor: Colors.deepPurple,
              onChanged: (value) {
                setState(() {
                  notificationsEnabled = value;
                });
              },
            ),
          ),
          const SizedBox(height: 12),

          // 4. Confidentialité
          _buildParamCard(
            title: 'Confidentialité',
            trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PrivacyScreen()),
              );
            },
          ),
          const SizedBox(height: 12),

          // 5. Sécurité
          _buildParamCard(
            title: 'Sécurité',
            trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SecurityScreen()),
              );
            },
          ),
          const SizedBox(height: 12),

          // 6. A Propos
          _buildParamCard(
            title: 'A Propos',
            trailing: const Text(
              'Version 1.0.0',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParamCard({
    required String title,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: Colors.black87,
          ),
        ),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }
}

// ==========================================
// EKRAN POU CONFIDENTIALITÉ (Fonksyonèl)
// ==========================================
class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  bool isProfilePublic = true;

  void _handleDownloadData() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Télécharger mes données'),
        content: const Text('Souhaitez-vous demander l’export de vos données personnelles et activités ?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('La demande de téléchargement a été envoyée. Vérifiez votre email bientôt.')),
              );
            },
            child: const Text('Télécharger'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleDeleteAccount() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer mon compte'),
        content: const Text('Êtes-vous sûr de vouloir supprimer votre compte ? Cette action est irréversible.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuler')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Votre compte a été supprimé avec succès.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Confidentialité')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('Politique de Confidentialité', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          const Text(
            'Nous accordons une grande importance à la protection de vos données personnelles. Cette section explique comment nous collectons et protégeons vos informations sur EduConnect Pro.',
            style: TextStyle(fontSize: 15, height: 1.5, color: Colors.grey),
          ),
          const Divider(height: 40),
          
          // Visibilite du profil
          SwitchListTile(
            title: const Text('Visibilité du profil', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Gérer qui peut voir vos progrès et certifications'),
            value: isProfilePublic,
            activeColor: Colors.blue,
            onChanged: (val) {
              setState(() => isProfilePublic = val);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(val ? 'Profil mis en mode Public' : 'Profil mis en mode Privé')),
              );
            },
          ),
          const Divider(),

          // Télécharger mes données
          ListTile(
            leading: const Icon(Icons.download, color: Colors.blue),
            title: const Text('Télécharger mes données', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Obtenir une copie de vos activités et notes'),
            onTap: _handleDownloadData,
          ),
          const Divider(),

          // Supprimer mon compte
          ListTile(
            leading: const Icon(Icons.delete_forever, color: Colors.red),
            title: const Text('Supprimer mon compte', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            subtitle: const Text('Supprimer définitivement vos données'),
            onTap: _handleDeleteAccount,
          ),
        ],
      ),
    );
  }
}

// ==========================================
// EKRAN POU SÉCURITÉ (Fonksyonèl ak Chanjman Modpas, 2FA, ak Aparèy)
// ==========================================
class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  bool isTwoFactorEnabled = false;

  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Changer le mot de passe'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _oldPasswordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Ancien mot de passe'),
                validator: (val) => val!.isEmpty ? 'Entrez l\'ancien mot de passe' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Nouveau mot de passe'),
                validator: (val) => val!.length < 6 ? 'Minimum 6 caractères' : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Mot de passe mis à jour avec succès !')),
                );
                _oldPasswordController.clear();
                _newPasswordController.clear();
              }
            },
            child: const Text('Confirmer'),
          ),
        ],
      ),
    );
  }

  void _showConnectedDevicesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Appareils connectés'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: [
              ListTile(
                leading: const Icon(Icons.phone_android, color: Colors.green),
                title: const Text('Tecno Spark (Actuel)'),
                subtitle: const Text('Port-au-Prince, Haïti'),
                trailing: const Text('Actif', style: TextStyle(color: Colors.green)),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.laptop, color: Colors.grey),
                title: const Text('Windows PC - Chrome'),
                subtitle: const Text('Dernière connexion: Hier'),
                trailing: IconButton(
                  icon: const Icon(Icons.logout, color: Colors.red),
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Appareil déconnecté avec succès.')),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Fermer')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sécurité')),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          const Text('Paramètres de Sécurité', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),

          // 1. Changer le mot de passe
          ListTile(
            leading: const Icon(Icons.lock, color: Colors.blue),
            title: const Text('Changer le mot de passe', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Mettre à jour votre mot de passe actuel'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: _showChangePasswordDialog,
          ),
          const Divider(),

          // 2. Authentification à deux facteurs (2FA) On/Off
          SwitchListTile(
            secondary: const Icon(Icons.security, color: Colors.indigo),
            title: const Text('Authentification à deux facteurs', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Ajouter une couche de sécurité supplémentaire'),
            value: isTwoFactorEnabled,
            activeColor: Colors.blue,
            onChanged: (val) {
              setState(() => isTwoFactorEnabled = val);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(val ? '2FA activée avec succès !' : '2FA désactivée.')),
              );
            },
          ),
          const Divider(),

          // 3. Appareils connectés
          ListTile(
            leading: const Icon(Icons.devices, color: Colors.orange),
            title: const Text('Appareils connectés', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Gérer les sessions actives sur vos appareils'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: _showConnectedDevicesDialog,
          ),
        ],
      ),
    );
  }
}