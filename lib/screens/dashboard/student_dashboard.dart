import 'package:flutter/material.dart';
import '../courses/course_catalog_screen.dart';
import '../courses/course_detail_screen.dart'; // Enpòtasyon pou detay kou yo ka mache
import '../forum/forum_screen.dart';
import '../notifications/notifications_screen.dart';
import '../profile/profile_screen.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  int _currentIndex = 0;

  // Lis tout paj onglet yo pral louvri
  final List<Widget> _pages = [
    const AccueilBody(), 
    const CourseCatalogScreen(),
    const ForumScreen(),
    const NotificationsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Chanje paj lè w klike sou onglet yo
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF0D47A1),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Cours'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Forum'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notification'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}

// Men kòd reyèl Accueil la ki gen tout bouton ak kat yo konekte kounye a
class AccueilBody extends StatelessWidget {
  const AccueilBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Entête pwofil la
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.amber,
                      child: Icon(Icons.person, color: Colors.white, size: 30),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Bonjour,', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                        const Text('Jean Berlineda', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
                const Icon(Icons.notifications_none, size: 28),
              ],
            ),
            const SizedBox(height: 25),

            // 2. Kat Pwogresyon Globale (97%)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
              ),
              child: Row(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      const SizedBox(
                        width: 50,
                        height: 50,
                        child: CircularProgressIndicator(
                          value: 0.97,
                          strokeWidth: 5,
                          backgroundColor: Color(0xFFE0E0E0),
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                        ),
                      ),
                      Text('97%', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[800], fontSize: 12)),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Progression globale', style: TextStyle(color: Colors.grey, fontSize: 13)),
                      const SizedBox(height: 4),
                      Text('Continue comme ça !', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.grey[800])),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // 3. Seksyon Mes cours ak bouton "Voir tout" ki mache kounye a
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Mes cours', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () {
                    // Sa ap voye w sou paj Catalogue la lè w klike sou "Voir tout"
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CourseCatalogScreen()),
                    );
                  }, 
                  child: const Text('Voir tout'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            
            // Kats kou yo ki konekte ak detay yo kounye a
            _buildCourseItem(context, 'Flutter & Dart', 'Avancé', 0.78, Colors.blue),
            _buildCourseItem(context, 'UI/UX Design', 'Intermédiaire', 0.45, Colors.purple),
            const SizedBox(height: 25),

            // 4. Badges obtenus
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Badges obtenus', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextButton(onPressed: () {}, child: const Text('Voir tout')),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildBadge(Icons.star, Colors.amber),
                _buildBadge(Icons.emoji_events, Colors.indigo),
                _buildBadge(Icons.local_fire_department, Colors.orange),
                _buildBadge(Icons.lock, Colors.grey),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseItem(BuildContext context, String title, String level, double progress, Color color) {
    return GestureDetector(
      onTap: () {
        // Sa ap ouvè detay kou a parfe lè w klike sou kat la!
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CourseDetailScreen(courseTitle: title)),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.01), blurRadius: 5)],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
              child: Icon(Icons.book, color: color),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  Text(level, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Text('${(progress * 100).toInt()}%', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
      child: Icon(icon, color: color, size: 28),
    );
  }
}