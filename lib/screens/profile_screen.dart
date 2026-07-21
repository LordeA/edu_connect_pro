import 'package:edu_connect_pro/screens/parametres_screen.dart';
import 'package:flutter/material.dart';

// ==========================================
// 1. EKRAN PWOFIL PRENSIPAL LA
// ==========================================
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Seksyon Ble a ak Foto Pwofil la
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFF0D47A1), // Ble fonse tankou nan imaj la
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
                  const Text(
                    'Marc Junior',
                    style: TextStyle(
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
                _buildStatItem('12', 'Cours réussis'),
                _buildStatItem('75%', 'Progression'),
                _buildStatItem('8', 'Badges'),
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

  Widget _buildStatItem(String value, String label) {
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
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Icon(icon, color: Colors.black87),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600),
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
// 2. EKRAN POU MODIFIE PWOFOFIL LA
// ==========================================
class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Modifier le profil')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              child: Icon(Icons.person, size: 50),
            ),
            const SizedBox(height: 20),
            TextFormField(
              initialValue: 'Marc Junior',
              decoration: const InputDecoration(labelText: 'Nom Complet', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 15),
            TextFormField(
              initialValue: 'marc@email.com',
              decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Sauvegarder les modifications'),
            )
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 3. EKRAN POU WÈ AK TELECHAJE SÈTIFIKA YO
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
// 4. EKRAN POU WÈ AKTIVITE AK BADJ YO (Akeyi Tas la kòm prensipal)
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
              _buildBadge(Icons.emoji_events, Colors.amber, 'Expert'), // Tas la kòm prensipal
              _buildBadge(Icons.star, Colors.orange, 'Niveau 1'),      // Rès yo kòm etwal
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
// 5. EKRAN POU ÈD AK SIPÒ
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
// 6. EKRAN PARAMÈT (ParametresScreen)
// ==========================================
class ParametresScreen extends StatelessWidget {
  const ParametresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Paramètres')),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          const SwitchListTile(
            title: Text('Notifications Push'),
            subtitle: Text('Recevoir des alertes pour les cours et messages'),
            value: true,
            onChanged: null, // Ajoute lojik ou la
          ),
          const SwitchListTile(
            title: Text('Mode Sombre (Dark Mode)'),
            subtitle: Text('Activer le thème sombre'),
            value: false,
            onChanged: null, // Ajoute lojik ou la
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.language, color: Colors.blue),
            title: const Text('Langue'),
            trailing: const Text('Français', style: TextStyle(color: Colors.grey)),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.lock_outline, color: Colors.orange),
            title: const Text('Changer le mot de passe'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app, color: Colors.red),
            title: const Text('Déconnexion', style: TextStyle(color: Colors.red)),
            onTap: () {
              // Lojik pou dekoupe itilizatè a
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}