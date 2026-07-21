import 'package:flutter/material.dart';
import '../forum/forum_screen.dart';
import '../courses/course_catalog_screen.dart';
import '../quiz_list_screen.dart';
import '../badges_list_screen.dart';// Asire w chemen import sa yo koresponn ak kote dosye sa yo ye nan pwojè w

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreatePostDialog(context),
        backgroundColor: const Color(0xFF0D47A1),
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                'Notifications',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              
              Expanded(
                child: ListView(
                  children: [
                    _buildNotificationCard(
                      isDark: isDark,
                      icon: Icons.favorite,
                      iconColor: Colors.white,
                      bgColor: Colors.purple,
                      title: 'Nouvelle réponse',
                      subtitle: 'Votre question a une réponse',
                      time: 'Il y a 2m',
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ForumScreen())),
                    ),

                    _buildNotificationCard(
                      isDark: isDark,
                      icon: Icons.check,
                      iconColor: Colors.white,
                      bgColor: Colors.blue,
                      title: 'Nouveau cours disponible',
                      subtitle: 'Cisco Routing',
                      time: 'Il y a 1h',
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CourseCatalogScreen())),
                    ),

                    _buildNotificationCard(
                      isDark: isDark,
                      isCustomQuizIcon: true,
                      title: 'Quiz disponible',
                      subtitle: 'Quiz Flutter Avancé',
                      time: 'Il y a 2h',
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const QuizListScreen())),
                    ),

                    _buildNotificationCard(
                      isDark: isDark,
                      icon: Icons.shield,
                      iconColor: Colors.amber[700]!,
                      bgColor: Colors.amber.withOpacity(0.2),
                      title: 'Nouveau badge obtenu',
                      subtitle: 'Maitrise Dart',
                      time: 'Il y a 5h',
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BadgesListScreen())),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCreatePostDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nouvelle Publication'),
        content: const TextField(
          decoration: InputDecoration(hintText: 'Qu est-ce que vous voulez partager dans le forum?'),
          maxLines: 3,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Post publié avec succès !')),
              );
            },
            child: const Text('Publier'),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard({
    required bool isDark,
    IconData? icon,
    Color iconColor = Colors.transparent,
    Color bgColor = Colors.transparent,
    required String title,
    required String subtitle,
    required String time,
    required VoidCallback onTap,
    bool isCustomQuizIcon = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                isCustomQuizIcon
                    ? const SizedBox(width: 50, height: 50, child: Center(child: Text('quiz', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 18))))
                    : Container(width: 50, height: 50, decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle), child: Icon(icon, color: iconColor, size: 26)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)),
                      const SizedBox(height: 4),
                      Text(subtitle, style: TextStyle(fontSize: 13, color: isDark ? Colors.grey[400] : Colors.grey[600])),
                      const SizedBox(height: 4),
                      Text(time, style: TextStyle(fontSize: 11, color: isDark ? Colors.grey[500] : Colors.grey[400])),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}