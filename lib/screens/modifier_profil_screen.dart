import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ModifierProfilScreen extends StatefulWidget {
  const ModifierProfilScreen({super.key});

  @override
  State<ModifierProfilScreen> createState() => _ModifierProfilScreenState();
}

class _ModifierProfilScreenState extends State<ModifierProfilScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Pran enfòmasyon itilizatè ki konekte kounye a nan Firebase si l egziste
  final User? currentUser = FirebaseAuth.instance.currentUser;

  late final TextEditingController _nomController;
  late final TextEditingController _emailController;
  late final TextEditingController _telController;
  
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Inisyalize chan yo ak vrè enfòmasyon itilizatè a (oswa tèks pa defo)
    _nomController = TextEditingController(text: currentUser?.displayName ?? 'Elève Junior');
    _emailController = TextEditingController(text: currentUser?.email ?? 'junior@educonnect.com');
    _telController = TextEditingController(text: currentUser?.phoneNumber ?? '+509 3333-3333');
  }

  @override
  void dispose() {
    _nomController.dispose();
    _emailController.dispose();
    _telController.dispose();
    super.dispose();
  }

  // Fonksyon pou anrejistre modifikasyon yo
  Future<void> _saveProfileChanges() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez corriger les champs en erreur avant de continuer.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      if (currentUser != null) {
        if (_nomController.text.trim() != currentUser!.displayName) {
          await currentUser!.updateDisplayName(_nomController.text.trim());
        }

        if (_emailController.text.trim() != currentUser!.email) {
          await currentUser!.verifyBeforeUpdateEmail(_emailController.text.trim());
        }
      }

      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Profil mis à jour avec succès !'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Erreur lors de la mise à jour : $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier le profil', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey,
                    backgroundImage: NetworkImage('https://via.placeholder.com/150'),
                  ),
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: const Color(0xFF0D47A1),
                    child: const Icon(Icons.edit, color: Colors.white, size: 16),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              
              // Nom complet
              TextFormField(
                controller: _nomController,
                decoration: _buildInputDecoration('Nom Complet', isDark),
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"[a-zA-ZÀ-ÖØ-öø-ÿ\s'-]"))],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Silvouplè, antre non ou';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Email (Avèk validasyon strik pou '@' ak pwen an)
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: _buildInputDecoration('Email', isDark),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Veuillez entrer votre email';
                  }
                  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[a-zA-Z]{2,}$');
                  if (!emailRegex.hasMatch(value.trim())) {
                    return 'Adresse email invalide (le "@" ou le domaine est manquant)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Téléphone
              TextFormField(
                controller: _telController,
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: _buildInputDecoration('Téléphone', isDark),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Silvouplè, antre nimewo telefòn ou';
                  }
                  if (value.trim().length < 8) {
                    return 'Nimewo telefòn lan dwe gen omwen 8 chif';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),
              
              // Bouton Enregistrer ak Loading
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveProfileChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D47A1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text(
                          'Sauvegarder les modifications',
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label, bool isDark) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: isDark ? Colors.grey[900] : Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      errorStyle: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
    );
  }
}