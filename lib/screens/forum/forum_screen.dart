import 'package:flutter/material.dart';
import 'forum_details_screen.dart';
import '../courses/course_catalog_screen.dart';
import '../notifications/notifications_screen.dart';
import '../profile_screen.dart';
import '../dashboard/student_dashboard.dart';

class ForumScreen extends StatefulWidget {
  const ForumScreen({super.key});

  @override
  State<ForumScreen> createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  int _selectedTab = 0; // 0 pou Discussions, 1 pou Mes questions
  final int _currentIndex = 2; // Forum se endis 2

  // Lis ki gen tout diskisyon yo (Nou fè l vin dinamik ak State)
  final List<Map<String, dynamic>> _discussions = [
    {
      'title': 'Comment gérer l\'état avec Provider?',
      'author': 'Moise Rebecca - il y a 2h',
      'count': '6',
      'avatarColor': Colors.indigo,
    },
    {
      'title': 'Problème avec l\'animation',
      'author': 'Jean Bercy - il y a 5h',
      'count': '3',
      'avatarColor': Colors.pink,
    },
    {
      'title': 'Meilleure architecture pour un projet Flutter',
      'author': 'Joseph Milouse - il y a 1 jour',
      'count': '7',
      'avatarColor': Colors.deepPurple,
    },
  ];

  // Fonksyon pou jere navigasyon ba anba a
  void _onItemTapped(int index) {
    if (index == _currentIndex) return;

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const StudentDashboard(userId: 'VALÈ_ID_LA')),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const CourseCatalogScreen()),
      );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const NotificationScreen()),
      );
    } else if (index == 4) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ProfileScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Si _selectedTab se 1, nou filtre pou nou wè sèlman kesyon itilizatè a (Moi)
    List<Map<String, dynamic>> displayedDiscussions = _selectedTab == 0
        ? _discussions
        : _discussions.where((item) => item['author'].toString().contains('Moi')).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Forum - Flutter & Dart',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Bouton Onglets (Discussions / Mes questions)
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedTab = 0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _selectedTab == 0 ? const Color(0xFF0D47A1) : Colors.grey[200],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Discussions',
                        style: TextStyle(
                          color: _selectedTab == 0 ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedTab = 1),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _selectedTab == 1 ? const Color(0xFF0D47A1) : Colors.grey[200],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Mes questions',
                        style: TextStyle(
                          color: _selectedTab == 1 ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Lis Kat yo
          Expanded(
            child: displayedDiscussions.isEmpty
                ? const Center(
                    child: Text(
                      'Ou poko poze okenn kesyon.',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: displayedDiscussions.length,
                    itemBuilder: (context, index) {
                      final item = displayedDiscussions[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ForumDetailsScreen(question: item),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 14),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundColor: item['avatarColor'],
                                child: const Icon(Icons.person, color: Colors.white),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['title'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      item['author'],
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              CircleAvatar(
                                radius: 16,
                                backgroundColor: const Color(0xFF0D47A1),
                                child: Text(
                                  item['count'],
                                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      
      // Bouton Flotan (+) pou pibliye vre
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final TextEditingController titleController = TextEditingController();

          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                left: 20,
                right: 20,
                top: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Poze yon kesyon',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: titleController,
                    autofocus: true,
                    decoration: const InputDecoration(
                      labelText: 'Tit kesyon an',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () {
                      if (titleController.text.trim().isNotEmpty) {
                        setState(() {
                          // Ajoute nouvo kesyon an nan lis la kòm "Moi"
                          _discussions.insert(0, {
                            'title': titleController.text.trim(),
                            'author': 'Moi - à l\'instant',
                            'count': '0',
                            'avatarColor': Colors.teal,
                          });
                        });
                        Navigator.pop(context); // Fèmen modal la
                        
                        // Si nou te nan onglè "Mes questions", nou ka mete l pou l rete la
                        setState(() {
                          _selectedTab = 1;
                        });
                      }
                    },
                    child: const Text('Publiye'),
                  ),
                ],
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}