import 'package:flutter/material.dart';
// Enpòte paj ou yo isit la:
import 'package:edu_connect_pro/screens/modifier_profil_screen.dart';
import 'package:edu_connect_pro/screens/certificats_screen.dart';
import 'package:edu_connect_pro/screens/activites_screen.dart';
import 'package:edu_connect_pro/screens/aide_support_screen.dart';
import 'package:edu_connect_pro/screens/parametres_screen.dart';

class ProfileScreen extends StatelessWidget {
  final String userId;
  const ProfileScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 1. Pati ble anwo a
        Container(
          height: 300,
          color: Colors.blue,
        ),
        
        // 2. Kontni ki parèt anlè
        Column(
          children: [
            const SizedBox(height: 100),
            // Foto Profil
            const CircleAvatar(
              radius: 60,
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 80, color: Colors.blue),
            ),
            const SizedBox(height: 20),
            
            // Pati blan ki gen estatistik ak lis
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: ListView(
                  padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
                  children: [
                    // Estatistik yo
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStat("12", "Cours réussis"),
                        _buildStat("75%", "Progression"),
                        _buildStat("8", "Badges"),
                      ],
                    ),
                    const SizedBox(height: 30),
                    
                    // Opsyon yo ak navigasyon
                    _buildMenuOption(context, Icons.person_outline, "Modifier le profil", () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const ModifierProfilScreen()));
                    }),
                    _buildMenuOption(context, Icons.badge_outlined, "Mes Certificats", () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const CertificatesScreen()));
                    }),
                    _buildMenuOption(context, Icons.settings_outlined, "Mes activités", () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const ActivitesScreen()));
                    }),
                    _buildMenuOption(context, Icons.help_outline, "Aide & Support", () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const AideSupportScreen()));
                    }),
                    _buildMenuOption(context, Icons.help_outline, "Parametres", () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const ParametresScreen()));
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStat(String val, String label) {
    return Column(children: [
      Text(val, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      Text(label, style: const TextStyle(color: Colors.grey)),
    ]);
  }

  Widget _buildMenuOption(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap, // Isit la nou itilize fonksyon nou pase a
    );
  }
}