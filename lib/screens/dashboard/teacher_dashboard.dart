// ============================================================
// EduConnect Pro — TeacherDashboard (Fonctionnel)
// ============================================================

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:edu_connect_pro/providers/auth_provider.dart';
import '../auth/login_screen.dart';

class QuestionDetailScreen extends StatelessWidget {
  final String title;
  final String question;
  final String courseName;
  final String createdAt;

  const QuestionDetailScreen({
    super.key,
    required this.title,
    required this.question,
    required this.courseName,
    required this.createdAt,
  });

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Déconnexion'),
          content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Annuler')),
            TextButton(
              onPressed: () async {
                Navigator.pop(dialogContext);
                final authProvider = Provider.of<AuthProvider>(context, listen: false);
                await authProvider.logout();
                if (!context.mounted) return;
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              },
              child: const Text('Déconnecter', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails de la question'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.maybePop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Se déconnecter',
            onPressed: () => _showLogoutConfirmation(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Text(question, style: const TextStyle(fontSize: 16, height: 1.5)),
            ),
            const SizedBox(height: 20),
            _infoRow('Cours', courseName),
            _infoRow('Date', createdAt),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0D47A1)),
                child: const Text('Retour', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 90, child: Text('$label :', style: const TextStyle(fontWeight: FontWeight.bold))),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

class TeacherDashboard extends StatefulWidget {
  const TeacherDashboard({super.key});

