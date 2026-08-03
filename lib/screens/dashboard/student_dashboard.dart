import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:edu_connect_pro/providers/auth_provider.dart';
import 'package:edu_connect_pro/screens/courses/course_catalog_screen.dart';
import 'package:edu_connect_pro/screens/courses/course_detail_screen.dart';
import 'package:edu_connect_pro/screens/forum/forum_screen.dart';
import 'package:edu_connect_pro/screens/notifications/notifications_screen.dart';
import 'package:edu_connect_pro/screens/badges_list_screen.dart';
import 'package:edu_connect_pro/screens/profile_screen.dart';
import '../auth/login_screen.dart'; // Enpòtasyon pou ekran Login nan lè yo dekonekte

class StudentDashboard extends StatefulWidget {
  final String userId; // Nou bezwen ID a jan nou te diskite anvan an
  const StudentDashboard({super.key, required this.userId});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const AccueilBody(), 
    const CourseCatalogScreen(),
    ForumScreen(),
    const NotificationScreen(),
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
            _currentIndex = index; 
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

class AccueilBody extends StatelessWidget {
  const AccueilBody({super.key});

  // Fonksyon konfimasyon dekoneksyon an
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
            // 1. Entête: Bonjour, Jean Berlineda ak foto pwofil gòch / notifikasyon & Dekoneksyon dwat
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.amber,
                      child: Icon(Icons.person, color: Colors.white, size: 26),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Bonjour,', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                        Text(
                          context.watch<AuthProvider>().nom ?? 'Étudiant',
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.notifications_none, size: 26),
                    const SizedBox(width: 8),
                    // Bouton dekoneksyon an ak yon bèl ti icon wouj
                    IconButton(
                      icon: const Icon(Icons.logout, color: Colors.red, size: 24),
                      onPressed: () => showLogoutConfirmation(context),
                      tooltip: 'Se déconnecter',
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 2. Kat Progression Globale: "Progression globale" anlè, epi ti wonn nan bò gòch "Continue comme ça !"
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Progression globale', style: TextStyle(color: Colors.grey[800], fontSize: 13, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          const SizedBox(
                            width: 45,
                            height: 45,
                            child: CircularProgressIndicator(
                              value: 0.97,
                              strokeWidth: 4.5,
                              backgroundColor: Color(0xFFE8F5E9),
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                            ),
                          ),
                          Text('97%', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[900], fontSize: 11)),
                        ],
                      ),
                      const SizedBox(width: 15),
                      Text('Continue comme ça !', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.grey[800])),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            // 3. Seksyon Mes cours
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Mes cours', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CourseCatalogScreen()),
                    );
                  }, 
                  child: const Text('Voir tout', style: TextStyle(fontSize: 13, color: Colors.blue)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            _buildCourseItem(
              context,
              'Flutter & Dart',
              'Avancé',
              '4.8',
              0.78,
              Colors.blue,
              false,
              'Chapitre 3: Widgets et layout',
            ),
            _buildCourseItem(
              context,
              'UI/UX Design',
              'Intermédiaire',
              '4.7',
              0.45,
              Colors.purple,
              true,
              'Chapitre 2: Couleurs et typographie',
            ),
            const SizedBox(height: 20),

            // 4. Seksyon Badges obtenus
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Badges obtenus', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const BadgesListScreen()),
                    );
                  }, 
                  child: const Text(
                    'Voir tout', 
                    style: TextStyle(
                      fontSize: 13, 
                      color: Color(0xFF0D47A1), 
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTrophyBadge(), 
                _buildStarBadge(),   
                _buildStarBadge(),   
                _buildStarBadge(),   
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseItem(
    BuildContext context,
    String title,
    String level,
    String rating,
    double progress,
    Color color,
    bool showRating,
    String lesson,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CourseDetailScreen(courseTitle: title)),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
              child: Icon(Icons.menu_book, color: color, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  Text(level, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                  const SizedBox(height: 4),
                  Text(
                    lesson,
                    style: const TextStyle(fontSize: 12, color: Colors.black87, fontWeight: FontWeight.w500),
                  ),
                  if (showRating) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 12),
                        const SizedBox(width: 4),
                        Text(rating, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black54)),
                      ],
                    ),
                  ],
                  const SizedBox(height: 6),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                    minHeight: 4,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Text('${(progress * 100).toInt()}%', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.black87)),
          ],
        ),
      ),
    );
  }

  Widget _buildTrophyBadge() {
    return const Icon(
      Icons.emoji_events, 
      color: Colors.amber, 
      size: 40,
    );
  }

  Widget _buildStarBadge() {
    return Stack(
      alignment: Alignment.center,
      children: [
        const Icon(Icons.star, color: Colors.amber, size: 42),
        Icon(Icons.star, color: Colors.blue[900], size: 32),
        const Icon(Icons.star, color: Colors.orange, size: 12),
      ],
    );
  }
}