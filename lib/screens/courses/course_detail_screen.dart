import 'package:flutter/material.dart';
import 'course_lecture_screen.dart';
import 'course_quiz_screen.dart';

class CourseDetailScreen extends StatefulWidget {
  final String courseTitle;

  const CourseDetailScreen({super.key, required this.courseTitle});

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  // Aksè a louvri tout tan pa defo
  final bool _hasAccess = true;
  
  // Swiv 12 chapit yo lè yo konplete
  final Set<int> _completedChapters = {}; 

  final ScrollController _scrollController = ScrollController();
  final GlobalKey _chaptersSectionKey = GlobalKey();

  // Lis 12 Chapit yo jan sa dwe ye pou yon kou Flutter konplè
  final List<String> _chapters = [
    '1- Introduction à Flutter & Mobile',
    '2- Installation du SDK & Configuration',
    '3- Les bases du langage Dart',
    '4- Concepts de Programmation Orientée Objet',
    '5- Premier pas avec les Widgets de base',
    '6- Création de Layouts complexes',
    '7- Gestion des États (State Management)',
    '8- Navigation et Routage entre écrans',
    '9- Connexion aux APIs et services Web',
    '10- Stockage de données locales (SQFlite)',
    '11- Intégration de Firebase (Auth & Firestore)',
    '12- Déploiement sur Play Store & App Store'
  ];

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Quiz la toujou debloque kounye a paske yo gen aksè dirèk
  bool get _isQuizUnlocked {
    return true;
  }

  void _scrollToChapters() {
    Scrollable.ensureVisible(
      _chaptersSectionKey.currentContext!,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner bleu
            Container(
              width: double.infinity,
              height: 180,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF0D47A1), Color(0xFF1976D2)]),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    widget.courseTitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),

            // Seksyon Enfòmasyon Pwofesè a
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  const Icon(Icons.person, color: Color(0xFF0D47A1), size: 18),
                  const SizedBox(width: 6),
                  const Text(
                    'Prof. Jean Claude',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(width: 15),
                  const Icon(Icons.star, color: Colors.amber, size: 18),
                  const SizedBox(width: 4),
                  const Text(
                    '4.8',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(width: 15),
                  Icon(Icons.people_alt_outlined, color: Colors.grey[600], size: 18),
                  const SizedBox(width: 6),
                  Text(
                    '120 élèves',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),

            // Deskripsyon Kou a
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Apprenez à créer des applications mobiles modernes avec ${widget.courseTitle} de A à Z.',
                style: TextStyle(color: Colors.grey[700], fontSize: 14),
              ),
            ),
            const SizedBox(height: 20),

            // GRID BLÒK ENTÈRAKTIF YO
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 1. Bouton Chapitres
                  GestureDetector(
                    onTap: _scrollToChapters,
                    child: _buildDetailInfo('${_chapters.length}', 'Chapitres', isActive: true),
                  ),

                  // 2. Bouton Quiz (Aksè lib kounye a)
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CourseQuizScreen(courseTitle: widget.courseTitle)),
                      );
                    },
                    child: _buildDetailInfo(
                      '8', 
                      'Quiz', 
                      isActive: true, 
                      isLocked: false,
                    ),
                  ),

                  // 3. Durée (Static)
                  _buildDetailInfo('10h', 'Durée', isActive: false),
                ],
              ),
            ),
            const SizedBox(height: 25),

            // Seksyon Chapitres Title
            Padding(
              key: _chaptersSectionKey,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Chapitres', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(
                    'Progression: ${_completedChapters.length}/${_chapters.length}',
                    style: const TextStyle(
                      color: Colors.green, 
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Lis 12 Chapit yo
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _chapters.length,
              itemBuilder: (context, index) {
                final isCompleted = _completedChapters.contains(index);
                return GestureDetector(
                  onTap: () async {
                    // Tout moun ka antre sou lekti yo dirèkteman
                    final result = await Navigator.push<bool>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CourseLectureScreen(
                          chapterTitle: _chapters[index],
                          chapterNumero: index + 1,
                        ),
                      ),
                    );

                    if (result == true) {
                      setState(() {
                        _completedChapters.add(index);
                      });
                    }
                  },
                  child: Opacity(
                    opacity: 1.0,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isCompleted ? Colors.green : Colors.grey.shade200, 
                          width: isCompleted ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isCompleted ? Icons.check_circle : Icons.play_circle_fill,
                            color: isCompleted ? Colors.green : const Color(0xFF0D47A1),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _chapters[index],
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // Ti Widget pou bwat detay yo
  Widget _buildDetailInfo(String value, String label, {required bool isActive, bool isLocked = false}) {
    return Container(
      width: 95,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isActive ? const Color(0xFF0D47A1) : Colors.grey.shade200,
          width: isActive ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                  color: isActive ? const Color(0xFF0D47A1) : Colors.black87,
                ),
              ),
              if (isLocked) ...[
                const SizedBox(width: 4),
                const Icon(Icons.lock, size: 14, color: Colors.grey),
              ]
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive ? const Color(0xFF0D47A1) : Colors.grey[600],
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}