  @override
  State<TeacherDashboard> createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {
  int _currentIndex = 0;

  final List<String> _titles = const [
    'Accueil',
    'Cours',
    'Ajouter un cours',
    'Étudiants',
    'Profil',
  ];

  void _setTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text('Déconnexion', style: TextStyle(fontWeight: FontWeight.bold)),
          content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuler', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                final authProvider = Provider.of<AuthProvider>(context, listen: false);
                await authProvider.logout();
                if (!context.mounted) return;
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              },
              child: const Text('Oui, déconnecter', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
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
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D47A1),
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text(_titles[_currentIndex]),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.maybePop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Se déconnecter',
            onPressed: () => _showLogoutConfirmation(context),
          ),
        ],
      ),
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

  Future<Map<String, int>> _loadDashboardStats() async {
    final coursesSnap = await FirebaseFirestore.instance.collection('cours').get();
    final studentsSnap = await FirebaseFirestore.instance.collection('users').where('role', isEqualTo: 'student').get();
    final questionsSnap = await FirebaseFirestore.instance.collection('questions').get();

    return {
      'courses': coursesSnap.docs.length,
      'students': studentsSnap.docs.length,
      'questions': questionsSnap.docs.length,
    };
  }

  Future<List<Map<String, dynamic>>> _loadQuestions() async {
    final snapshot = await FirebaseFirestore.instance.collection('questions').limit(5).get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      final createdAt = (data['createdAt'] as Timestamp?)?.toDate();
      return {
        'title': data['title'] ?? 'Question',
        'question': data['question'] ?? '',
        'courseName': data['courseName'] ?? 'Cours',
        'createdAt': createdAt != null ? createdAt.toLocal().toString() : 'Date inconnue',
      };
    }).toList();
  }

  Future<List<Map<String, dynamic>>> _loadStudents() async {
    final snapshot = await FirebaseFirestore.instance.collection('users').where('role', isEqualTo: 'student').get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'uid': doc.id,
        'name': data['nom'] ?? 'Étudiant',
        'email': data['email'] ?? data['nom'] ?? 'email@inconnu.com',
        'institution': data['institution'] ?? 'Non renseignée',
        'avatarURL': data['avatarURL'] ?? '',
      };
    }).toList();
  }

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
            FutureBuilder<Map<String, int>>(
              future: _loadDashboardStats(),
              builder: (context, snapshot) {
                final stats = snapshot.data ?? {'courses': 0, 'students': 0, 'questions': 0};
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatBox('${stats['courses']}', 'Cours créés'),
                    _buildStatBox('${stats['students']}', 'Étudiants'),
                    _buildStatBox('${stats['questions']}', 'Quiz créés'),
                  ],
                );
              },
            ),
            const SizedBox(height: 30),
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
            const Text('Activités récentes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _loadQuestions(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('Aucune question récente pour le moment.');
                }
                final questions = snapshot.data!;
                return Column(
                  children: questions.map((question) {
                    return _buildRecentActivity(
                      context,
                      Icons.chat_bubble_outline,
                      Colors.blue,
                      question['title'] ?? 'Nouvelle question',
                      '${question['courseName']} - ${question['createdAt']}',
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QuestionDetailScreen(
                              title: question['title'] ?? 'Nouvelle question',
                              question: question['question'] ?? '',
                              courseName: question['courseName'] ?? 'Cours',
                              createdAt: question['createdAt'] ?? 'Date inconnue',
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                );
              },
            ),
            const SizedBox(height: 12),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _loadStudents(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox();
                }
                final students = snapshot.data ?? [];
                final studentName = students.isNotEmpty ? students.first['name'] : 'Aucun étudiant';
                final studentEmail = students.isNotEmpty ? students.first['email'] : 'Aucun email';
                return _buildRecentActivity(
                  context,
                  Icons.person_add_alt,
                  Colors.green,
                  "Inscription d'un étudiant",
                  "$studentName - $studentEmail",
                  () => onSectionTap?.call(3),
                );
              },
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

class TeacherStudentDetailScreen extends StatelessWidget {
  final Map<String, dynamic> student;

  const TeacherStudentDetailScreen({super.key, required this.student});

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Déconnexion'),
          content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Annuler')),
            TextButton(
              onPressed: () async {
                Navigator.pop(dialogContext);
                final authProvider = Provider.of<AuthProvider>(context, listen: false);
                await authProvider.logout();
                if (!context.mounted) return;
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              },
              child: const Text('Déconnecter', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails de l’étudiant'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.maybePop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Se déconnecter',
            onPressed: () => _showLogoutConfirmation(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 48,
                backgroundColor: const Color(0xFF0D47A1),
                backgroundImage: (student['avatarURL'] ?? '').toString().isNotEmpty ? NetworkImage(student['avatarURL']) : null,
                child: (student['avatarURL'] ?? '').toString().isEmpty ? const Icon(Icons.person, size: 42, color: Colors.white) : null,
              ),
            ),
            const SizedBox(height: 24),
            _detailRow('Nom', student['name'] ?? 'Aucun nom'),
            _detailRow('Email', student['email'] ?? 'Aucun email'),
            _detailRow('Institution', student['institution'] ?? 'Non renseignée'),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _showEditStudentDialog(context, student),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0D47A1)),
                child: const Text('Modifier', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 110, child: Text('$label :', style: const TextStyle(fontWeight: FontWeight.bold))),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Future<void> _showEditStudentDialog(BuildContext context, Map<String, dynamic> student) async {
    final nameCtrl = TextEditingController(text: student['name'] ?? '');
    final emailCtrl = TextEditingController(text: student['email'] ?? '');
    final institutionCtrl = TextEditingController(text: student['institution'] ?? '');
    final formKey = GlobalKey<FormState>();

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Modifier l’étudiant'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameCtrl,
                    decoration: const InputDecoration(labelText: 'Nom complet'),
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"[a-zA-ZÀ-ÖØ-öø-ÿ\s'-]"))],
                    validator: (value) => value == null || value.trim().isEmpty ? 'Ce champ est obligatoire.' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return 'Ce champ est obligatoire.';
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[a-zA-Z]{2,}$').hasMatch(value.trim())) return 'Email invalide.';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: institutionCtrl,
                    decoration: const InputDecoration(labelText: 'Institution'),
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"[a-zA-ZÀ-ÖØ-öø-ÿ\s'-]"))],
                    validator: (value) => value == null || value.trim().isEmpty ? 'Ce champ est obligatoire.' : null,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Annuler')),
            ElevatedButton(
              onPressed: () async {
                if (!(formKey.currentState?.validate() ?? false)) return;

                final uid = student['uid'];
                if (uid == null || uid.toString().isEmpty) {
                  Navigator.pop(dialogContext, false);
                  return;
                }

                await FirebaseFirestore.instance.collection('users').doc(uid).update({
                  'nom': nameCtrl.text.trim(),
                  'email': emailCtrl.text.trim(),
                  'institution': institutionCtrl.text.trim(),
                });
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Enregistrer'),
            ),
          ],
        );
      },
    );

    if (result == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informations mises à jour.')),
      );
    }
  }
}

// ------------------------------------------------------------
// 1. Ekran Lis Kou yo (Koulye a li ouvri yon paj detay lè yo peze l)
// ------------------------------------------------------------
class TeacherCoursesBody extends StatelessWidget {
  const TeacherCoursesBody({super.key});

