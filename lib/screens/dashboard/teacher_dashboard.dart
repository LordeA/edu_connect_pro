// ============================================================
// EduConnect Pro — TeacherDashboard (Fonctionnel)
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:edu_connect_pro/providers/auth_provider.dart';
import '../auth/login_screen.dart'; // Importation pour l'écran de connexion

class TeacherDashboard extends StatefulWidget {
  const TeacherDashboard({super.key});

  @override
  State<TeacherDashboard> createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {
  int _currentIndex = 0;

  void _setTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _buildPage() {
    switch (_currentIndex) {
      case 0:
        return TeacherHomeBody(onSectionTap: _setTab);
      case 1:
        return const TeacherCoursesBody();
      case 2:
        return const TeacherAddCourseBody();
      case 3:
        return const TeacherStudentsBody();
      case 4:
        return const TeacherProfileBody();
      default:
        return TeacherHomeBody(onSectionTap: _setTab);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: _buildPage(),
      
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF0D47A1),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Cours'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle, size: 35, color: Color(0xFF0D47A1)), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Étudiants'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------
// Widget pour le contenu principal du dashboard enseignant
// ------------------------------------------------------------
class TeacherHomeBody extends StatelessWidget {
  final void Function(int)? onSectionTap;

  const TeacherHomeBody({super.key, this.onSectionTap});

  // Boîte de confirmation de déconnexion
  void showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text(
            'Dekoneksyon',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text('Èske w sèten ou vle dekonekte w nan aplikasyon an?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Anile', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              },
              child: const Text('Wi, dekonekte', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. En-tête du profil avec icône de notification et déconnexion
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.blue,
                      child: Icon(Icons.person, color: Colors.white, size: 30),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Bonjour,', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                        Text(
                          context.watch<AuthProvider>().nom ?? 'Professeur',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.notifications_none, size: 28),
                    const SizedBox(width: 8),
                    // Bouton dekoneksyon an ak yon bèl ti icon wouj
                    IconButton(
                      icon: const Icon(Icons.logout, color: Colors.red, size: 26),
                      onPressed: () => showLogoutConfirmation(context),
                      tooltip: 'Se déconnecter',
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),

            // 2. Les trois cartes de statistiques
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatBox('12', 'Cours créés'),
                _buildStatBox('36', 'Étudiants'),
                _buildStatBox('8', 'Quiz créés'),
              ],
            ),
            const SizedBox(height: 30),

            // 3. Section graphique
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Statistique', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                InkWell(
                  onTap: () => onSectionTap?.call(1),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: const Row(
                      children: [
                        Text('Ce mois', style: TextStyle(fontSize: 12)),
                        Icon(Icons.arrow_drop_down, size: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            
            Container(
              height: 180,
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.withOpacity(0.2)),
              ),
              child: Center(
                child: Icon(Icons.show_chart, size: 100, color: Colors.blue[800]),
              ),
            ),
            const SizedBox(height: 30),

            // 4. Activités récentes
            const Text('Activités récentes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            _buildRecentActivity(
              context,
              Icons.chat_bubble_outline,
              Colors.blue,
              'Nouvelle question',
              'Dans le cours Flutter & Dart - Il y a 2h',
              () => onSectionTap?.call(1),
            ),
            _buildRecentActivity(
              context,
              Icons.person_add_alt,
              Colors.green,
              "Inscription d'un étudiant",
              "Marie Junior s'est inscrit - Il y a 5h",
              () => onSectionTap?.call(3),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatBox(String count, String label) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 5)],
      ),
      child: Column(
        children: [
          Text(count, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 5),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildRecentActivity(BuildContext context, IconData icon, Color color, String title, String subtitle, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, color: color),
            ),
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
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

class TeacherCoursesBody extends StatelessWidget {
  const TeacherCoursesBody({super.key});

  @override
  Widget build(BuildContext context) {
    final courses = [
      {
        'title': 'Flutter & Dart',
        'level': 'Avancé',
        'students': '26',
        'lesson': 'Chapitre 3: Widgets et layout',
      },
      {
        'title': 'UI/UX Design',
        'level': 'Intermédiaire',
        'students': '14',
        'lesson': 'Chapitre 2: Couleurs et typographie',
      },
    ];

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Cours', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ...courses.map((course) => _buildCourseCard(context, course)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseCard(BuildContext context, Map<String, String> course) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Ouvrir ${course['title']}')),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(course['title']!, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text(course['level']!, style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Leçon: ${course['lesson']}', style: const TextStyle(fontSize: 14)),
                  Text('${course['students']} élèves', style: const TextStyle(color: Colors.blue)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TeacherAddCourseBody extends StatelessWidget {
  const TeacherAddCourseBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Ajouter un cours', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Text('Ici vous pouvez ajouter un nouveau cours ou quiz.', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

class TeacherStudentsBody extends StatelessWidget {
  const TeacherStudentsBody({super.key});

  @override
  Widget build(BuildContext context) {
    final students = [
      {
        'name': 'Marie Junior',
        'email': 'marie.junior@example.com',
        'description': 'Étudiante active du cours Flutter & Dart.',
      },
      {
        'name': 'Jean Luc',
        'email': 'jean.luc@example.com',
        'description': 'Très impliqué dans les devoirs de design UI.',
      },
    ];

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Étudiants inscrits', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ...students.map((student) => _buildStudentCard(student)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentCard(Map<String, String> student) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(student['name']!, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(student['email']!, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),
            Text(student['description']!, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}

class TeacherProfileBody extends StatelessWidget {
  const TeacherProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Profil', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Text('Voir et modifier les informations de votre profil enseignant.', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
