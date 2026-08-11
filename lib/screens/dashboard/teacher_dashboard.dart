import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TeacherDashboard extends StatelessWidget {
  const TeacherDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
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
                        backgroundColor: Colors.blue,
                        child: Icon(Icons.person, color: Colors.white, size: 30),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Bonjour,', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                          const Text('Prof. Jean Claude', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                  const Icon(Icons.notifications_none, size: 28),
                ],
              ),
              const SizedBox(height: 30),

              // 2. Twa ti bwat estatistik yo
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatBox('12', 'Cours créés'),
                  _buildStatBox('36', 'Étudiants'),
                  _buildStatBox('8', 'Quiz créés'),
                ],
              ),
              const SizedBox(height: 30),

              // 3. Seksyon Grafik la
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Statistique', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Container(
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
                ],
              ),
              const SizedBox(height: 15),
              
              // Simulation bèl ti graf la nan yon bwat
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

              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => context.push('/teacher/courses'),
                  icon: const Icon(Icons.add_circle_outline),
                  label: const Text('Créer un nouveau cours'),
                ),
              ),
              const SizedBox(height: 20),

              // 4. Activités récentes
              const Text('Activités récentes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              _buildRecentActivity(
                Icons.chat_bubble_outline,
                Colors.blue,
                'Nouvelle question',
                'Dans le cours Flutter & Dart - Il y a 2h',
              ),
              _buildRecentActivity(
                Icons.person_add_alt,
                Colors.green,
                "Inscription d'un étudiant",
                "Marie Junior s'est inscrit - Il y a 5h",
              ),
            ],
          ),
        ),
      ),
      // Bara Navigasyon anba a
      bottomNavigationBar: _buildBottomNav(0),
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

  Widget _buildRecentActivity(IconData icon, Color color, String title, String subtitle) {
    return Container(
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
    );
  }

  Widget _buildBottomNav(int currentIndex) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF0D47A1),
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
        BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Cours'),
        BottomNavigationBarItem(icon: Icon(Icons.add_circle, size: 35, color: Color(0xFF0D47A1)), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Étudiants'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
      ],
    );
  }
}