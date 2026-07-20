import 'package:flutter/material.dart';

class BadgesListScreen extends StatelessWidget { // Non klas la chanje pou l koresponn ak non fichye a
  const BadgesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mes Badges')),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        children: [
          _buildBadgeItem('Maitrise Dart', Icons.shield, Colors.amber),
          _buildBadgeItem('Flutter Pro', Icons.emoji_events, Colors.blue),
        ],
      ),
    );
  }

  Widget _buildBadgeItem(String title, IconData icon, Color color) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 50, color: color),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}