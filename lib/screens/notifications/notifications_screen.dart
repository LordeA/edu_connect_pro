import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Notifications', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildNotificationItem(Icons.chat_bubble, Colors.purple, 'Nouvelle réponse', 'Votre question a une réponse - Il y a 20m'),
          _buildNotificationItem(Icons.check_circle, Colors.blue, 'Nouveau cours disponible', 'Design system UI/UX - Il y a 2h'),
          _buildNotificationItem(Icons.assignment, Colors.orange, 'Quiz disponible', 'Quiz Flutter Avancé - Il y a 3h'),
          _buildNotificationItem(Icons.emoji_events, Colors.amber, 'Nouveau badge obtenu', 'Maîtrise Dart - Il y a 5h'),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(IconData icon, Color color, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: color.withOpacity(0.1), child: Icon(icon, color: color)),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}