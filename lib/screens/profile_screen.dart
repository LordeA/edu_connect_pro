import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:edu_connect_pro/providers/theme_provider.dart';// Asire w chemen sa a bon pou ThemeProvider

// ==========================================
// 1. EKRAN PWOFIL PRENSIPAL LA
// ==========================================
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Theme.of(context).scaffoldBackgroundColor : Colors.white,
      body: Column(
        children: [
          // Seksyon Ble a ak Foto Pwofil la
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFF0D47A1), // Ble fonse
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      const CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person, size: 80, color: Colors.grey),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    FirebaseAuth.instance.currentUser?.displayName ?? 'Utilisateur',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 20),

          // Seksyon Estatistik yo
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatItem(context, '12', 'Cours réussis'),
                _buildStatItem(context, '75%', 'Progression'),
                _buildStatItem(context, '8', 'Badges'),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // Seksyon Meni yo
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              children: [
                _buildMenuItem(
                  context,
                  icon: Icons.person_outline,
                  title: 'Modifier le profil',
                  destination: const EditProfileScreen(),
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.workspace_premium_outlined,
                  title: 'Mes Certificats',
                  destination: const CertificatesScreen(),
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.settings_outlined,
                  title: 'Mes activités',
                  destination: const ActivitiesScreen(),
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.help_outline,
                  title: 'Aide & Support',
                  destination: const SupportScreen(),
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.settings,
                  title: 'Parametres',
                  destination: const ParametresScreen(),
                ),
                
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildMenuItem(BuildContext context, {required IconData icon, required String title, required Widget destination}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: 2,
      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Icon(icon, color: isDark ? Colors.white : Colors.black87),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destination),
          );
        },
      ),
    );
  }
}

// ==========================================
// 2. ECRAN POUR MODIFIER LE PROFIL
// ==========================================
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _user = FirebaseAuth.instance.currentUser;
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: _user?.displayName ?? '');
    _emailController = TextEditingController(text: _user?.email ?? '');
    _phoneController = TextEditingController(text: _user?.phoneNumber ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      if (_user != null) {
        if (_nameController.text.trim() != _user.displayName) {
          await _user.updateDisplayName(_nameController.text.trim());
        }

        if (_emailController.text.trim() != _user.email) {
          await _user.verifyBeforeUpdateEmail(_emailController.text.trim());
        }

        // Si vous utilisez la mise à jour du numéro de téléphone via Firebase Auth, ajoutez ici la logique.
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profil mis à jour avec succès !'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la mise à jour : $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Modifier le profil')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const CircleAvatar(
                radius: 50,
                child: Icon(Icons.person, size: 50),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nom complet', border: OutlineInputBorder()),
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"[a-zA-ZÀ-ÖØ-öø-ÿ\s'-]"))],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Ce champ est obligatoire.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Ce champ est obligatoire.';
                  }
                  final emailRegex = RegExp(r'^[\w.-]+@([\w-]+\.)+[a-zA-Z]{2,}$');
                  if (!emailRegex.hasMatch(value.trim())) {
                    return 'Veuillez entrer un email valide.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(labelText: 'Téléphone', border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Ce champ est obligatoire.';
                  }
                  if (value.trim().length < 8) {
                    return 'Entrez un numéro de téléphone valide.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveProfile,
                  style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  child: _isSaving
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Sauvegarder les modifications'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 3. EKRAN MES CERTIFICATS
// ==========================================
class CertificatesScreen extends StatelessWidget {
  const CertificatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mes Certificats')),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
              title: const Text('Certificat : Programmation Dart'),
              subtitle: const Text('Obtenu le 10 Janvier 2026'),
              trailing: IconButton(
                icon: const Icon(Icons.download, color: Colors.blue),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Téléchargement du certificat en cours...')),
                  );
                },
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
              title: const Text('Certificat : Flutter UI Design'),
              subtitle: const Text('Obtenu le 22 Février 2026'),
              trailing: IconButton(
                icon: const Icon(Icons.download, color: Colors.blue),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Téléchargement du certificat en cours...')),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// 4. EKRAN MES ACTIVITÉS
// ==========================================
class ActivitiesScreen extends StatelessWidget {
  const ActivitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mes activités')),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          const Text(
            'Badges Gagnés',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildBadge(Icons.emoji_events, Colors.amber, 'Expert'),
              _buildBadge(Icons.star, Colors.orange, 'Niveau 1'),
              _buildBadge(Icons.star, Colors.blue, 'Contributeur'),
              _buildBadge(Icons.star, Colors.green, 'Assidu'),
            ],
          ),
          const Divider(height: 40),
          const Text(
            'Historique Récent',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const ListTile(
            leading: Icon(Icons.check_circle, color: Colors.green),
            title: Text('A terminé le module "State Management"'),
            subtitle: Text('Il y a 2 jours'),
          ),
          const ListTile(
            leading: Icon(Icons.forum, color: Colors.blue),
            title: Text('A posé une question dans le forum'),
            subtitle: Text('Il y a 5 jours'),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(IconData icon, Color color, String label) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          radius: 30,
          child: Icon(icon, color: color, size: 30),
        ),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

// ==========================================
// 5. EKRAN AIDE & SUPPORT
// ==========================================
class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Aide & Support')),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: const [
          ExpansionTile(
            title: Text('Comment réinitialiser mon mot de passe ?'),
            children: [
              Padding(
                padding: EdgeInsets.all(15.0),
                child: Text('Allez dans les paramètres de connexion et cliquez sur "Mot de passe oublié". Vous recevrez un lien par email.'),
              )
            ],
          ),
          ExpansionTile(
            title: Text('Où se trouvent mes certificats téléchargés ?'),
            children: [
              Padding(
                padding: EdgeInsets.all(15.0),
                child: Text('Vos certificats sont sauvegardés dans le dossier "Téléchargements" de votre téléphone.'),
              )
            ],
          ),
          SizedBox(height: 30),
          ListTile(
            leading: Icon(Icons.email),
            title: Text('Contacter le support'),
            subtitle: Text('support@educonnectpro.com'),
          )
        ],
      ),
    );
  }
}