  Future<List<Map<String, dynamic>>> _loadCourses() async {
    final snapshot = await FirebaseFirestore.instance.collection('cours').get();
    final courses = <Map<String, dynamic>>[];

    for (final doc in snapshot.docs) {
      final data = doc.data();
      final courseId = doc.id;
      final studentsSnapshot = await FirebaseFirestore.instance
          .collection('inscriptions')
          .where('courseId', isEqualTo: courseId)
          .get();

      final enrolledStudents = <Map<String, dynamic>>[];
      for (final item in studentsSnapshot.docs) {
        final studentId = item.data()['studentId'];
        if (studentId == null || studentId == '') continue;
        final userDoc = await FirebaseFirestore.instance.collection('users').doc(studentId).get();
        final userData = userDoc.data() ?? {};
        enrolledStudents.add({
          'name': userData['nom'] ?? 'Étudiant',
          'email': userData['email'] ?? 'email@inconnu.com',
          'avatarURL': userData['avatarURL'] ?? '',
          'institution': userData['institution'] ?? 'Non renseignée',
          'uid': studentId,
        });
      }

      courses.add({
        'id': courseId,
        'title': data['titre'] ?? 'Cours',
        'description': data['description'] ?? 'Aucune description',
        'category': data['categorie'] ?? 'Général',
        'coverURL': data['coverURL'] ?? '',
        'students': enrolledStudents,
        'studentsCount': enrolledStudents.length,
      });
    }

    return courses;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: _loadCourses(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final courses = snapshot.data ?? [];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Cours', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                if (courses.isEmpty)
                  const Text('Aucun cours disponible pour le moment.')
                else
                  ...courses.map((course) => _buildCourseCard(context, course)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCourseCard(BuildContext context, Map<String, dynamic> course) {
    final List<Map<String, dynamic>> students = course['students'] ?? const <Map<String, dynamic>>[];

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TeacherCourseDetailScreen(
                courseId: course['id'],
                courseTitle: course['title'],
                description: course['description'],
                category: course['category'],
                coverURL: course['coverURL'],
                studentsCount: '${students.length}',
                students: students,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(course['title'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text(course['description'], style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text('Description: ${course['description']}', style: const TextStyle(fontSize: 13))),
                  Text('${students.length} élèves', style: const TextStyle(color: Colors.blue)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TeacherCourseDetailScreen extends StatelessWidget {
  final String courseId;
  final String courseTitle;
  final String description;
  final String category;
  final String coverURL;
  final String studentsCount;
  final List<Map<String, dynamic>> students;

  const TeacherCourseDetailScreen({
    super.key,
    required this.courseId,
    required this.courseTitle,
    required this.description,
    required this.category,
    required this.coverURL,
    required this.studentsCount,
    required this.students,
  });

  Future<List<Map<String, dynamic>>> _loadCourseChapters() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('cours')
        .doc(courseId)
        .collection('chapitres')
        .orderBy('ordre')
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'id': doc.id,
        'titre': data['titre'] ?? 'Chapitre',
        'contenu': data['contenu'] ?? '',
        'imageURL': data['imageURL'] ?? '',
        'lien': data['lien'] ?? '',
        'ordre': data['ordre'] ?? 1,
      };
    }).toList();
  }

  Future<List<Map<String, dynamic>>> _loadCourseQuestions() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('questions')
        .where('courseId', isEqualTo: courseId)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'id': doc.id,
        'title': data['title'] ?? 'Question',
        'question': data['question'] ?? '',
        'options': data['options'] ?? <String>[],
        'correctIndex': data['correctIndex'] ?? 0,
      };
    }).toList();
  }

  Future<List<Map<String, dynamic>>> _loadAnnouncements() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('cours')
        .doc(courseId)
        .collection('annonces')
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
  }

