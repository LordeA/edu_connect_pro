import 'package:flutter/material.dart';
import 'package:edu_connect_pro/screens/quiz/quiz_result_screen.dart'; // Enpòtasyon paj rezilta a pou liyaj la ka fèt

class CourseQuizScreen extends StatefulWidget {
  final String courseTitle;

  const CourseQuizScreen({super.key, required this.courseTitle});

  @override
  State<CourseQuizScreen> createState() => _CourseQuizScreenState();
}

class _CourseQuizScreenState extends State<CourseQuizScreen> {
  int _currentQuestionIndex = 0; // Kòmanse nan 0 (premye kesyon)
  int _score = 0; // Pou kalkile repons ki kòrèk yo
  int? _selectedAnswerIndex; // Pou konnen kisa itilizatè a chwazi nan kesyon sa a

  // Lis 8 kesyon ak opsyon yo, plis endèks repons ki kòrèk la (correctIndex)
  final List<Map<String, dynamic>> _questions = [
    {
      "question": "Quelle est la fonction principale de Flutter?",
      "options": [
        "Créer des sites web uniquement",
        "Créer des applications mobiles natives multiplateformes",
        "Gérer des bases de données",
        "Compiler du code Python"
      ],
      "correctIndex": 1 // B
    },
    {
      "question": "Quel langage de programmation utilise Flutter?",
      "options": [
        "Java",
        "Swift",
        "Dart",
        "Kotlin"
      ],
      "correctIndex": 2 // C
    },
    {
      "question": "Qui a développé Flutter?",
      "options": [
        "Apple",
        "Google",
        "Microsoft",
        "Facebook"
      ],
      "correctIndex": 1 // B
    },
    {
      "question": "Quel composant est la base de toute l'UI dans Flutter?",
      "options": [
        "Widget",
        "Activity",
        "ViewController",
        "Element"
      ],
      "correctIndex": 0 // A
    },
    {
      "question": "Quelle commande permet de créer un nouveau projet Flutter?",
      "options": [
        "flutter start project",
        "flutter create mon_projet",
        "flutter new project",
        "flutter init"
      ],
      "correctIndex": 1 // B
    },
    {
      "question": "Quel widget est utilisé pour créer un champ de saisie de texte?",
      "options": [
        "Text",
        "TextField",
        "InputText",
        "TextFormFieldOnly"
      ],
      "correctIndex": 1 // B
    },
    {
      "question": "Comment rafraîchir l'interface graphique d'un StatefulWidget?",
      "options": [
        "setState()",
        "refresh()",
        "updateUI()",
        "reload()"
      ],
      "correctIndex": 0 // A
    },
    {
      "question": "Où configure-t-on les dépendances et packages dans Flutter?",
      "options": [
        "AndroidManifest.xml",
        "main.dart",
        "pubspec.yaml",
        "build.gradle"
      ],
      "correctIndex": 2 // C
    },
  ];

  @override
  Widget build(BuildContext context) {
    final currentQuestion = _questions[_currentQuestionIndex];
    final bool isLastQuestion = _currentQuestionIndex == _questions.length - 1;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Question ${_currentQuestionIndex + 1} sur ${_questions.length}',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          Row(
            children: [
              Icon(Icons.access_time, size: 18, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                '0:30',
                style: TextStyle(
                  color: Colors.grey[800],
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bar de progression dinamik
            Container(
              width: double.infinity,
              height: 4,
              color: Colors.grey[200],
              child: Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: (_currentQuestionIndex + 1) / _questions.length,
                  child: Container(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 35),
                    
                    // Kesyon an
                    Text(
                      currentQuestion["question"],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Lis Opsyon yo
                    Expanded(
                      child: ListView.builder(
                        itemCount: currentQuestion["options"].length,
                        itemBuilder: (context, index) {
                          final String letter = String.fromCharCode(65 + index); // A, B, C, D
                          final bool isSelected = _selectedAnswerIndex == index;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedAnswerIndex = index;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 18,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFFE8EAF6)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFF0D47A1)
                                      : Colors.grey.shade200,
                                  width: isSelected ? 2 : 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.03),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isSelected
                                          ? const Color(0xFFC5CAE9)
                                          : Colors.grey[200],
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      letter,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: isSelected
                                            ? const Color(0xFF0D47A1)
                                            : Colors.grey[700],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Text(
                                      currentQuestion["options"][index],
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: isSelected
                                            ? const Color(0xFF0D47A1)
                                            : Colors.black87,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // Bouton Aksyon an
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24.0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _selectedAnswerIndex == null
                              ? null // Bouton an dezactive si moun lan pa chwazi anyen
                              : () {
                                  // 1. Tcheke si repons lan bon pou ogmante score la
                                  if (_selectedAnswerIndex == currentQuestion["correctIndex"]) {
                                    _score++;
                                  }

                                  // 2. Tcheke si se dènye kesyon an
                                  if (isLastQuestion) {
                                    // Louvri paj rezilta a ak vrè score la!
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => QuizResultScreen(
                                          score: _score,
                                          totalQuestions: _questions.length,
                                        ),
                                      ),
                                    );
                                  } else {
                                    // Sinon, pase nan pwochen kesyon an epi netwaye repons chwazi a
                                    setState(() {
                                      _currentQuestionIndex++;
                                      _selectedAnswerIndex = null;
                                    });
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0D47A1),
                            disabledBackgroundColor: Colors.grey[300],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            isLastQuestion ? 'Valider le quiz' : 'Continuer',
                            style: TextStyle(
                              color: _selectedAnswerIndex == null ? Colors.grey[600] : Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}