// ==========================================
// 6. EKRAN PARAMÈTRES
// ==========================================
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
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF7F9FC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Paramètres',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
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
            context: context,
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
            context: context,
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
            context: context,
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
            context: context,
            title: 'Confidentialité',
            trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ConfidentialiteScreen()),
              );
            },
          ),
          const SizedBox(height: 12),

          // 5. Sécurité
          _buildParamCard(
            context: context,
            title: 'Sécurité',
            trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SecuriteScreen()),
              );
            },
          ),
          const SizedBox(height: 12),

          // 6. À Propos
          _buildParamCard(
            context: context,
            title: 'À Propos',
            trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AProposScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildParamCard({
    required BuildContext context,
    required String title,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          if (!isDark)
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
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }
}

// ==========================================
// 7. EKRAN CONFIDENTIALITÉ (AN FRANÇAIS)
// ==========================================
class ConfidentialiteScreen extends StatelessWidget {
  const ConfidentialiteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Confidentialité')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          Text(
            'Politique de Confidentialité',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 15),
          Text(
            'Nous accordons une grande importance à la protection de vos données personnelles. Cette section explique comment nous collectons et protégeons vos informations sur EduConnect Pro.',
            style: TextStyle(fontSize: 15, height: 1.5),
          ),
          SizedBox(height: 20),
          Divider(),
          ListTile(
            leading: Icon(Icons.visibility_off_outlined, color: Colors.indigo),
            title: Text('Visibilité du profil'),
            subtitle: Text('Gérer qui peut voir vos progrès et certifications'),
          ),
          ListTile(
            leading: Icon(Icons.download_outlined, color: Colors.indigo),
            title: Text('Télécharger mes données'),
            subtitle: Text('Obtenir une copie de vos activités et notes'),
          ),
          ListTile(
            leading: Icon(Icons.delete_forever_outlined, color: Colors.red),
            title: Text('Supprimer mon compte', style: TextStyle(color: Colors.red)),
            subtitle: Text('Supprimer définitivement vos données'),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// 8. EKRAN SÉCURITÉ (AN FRANÇAIS)
// ==========================================
class SecuriteScreen extends StatelessWidget {
  const SecuriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sécurité')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Paramètres de Sécurité',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          const ListTile(
            leading: Icon(Icons.lock_outline, color: Colors.indigo),
            title: Text('Changer le mot de passe'),
            subtitle: Text('Mettre à jour votre mot de passe actuel'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
          ),
          const Divider(),
          SwitchListTile(
            secondary: const Icon(Icons.verified_user_outlined, color: Colors.indigo),
            title: const Text('Authentification à deux facteurs'),
            subtitle: const Text('Ajouter une couche de sécurité supplémentaire'),
            value: false,
            onChanged: (val) {},
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.devices_outlined, color: Colors.indigo),
            title: Text('Appareils connectés'),
            subtitle: Text('Gérer les sessions actives sur vos appareils'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// 9. EKRAN À PROPOS (AN FRANÇAIS)
// ==========================================
class AProposScreen extends StatelessWidget {
  const AProposScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('À Propos')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Icon(Icons.school, size: 80, color: Colors.indigo),
            const SizedBox(height: 10),
            const Text(
              'EduConnect Pro',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Version 1.0.0',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            const Text(
              'EduConnect Pro est une plateforme éducative moderne conçue pour faciliter l\'apprentissage en ligne, le suivi des cours et la gestion des certifications pour les étudiants.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, height: 1.5),
            ),
            const Spacer(),
            const Text(
              '© 2026 EduConnect Pro. Tous droits réservés.',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}