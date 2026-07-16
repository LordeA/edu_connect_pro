import 'package:flutter/material.dart';

class CourseQuizScreen extends StatefulWidget {
  final String courseTitle;

  const CourseQuizScreen({super.key, required this.courseTitle});

  @override
  State<CourseQuizScreen> createState() => _CourseQuizScreenState();
}

class _CourseQuizScreenState extends State<CourseQuizScreen> {
  int _currentQuestionIndex = 0;
  int? _selectedAnswerIndex;
  int _score = 0;

  // Lis 8 kesyon yo pou Quiz la (jan sa endike nan makèt la: 8 Quiz)
  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'Quel langage de programmation est principalement utilisé par Flutter ?',
      'answers': ['Java', 'Dart', 'Kotlin', 'Swift'],
      'correctIndex': 1,
    },
    {
      'question': 'Quel widget est utilisé comme point d\'entrée d\'une application Flutter ?',
      'answers': ['RunApp()', 'MaterialApp()', 'Scaffold()', 'Container()'],
      'correctIndex': 1,
    },
    {
      'question': 'Qu\'est-ce qu\'un StatelessWidget dans Flutter ?',
      'answers': [
        'Un widget qui peut changer d\'état dynamiquement',
        'Un widget qui ne possède pas d\'état interne mutable',
        'Un widget utilisé uniquement pour les bases de données',
        'Un widget de navigation'
      ],
      'correctIndex': 1,
    },
    {
      'question': 'Quelle commande permet de créer un nouveau projet Flutter en ligne de commande ?',
      'answers': ['flutter start', 'flutter init', 'flutter create', 'flutter new'],
      'correctIndex': 2,
    },
    {
      'question': 'Quelle méthode est appelée pour reconstruire un State dans un StatefulWidget ?',
      'answers': ['build()', 'setState()', 'initState()', 'updateState()'],
      'correctIndex': 1,
    },
    {
      'question': 'Quel fichier est utilisé pour gérer les dépendances et les assets dans un projet Flutter ?',
      'answers': ['config.xml', 'package.json', 'pubspec.yaml', 'build.gradle'],
      'correctIndex': 2,
    },
    {
      'question': 'Comment s\'appelle le moteur de rendu graphique haute performance de Flutter ?',
      'answers': ['Skia / Impeller', 'WebKit', 'OpenGL', 'DirectX'],
      'correctIndex': 0,
    },
    {
      'question': 'Quelle fonction Dart est le point d\'entrée de toute exécution de code ?',
      'answers': ['start()', 'run()', 'main()', 'init()'],
      'correctIndex': 2,
    },
  ];

  void _nextQuestion() {
    if (_selectedAnswerIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez sélectionner une réponse avant de continuer !'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_selectedAnswerIndex == _questions[_currentQuestionIndex]['correctIndex']) {
      _score++;
    }

    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswerIndex = null;
      });
    } else {
      _showResultDialog();
    }
  }

  void _showResultDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text('Quiz Terminé ! 🎉', textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Votre score est de :',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            const SizedBox(height: 10),
            Text(
              '$_score / ${_questions.length}',
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF0D47A1)),
            ),
            const SizedBox(height: 15),
            Text(
              _score >= 5 ? 'Excellent travail !' : 'Continuez à réviser !',
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
            ),
          ],
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Fèmen dialòg la
                Navigator.pop(context); // Retounen nan detay kou a
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0D47A1),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Fermer', style: TextStyle(color: Colors.white)),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = _questions[_currentQuestionIndex];
    final progress = (_currentQuestionIndex + 1) / _questions.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Evaluation Quiz',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 1. Banyè Ble anlè a pou Quiz la (Menm jan ak Page 9 la)
          Container(
            width: double.infinity,
            height: 150,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0D47A1), Color(0xFF1976D2)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Flutter & Dart Quiz',
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Question ${_currentQuestionIndex + 1} de ${_questions.length}',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),

          // 2. Linear Progress Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF00C853)),
                minHeight: 8,
              ),
            ),
          ),

          // 3. Kesyon ak Repons yo
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Bwat Kesyon an
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.02),
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Text(
                      currentQuestion['question'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Lis Bouton Chwa yo
                  ...List.generate(
                    currentQuestion['answers'].length,
                    (index) {
                      final isSelected = _selectedAnswerIndex == index;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedAnswerIndex = index;
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFFE3F2FD) : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected ? const Color(0xFF0D47A1) : Colors.grey.shade200,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 22,
                                height: 22,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected ? const Color(0xFF0D47A1) : Colors.grey,
                                    width: 2,
                                  ),
                                  color: isSelected ? const Color(0xFF0D47A1) : Colors.transparent,
                                ),
                                child: isSelected
                                    ? const Icon(Icons.check, size: 14, color: Colors.white)
                                    : null,
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Text(
                                  currentQuestion['answers'][index],
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    color: isSelected ? const Color(0xFF0D47A1) : Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // 4. Bouton Navigasyon / Pwochen Kesyon anba nèt
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _nextQuestion,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D47A1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                ),
                child: Text(
                  _currentQuestionIndex == _questions.length - 1 ? 'Soumettre' : 'Suivant',
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}