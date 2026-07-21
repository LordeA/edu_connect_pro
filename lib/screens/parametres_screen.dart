import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:edu_connect_pro/main.dart'; // Asire w chemen sa a bon

class ParametresScreen extends StatefulWidget {
  const ParametresScreen({super.key});

  @override
  State<ParametresScreen> createState() => _ParametresScreenState();
}

class _ParametresScreenState extends State<ParametresScreen> {
  bool isNotificationsEnabled = true;
  String selectedLanguage = 'Français'; // Lang ki parèt pa defo a

  @override
  Widget build(BuildContext context) {
    // Provider ou a pou jere Mode Sombre la
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // 1. Mode Sombre (Ak Provider pa w la)
          _buildSettingsCard(
            title: 'Mode Sombre',
            trailing: Switch(
              value: themeProvider.isDarkMode,
              activeColor: Colors.indigo,
              onChanged: (value) => themeProvider.toggleTheme(value),
            ),
          ),

          // 2. Langue (Ak BottomSheet pa w la)
          _buildSettingsCard(
            title: 'Langue',
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(selectedLanguage, style: const TextStyle(color: Colors.grey)),
                const SizedBox(width: 5),
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

          // 3. Notifications
          _buildSettingsCard(
            title: 'Notifications',
            trailing: Switch(
              value: isNotificationsEnabled,
              activeColor: Colors.indigo,
              onChanged: (value) {
                setState(() {
                  isNotificationsEnabled = value;
                });
              },
            ),
          ),

          // 4. Confidentialité
          _buildSettingsCard(
            title: 'Confidentialité',
            trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PrivacyScreen()),
              );
            },
          ),

          // 5. Sécurité
          _buildSettingsCard(
            title: 'Sécurité',
            trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SecurityScreen()),
              );
            },
          ),

          // 6. A Propos
          _buildSettingsCard(
            title: 'A Propos',
            trailing: const Text('Version 1.0.0', style: TextStyle(color: Colors.grey)),
            onTap: () {
              // Ou ka mete yon aksyon la si w vle
            },
          ),
        ],
      ),
    );
  }

  // Ti fonksyon pou desine chak bwat yo ak fòm awondi a, ki adapte ak Dark Mode la tou
  Widget _buildSettingsCard({required String title, required Widget trailing, VoidCallback? onTap}) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }
}

// ==========================================
// EKRAN POU CONFIDENTIALITÉ
// ==========================================
class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Confidentialité')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          Text('Politique de Confidentialité', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 15),
          Text(
            'Vos données personnelles sont protégées. Nous utilisons vos informations uniquement pour améliorer votre expérience d\'apprentissage sur la plateforme. \n\nAucune donnée n\'est partagée avec des tiers sans votre consentement.',
            style: TextStyle(fontSize: 16, height: 1.5),
          ),
          SizedBox(height: 20),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.download),
            title: Text('Télécharger mes données'),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.delete_forever, color: Colors.red),
            title: Text('Supprimer mon compte', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// EKRAN POU SÉCURITÉ
// ==========================================
class SecurityScreen extends StatelessWidget {
  const SecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sécurité')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.lock_outline),
            title: Text('Changer de mot de passe'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
          ),
          const Divider(),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.security),
            title: const Text('Authentification à deux facteurs'),
            trailing: Switch(
              value: false, 
              onChanged: (val) {},
            ),
          ),
          const Divider(),
          const ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.devices),
            title: Text('Appareils connectés'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
          ),
        ],
      ),
    );
  }
}