  Future<List<Map<String, dynamic>>> _loadForum() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('cours')
        .doc(courseId)
        .collection('forum')
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
  }

  Future<Map<String, dynamic>> _loadCourseStats() async {
    final resultsSnap = await FirebaseFirestore.instance
        .collection('quiz_results')
        .where('courseId', isEqualTo: courseId)
        .get();

    if (resultsSnap.docs.isEmpty) {
      return {'progress': '0%', 'averageScore': '0%', 'time': '0 min'};
    }

    double totalScore = 0;
    int totalTime = 0;
    for (final doc in resultsSnap.docs) {
      final data = doc.data();
      totalScore += (data['score'] ?? 0).toDouble();
      totalTime += (data['tempsPasse'] ?? 0) as int;
    }
    final average = totalScore / resultsSnap.docs.length;
    return {
      'progress': '${(students.length == 0 ? 0 : ((resultsSnap.docs.length / students.length) * 100)).clamp(0, 100).toStringAsFixed(0)}%',
      'averageScore': '${average.toStringAsFixed(0)}%',
      'time': '${(totalTime / resultsSnap.docs.length).round()} min',
    };
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Déconnexion'),
          content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Annuler')),
            TextButton(
              onPressed: () async {
                Navigator.pop(dialogContext);
                final authProvider = Provider.of<AuthProvider>(context, listen: false);
                await authProvider.logout();
                if (!context.mounted) return;
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              },
              child: const Text('Déconnecter', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(courseTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.maybePop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Se déconnecter',
            onPressed: () => _showLogoutConfirmation(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (coverURL.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  coverURL,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 14),
            Text(courseTitle, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text('Catégorie : $category', style: const TextStyle(color: Colors.blueGrey)),
            const SizedBox(height: 12),
            Text(description, style: TextStyle(color: Colors.grey[700], fontSize: 15)),
            const SizedBox(height: 18),
            Row(
              children: [
                const Icon(Icons.people, color: Colors.blue),
                const SizedBox(width: 8),
                Text('$studentsCount élèves inscrits', style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 20),
            FutureBuilder<Map<String, dynamic>>(
              future: _loadCourseStats(),
              builder: (context, snapshot) {
                final stats = snapshot.data ?? {'progress': '0%', 'averageScore': '0%', 'time': '0 min'};
                return Row(
                  children: [
                    Expanded(child: _statPill('Progression', stats['progress'])),
                    const SizedBox(width: 8),
                    Expanded(child: _statPill('Score moyen', stats['averageScore'])),
                    const SizedBox(width: 8),
                    Expanded(child: _statPill('Temps', stats['time'])),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),
            const Text('Chapitres', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _loadCourseChapters(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final chapters = snapshot.data ?? [];
                if (chapters.isEmpty) {
                  return const Text('Aucun chapitre créé pour ce cours.');
                }
                return Column(
                  children: chapters.map((chapter) {
                    return Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${chapter['ordre']} - ${chapter['titre']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          if ((chapter['contenu'] ?? '').toString().isNotEmpty) Text(chapter['contenu']),
                          if ((chapter['imageURL'] ?? '').toString().isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Image.network(chapter['imageURL'], height: 140, width: double.infinity, fit: BoxFit.cover),
                          ],
                          if ((chapter['lien'] ?? '').toString().isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text('Lien : ${chapter['lien']}'),
                          ],
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
            const SizedBox(height: 20),
            const Text('Quiz du cours', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _loadCourseQuestions(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final questions = snapshot.data ?? [];
                if (questions.isEmpty) {
                  return const Text('Aucun quiz pour ce cours.');
                }
                return Column(
                  children: questions.map((question) {
                    final options = (question['options'] as List<dynamic>? ?? []).map((e) => e.toString()).toList();
                    return Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${question['title']} : ${question['question']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          ...List.generate(options.length, (index) {
                            final isCorrect = index == (question['correctIndex'] ?? 0);
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Row(
                                children: [
                                  Icon(isCorrect ? Icons.check_circle : Icons.circle_outlined, color: isCorrect ? Colors.green : Colors.grey, size: 18),
                                  const SizedBox(width: 8),
                                  Expanded(child: Text(options[index])),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
            const SizedBox(height: 20),
            const Text('Annonces', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _AnnouncementComposer(courseId: courseId),
            const SizedBox(height: 8),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _loadAnnouncements(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final items = snapshot.data ?? [];
                if (items.isEmpty) return const Text('Aucune annonce pour le moment.');
                return Column(
                  children: items.map((item) => Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(item['message'] ?? ''),
                  )).toList(),
                );
              },
            ),
            const SizedBox(height: 20),
            const Text('Forum', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _ForumComposer(courseId: courseId),
            const SizedBox(height: 8),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _loadForum(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final items = snapshot.data ?? [];
                if (items.isEmpty) return const Text('Aucune question dans le forum.');
                return Column(
                  children: items.map((item) => Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item['author'] ?? 'Étudiant', style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(item['message'] ?? ''),
                      ],
                    ),
                  )).toList(),
                );
              },
            ),
            const SizedBox(height: 20),
            const Text('Étudiants inscrits', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            if (students.isEmpty)
              const Text('Aucun étudiant inscrit à ce cours pour le moment.')
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: students.length,
                itemBuilder: (context, index) {
                  final student = students[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TeacherStudentDetailScreen(student: student),
                          ),
                        );
                      },
                      leading: CircleAvatar(
                        backgroundColor: const Color(0xFF0D47A1),
                        backgroundImage: (student['avatarURL'] ?? '').toString().isNotEmpty ? NetworkImage(student['avatarURL']) : null,
                        child: (student['avatarURL'] ?? '').toString().isEmpty ? const Icon(Icons.person, color: Colors.white) : null,
                      ),
                      title: Text(student['name'] ?? 'Étudiant'),
                      subtitle: Text(student['email'] ?? 'email@inconnu.com'),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _statPill(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _AnnouncementComposer extends StatefulWidget {
  final String courseId;
  const _AnnouncementComposer({required this.courseId});

  @override
  State<_AnnouncementComposer> createState() => _AnnouncementComposerState();
}

class _AnnouncementComposerState extends State<_AnnouncementComposer> {
  final TextEditingController _controller = TextEditingController();

  Future<void> _publish() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    await FirebaseFirestore.instance.collection('cours').doc(widget.courseId).collection('annonces').add({
      'message': text,
      'createdAt': Timestamp.now(),
      'author': 'Enseignant',
    });

    _controller.clear();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: 'Publier une annonce pour le cours',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: _publish,
          child: const Text('Publier'),
        ),
      ],
    );
  }
}

class _ForumComposer extends StatefulWidget {
  final String courseId;
  const _ForumComposer({required this.courseId});

  @override
  State<_ForumComposer> createState() => _ForumComposerState();
}

class _ForumComposerState extends State<_ForumComposer> {
  final TextEditingController _controller = TextEditingController();

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    await FirebaseFirestore.instance.collection('cours').doc(widget.courseId).collection('forum').add({
      'message': text,
      'author': 'Enseignant',
      'createdAt': Timestamp.now(),
    });

    _controller.clear();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: 'Répondre ou publier dans le forum',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: _send,
          child: const Text('Envoyer'),
        ),
      ],
    );
  }
}

// ------------------------------------------------------------
// 2. Ekran pou Ajoute yon Kou (Fonksyonèl ak Fòmilè)
// ------------------------------------------------------------
class TeacherAddCourseBody extends StatefulWidget {
  const TeacherAddCourseBody({super.key});

  @override
  State<TeacherAddCourseBody> createState() => _TeacherAddCourseBodyState();
}

class _TeacherAddCourseBodyState extends State<TeacherAddCourseBody> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController(text: 'Général');
  final TextEditingController _coverURLController = TextEditingController();
  final TextEditingController _chapterTitleController = TextEditingController();
  final TextEditingController _chapterContentController = TextEditingController();
  final TextEditingController _chapterImageController = TextEditingController();
  final TextEditingController _chapterLinkController = TextEditingController();
  final List<Map<String, dynamic>> _questionFields = [];
  String? _selectedCourseId;
  String? _selectedCourseName;
  bool _isSaving = false;
  bool _isLoadingCourses = true;

  @override
  void initState() {
    super.initState();
    _loadCoursesForSelection();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _coverURLController.dispose();
    _chapterTitleController.dispose();
    _chapterContentController.dispose();
    _chapterImageController.dispose();
    _chapterLinkController.dispose();
    for (final fieldGroup in _questionFields) {
      final controllers = fieldGroup['controllers'] as List<TextEditingController>? ?? const [];
      for (final controller in controllers) {
        controller.dispose();
      }
      (fieldGroup['title'] as TextEditingController?)?.dispose();
      (fieldGroup['question'] as TextEditingController?)?.dispose();
    }
    super.dispose();
  }

  Future<void> _loadCoursesForSelection() async {
    final coursesSnapshot = await FirebaseFirestore.instance.collection('cours').get();
    if (coursesSnapshot.docs.isNotEmpty) {
      final first = coursesSnapshot.docs.first;
      setState(() {
        _selectedCourseId = first.id;
        _selectedCourseName = first.data()['titre'] ?? 'Cours';
        _isLoadingCourses = false;
      });
      return;
    }
    setState(() => _isLoadingCourses = false);
  }

  Future<List<Map<String, dynamic>>> _getCourseOptions() async {
    final snapshot = await FirebaseFirestore.instance.collection('cours').get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'id': doc.id,
        'title': data['titre'] ?? 'Cours',
      };
    }).toList();
  }

  void _addQuestionField() {
    final titleController = TextEditingController();
    final questionController = TextEditingController();
    final optionControllers = List.generate(4, (_) => TextEditingController());
    _questionFields.add({
      'title': titleController,
      'question': questionController,
      'controllers': optionControllers,
      'correctIndex': 0,
    });
    setState(() {});
  }

  Future<void> _submitCourse() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSaving = true);
      try {
        final courseRef = await FirebaseFirestore.instance.collection('cours').add({
          'titre': _titleController.text.trim(),
          'description': _descriptionController.text.trim(),
          'categorie': _categoryController.text.trim().isNotEmpty ? _categoryController.text.trim() : 'Général',
          'coverURL': _coverURLController.text.trim(),
          'chapitresCount': _chapterTitleController.text.trim().isNotEmpty ? 1 : 0,
          'inscritCount': 0,
          'isPublie': true,
          'createdAt': Timestamp.now(),
        });

        if (_chapterTitleController.text.trim().isNotEmpty) {
          await courseRef.collection('chapitres').add({
            'titre': _chapterTitleController.text.trim(),
            'contenu': _chapterContentController.text.trim(),
            'imageURL': _chapterImageController.text.trim(),
            'lien': _chapterLinkController.text.trim(),
            'ordre': 1,
            'hasQuiz': _questionFields.isNotEmpty,
          });
        }

        for (final fieldGroup in _questionFields) {
          final title = (fieldGroup['title'] as TextEditingController).text.trim();
          final question = (fieldGroup['question'] as TextEditingController).text.trim();
          final options = (fieldGroup['controllers'] as List<TextEditingController>).map((controller) => controller.text.trim()).toList();
          final correctIndex = fieldGroup['correctIndex'] as int;
          if (title.isNotEmpty && question.isNotEmpty && options.every((option) => option.isNotEmpty)) {
            await FirebaseFirestore.instance.collection('questions').add({
              'title': title,
              'question': question,
              'options': options,
              'correctIndex': correctIndex,
              'courseId': courseRef.id,
              'courseName': _titleController.text.trim(),
              'createdAt': Timestamp.now(),
            });
          }
        }

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cours et contenus ajoutés avec succès !')),
        );
        _titleController.clear();
        _descriptionController.clear();
        _categoryController.text = 'Général';
        _coverURLController.clear();
        _chapterTitleController.clear();
        _chapterContentController.clear();
        _chapterImageController.clear();
        _chapterLinkController.clear();
        _questionFields.clear();
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur : $e')),
        );
      } finally {
        if (mounted) setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _submitQuestion() async {
    if (_selectedCourseId == null || _selectedCourseName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aucun cours disponible pour ajouter une question.')),
      );
      return;
    }

    final questionDrafts = _questionFields.where((fieldGroup) {
      final title = (fieldGroup['title'] as TextEditingController).text.trim();
      final question = (fieldGroup['question'] as TextEditingController).text.trim();
      final options = (fieldGroup['controllers'] as List<TextEditingController>).map((controller) => controller.text.trim()).toList();
      return title.isNotEmpty || question.isNotEmpty || options.any((option) => option.isNotEmpty);
    }).toList();

    if (questionDrafts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ajoutez au moins une question.')),
      );
      return;
    }

    final invalidDraft = questionDrafts.any((fieldGroup) {
      final title = (fieldGroup['title'] as TextEditingController).text.trim();
      final question = (fieldGroup['question'] as TextEditingController).text.trim();
      final options = (fieldGroup['controllers'] as List<TextEditingController>).map((controller) => controller.text.trim()).toList();
      return title.isEmpty || question.isEmpty || options.any((option) => option.isEmpty);
    });

    if (invalidDraft) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Remplissez le titre, l’énoncé et les 4 options pour chaque question.')),
      );
      return;
    }

    try {
      for (final fieldGroup in questionDrafts) {
        final title = (fieldGroup['title'] as TextEditingController).text.trim();
        final question = (fieldGroup['question'] as TextEditingController).text.trim();
        final options = (fieldGroup['controllers'] as List<TextEditingController>).map((controller) => controller.text.trim()).toList();
        final correctIndex = fieldGroup['correctIndex'] as int;

        await FirebaseFirestore.instance.collection('questions').add({
          'title': title,
          'question': question,
          'options': options,
          'correctIndex': correctIndex,
          'courseId': _selectedCourseId,
          'courseName': _selectedCourseName,
          'createdAt': Timestamp.now(),
        });
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Question(s) ajoutée(s) avec succès !')),
      );
      for (final fieldGroup in _questionFields) {
        (fieldGroup['title'] as TextEditingController).clear();
        (fieldGroup['question'] as TextEditingController).clear();
        for (final controller in fieldGroup['controllers'] as List<TextEditingController>) {
          controller.clear();
        }
      }
      _questionFields.clear();
      setState(() {});
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de l’ajout de la question : $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Ajouter un nouveau cours', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Titre du cours',
                      border: OutlineInputBorder(),
                    ),
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"[a-zA-ZÀ-ÖØ-öø-ÿ0-9\s'-]"))],
                    validator: (value) => value == null || value.isEmpty ? 'Veuillez entrer un titre' : null,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Description du cours',
                      border: OutlineInputBorder(),
                    ),
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"[a-zA-ZÀ-ÖØ-öø-ÿ0-9\s'.,;:-]"))],
                    validator: (value) => value == null || value.isEmpty ? 'Veuillez entrer une description' : null,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _categoryController,
                    decoration: const InputDecoration(
                      labelText: 'Catégorie du cours',
                      border: OutlineInputBorder(),
                    ),
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"[a-zA-ZÀ-ÖØ-öø-ÿ\s'-]"))],
                    validator: (value) => value == null || value.trim().isEmpty ? 'Veuillez entrer une catégorie' : null,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _coverURLController,
                    decoration: const InputDecoration(
                      labelText: 'URL de la couverture',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0D47A1)),
                      onPressed: _isSaving ? null : _submitCourse,
                      child: Text(_isSaving ? 'Enregistrement...' : 'Enregistrer le cours', style: const TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Divider(),
            const SizedBox(height: 20),
            const Text('Ajouter un chapitre', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            TextFormField(
              controller: _chapterTitleController,
              decoration: const InputDecoration(
                labelText: 'Titre du chapitre',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _chapterContentController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Contenu du chapitre',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _chapterImageController,
              decoration: const InputDecoration(
                labelText: 'Image du chapitre (URL)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _chapterLinkController,
              decoration: const InputDecoration(
                labelText: 'Lien utile du chapitre',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Ajouter une question QCM', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _getCourseOptions(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting || _isLoadingCourses) {
                  return const Center(child: CircularProgressIndicator());
                }

                final courses = snapshot.data ?? [];
                if (courses.isEmpty) {
                  return const Text('Aucun cours disponible pour le moment.');
                }

                return DropdownButtonFormField<String>(
                  value: _selectedCourseId,
                  decoration: const InputDecoration(
                    labelText: 'Choisir le cours',
                    border: OutlineInputBorder(),
                  ),
                  items: courses.map((course) {
                    return DropdownMenuItem<String>(
                      value: course['id'] as String,
                      child: Text(course['title'] as String),
                    );
                  }).toList(),
                  onChanged: (value) {
                    final selected = courses.firstWhere((course) => course['id'] == value);
                    setState(() {
                      _selectedCourseId = value;
                      _selectedCourseName = selected['title'] as String;
                    });
                  },
                );
              },
            ),
            const SizedBox(height: 20),
            ..._questionFields.asMap().entries.map((entry) {
              final index = entry.key;
              final fieldGroup = entry.value;
              final optionControllers = fieldGroup['controllers'] as List<TextEditingController>;
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Question ${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: fieldGroup['title'] as TextEditingController,
                      decoration: InputDecoration(
                        labelText: 'Titre de la question ${index + 1}',
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: fieldGroup['question'] as TextEditingController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Énoncé',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...List.generate(4, (optionIndex) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Radio<int>(
                              value: optionIndex,
                              groupValue: fieldGroup['correctIndex'] as int,
                              onChanged: (value) {
                                setState(() {
                                  fieldGroup['correctIndex'] = value ?? 0;
                                });
                              },
                            ),
                            Expanded(
                              child: TextFormField(
                                controller: optionControllers[optionIndex],
                                decoration: InputDecoration(
                                  labelText: 'Option ${optionIndex + 1}',
                                  border: const OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              );
            }).toList(),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: _addQuestionField,
                icon: const Icon(Icons.add_circle_outline),
                label: const Text('Ajouter une autre question'),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: _submitQuestion,
                child: const Text('Ajouter la/les question(s)', style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------------------------
// 3. Ekran Lis Etidyan yo
// ------------------------------------------------------------
class TeacherStudentsBody extends StatelessWidget {
  const TeacherStudentsBody({super.key});

  Stream<List<Map<String, dynamic>>> _studentStream() {
    return FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'student')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              return {
                'uid': doc.id,
                'name': data['nom'] ?? 'Étudiant',
                'email': data['email'] ?? 'email@inconnu.com',
                'institution': data['institution'] ?? 'Non renseignée',
                'avatarURL': data['avatarURL'] ?? '',
              };
            }).toList());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _studentStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final students = snapshot.data ?? [];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Étudiants inscrits', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                if (students.isEmpty)
                  const Text('Aucun étudiant inscrit pour le moment.')
                else
                  ...students.map((student) => _buildStudentCard(context, student)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStudentCard(BuildContext context, Map<String, dynamic> student) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TeacherStudentDetailScreen(student: student)),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: const Color(0xFF0D47A1),
                backgroundImage: (student['avatarURL'] ?? '').toString().isNotEmpty ? NetworkImage(student['avatarURL']) : null,
                child: (student['avatarURL'] ?? '').toString().isEmpty ? const Icon(Icons.person, color: Colors.white) : null,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(student['name'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(student['email'], style: const TextStyle(color: Colors.grey)),
                    const SizedBox(height: 6),
                    Text('Institution: ${student['institution']}', style: const TextStyle(fontSize: 14)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

// ------------------------------------------------------------
// 4. Ekran Profil Enseignant (Koulye a li gen aksè pou edite ak chanje modpas)
// ------------------------------------------------------------
class TeacherProfileBody extends StatelessWidget {
  const TeacherProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Profil Enseignant', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue,
              backgroundImage: (authProvider.avatarURL ?? '').isNotEmpty ? NetworkImage(authProvider.avatarURL!) : null,
              child: (authProvider.avatarURL ?? '').isEmpty ? const Icon(Icons.person, size: 60, color: Colors.white) : null,
            ),
            const SizedBox(height: 20),
            Text(authProvider.nom ?? 'Non Enseignant', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(authProvider.user?.email ?? 'email@example.com', style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 30),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.edit, color: Colors.blue),
                    title: const Text('Edite Profil'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.lock, color: Colors.orange),
                    title: const Text('Changer le mot de passe'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ChangePasswordScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _institutionController = TextEditingController();
  final TextEditingController _avatarURLController = TextEditingController();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    _nameController.text = authProvider.nom ?? '';
    _emailController.text = authProvider.user?.email ?? '';
    _institutionController.text = authProvider.user != null ? '' : '';
    _avatarURLController.text = authProvider.avatarURL ?? '';
    final userDoc = FirebaseFirestore.instance.collection('users').doc(authProvider.user?.uid ?? '');
    userDoc.get().then((doc) {
      if (doc.exists && mounted) {
        final data = doc.data() ?? {};
        setState(() {
          _institutionController.text = data['institution'] ?? '';
        });
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _institutionController.dispose();
    _avatarURLController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.updateProfile(
      nom: _nameController.text.trim(),
      email: _emailController.text.trim(),
      institution: _institutionController.text.trim(),
      avatarURL: _avatarURLController.text.trim(),
    );

    if (!mounted) return;

    setState(() => _isSaving = false);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil mis à jour avec succès !')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(authProvider.errorMessage ?? 'Erreur lors de la mise à jour.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier le profil'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: 'Se déconnecter',
            onPressed: () {
              showDialog(
                context: context,
                builder: (dialogContext) {
                  return AlertDialog(
                    title: const Text('Déconnexion'),
                    content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Annuler')),
                      TextButton(
                        onPressed: () async {
                          Navigator.pop(dialogContext);
                          final authProvider = Provider.of<AuthProvider>(context, listen: false);
                          await authProvider.logout();
                          if (!context.mounted) return;
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginScreen()),
                            (route) => false,
                          );
                        },
                        child: const Text('Déconnecter', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nom complet', border: OutlineInputBorder()),
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"[a-zA-ZÀ-ÖØ-öø-ÿ\s'-]"))],
                validator: (value) => value == null || value.trim().isEmpty ? 'Ce champ est obligatoire.' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'Ce champ est obligatoire.';
                  if (!value.contains('@')) return 'Email invalide.';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _institutionController,
                decoration: const InputDecoration(labelText: 'Institution', border: OutlineInputBorder()),
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"[a-zA-ZÀ-ÖØ-öø-ÿ\s'-]"))],
                validator: (value) => value == null || value.trim().isEmpty ? 'Ce champ est obligatoire.' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _avatarURLController,
                decoration: const InputDecoration(labelText: 'URL de la photo de profil', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveProfile,
                  child: _isSaving ? const CircularProgressIndicator(color: Colors.white) : const Text('Enregistrer les modifications'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.changePassword(
      currentPassword: _currentPasswordController.text,
      newPassword: _newPasswordController.text,
    );

    if (!mounted) return;

    setState(() => _isSaving = false);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mot de passe mis à jour avec succès !')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(authProvider.errorMessage ?? 'Erreur lors du changement de mot de passe.')),
      );
    }
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Déconnexion'),
          content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Annuler')),
            TextButton(
              onPressed: () async {
                Navigator.pop(dialogContext);
                final authProvider = Provider.of<AuthProvider>(context, listen: false);
                await authProvider.logout();
                if (!context.mounted) return;
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              },
              child: const Text('Déconnecter', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Changer le mot de passe'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.maybePop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Se déconnecter',
            onPressed: () => _showLogoutConfirmation(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _currentPasswordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Ancien mot de passe', border: OutlineInputBorder()),
                validator: (value) => value == null || value.isEmpty ? 'Ce champ est obligatoire.' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Nouveau mot de passe', border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Ce champ est obligatoire.';
                  if (value.length < 6) return 'Le mot de passe doit contenir au moins 6 caractères.';
                  return null;
                },
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _changePassword,
                  child: _isSaving ? const CircularProgressIndicator(color: Colors.white) : const Text('Mettre à jour le mot de passe'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}