import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:edu_connect_pro/models/firestore_models.dart';
import 'package:edu_connect_pro/providers/auth_provider.dart';
import 'package:edu_connect_pro/screens/badges_list_screen.dart';
import 'package:edu_connect_pro/screens/courses/course_catalog_screen.dart';
import 'package:edu_connect_pro/screens/courses/course_detail_screen.dart';
import 'package:edu_connect_pro/screens/forum/forum_screen.dart';
import 'package:edu_connect_pro/screens/notifications/notifications_screen.dart';
import 'package:edu_connect_pro/screens/profile_screen.dart';

class StudentDashboard extends StatefulWidget {
  final String userId;
  const StudentDashboard({super.key, required this.userId});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  int _currentIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      AccueilBody(userId: widget.userId),
      const CourseCatalogScreen(),
      const ForumScreen(),
      const NotificationScreen(),
      ProfileScreen(userId: widget.userId),
    ];
  }

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
  final String userId;
  const AccueilBody({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Entête: Bonjour, Jean Berlineda ak foto pwofil gòch / notifikasyon dwat
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
                    Consumer<AuthProvider>(
                      builder: (context, authProvider, _) {
                        final name = authProvider.user?.email?.split('@').first ?? 'Étudiant';
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Bonjour,', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                            Text(name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                          ],
                        );
                      },
                    ),
                  ],
                ),
                const Icon(Icons.notifications_none, size: 26),
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
                    color: Colors.black.withValues(alpha: 0.03),
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
            
            _buildCourseItem(context, 'Flutter & Dart', 'Avancé', '4.8', 0.78, Colors.blue, false),
            _buildCourseItem(context, 'UI/UX Design', 'Intermédiaire', '4.7', 0.45, Colors.purple, true),
            Text('Compte connecté: $userId', style: const TextStyle(fontSize: 11, color: Colors.grey)),
            const SizedBox(height: 20),

            // 4. Seksyon Badges obtenus (Nou modifye kòd la isit la pou louvri BadgesListScreen)
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

  Widget _buildCourseItem(BuildContext context, String title, String level, String rating, double progress, Color color, bool showRating) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CourseDetailScreen(
              course: CourseModel(
                id: title.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '_'),
                teacherId: '',
                titre: title,
                description: 'Cours publié depuis le tableau de bord étudiant.',
                categorie: level,
                coverURL: '',
                chapitresCount: 0,
                inscritCount: 0,
                isPublie: true,
                createdAt: DateTime.now(),
              ),
            ),
          ),
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
              color: Colors.black.withValues(alpha: 0.02),
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
              decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
              child: Icon(Icons.menu_book, color: color, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  Text(level, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                  if (showRating) ...[
                    const SizedBox(height: 4),
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