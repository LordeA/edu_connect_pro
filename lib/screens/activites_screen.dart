import 'package:flutter/material.dart';

class ActivitesScreen extends StatelessWidget {
  const ActivitesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes activités', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildActivityTile(
            icon: Icons.check_circle,
            iconColor: Colors.green,
            title: 'Quiz Algorithmique terminé',
            subtitle: 'Score: 90% - Il y a 2 jours',
            isDark: isDark,
          ),
          _buildActivityTile(
            icon: Icons.menu_book,
            iconColor: Colors.blue,
            title: 'Chapitre 3 validé',
            subtitle: 'Conception UI/UX - Il y a 3 jours',
            isDark: isDark,
          ),
          _buildActivityTile(
            icon: Icons.forum,
            iconColor: Colors.purple,
            title: 'Commentaire publié dans le Forum',
            subtitle: 'Sujet: Erreur d\'importation Dart - Il y a 5 jours',
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildActivityTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool isDark,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: iconColor.withOpacity(0.1),
          child: Icon(icon, color: iconColor),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      ),
    );
  }
}