import 'package:flutter/material.dart';
import 'quiz_result_screen.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestionIndex = 0; // Kòmanse nan premye kesyon an (0)
  int _score = 0; // Pou kalkile repons ki kòrèk yo
  int? _selectedOptionIndex; // Null pa defo pou fòse moun lan chwazi yon repons anvan l kontinye

  // Lis 8 kesyon yo ak opsyon yo, plis endèks repons ki kòrèk la (correctIndex)
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Question ${_currentQuestionIndex + 1} sur ${_questions.length}',
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Row(
              children: [
                const Icon(Icons.access_time, color: Colors.grey, size: 20),
                const SizedBox(width: 5),
                Text(
                  '0:30',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[800]),
                ),
              ],
            ),
          )
        ],
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bar de progression dinamik anlè a
            Container(
              width: double.infinity,
              height: 4,
              color: Colors.grey[100],
              child: Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: (_currentQuestionIndex + 1) / _questions.length,
                  child: Container(
                    color: const Color(0xFF0D47A1),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Kesyon an
            Text(
              currentQuestion["question"],
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, height: 1.4),
            ),
            const SizedBox(height: 30),

            // Lis chwa yo (Options)
            Expanded(
              child: ListView.builder(
                itemCount: currentQuestion["options"].length,
                itemBuilder: (context, index) {
                  bool isSelected = _selectedOptionIndex == index;
                  String prefix = String.fromCharCode(65 + index); // A, B, C, D

                  return GestureDetector(
                    onTap: () => setState(() => _selectedOptionIndex = index),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue.withOpacity(0.05) : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? const Color(0xFF0D47A1) : Colors.grey.withOpacity(0.3),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFF0D47A1) : Colors.grey[200],
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              prefix,
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.black87,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Text(
                              currentQuestion["options"][index],
                              style: TextStyle(
                                fontSize: 15,
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
            ),

            // Bouton pou kontinye oswa valide
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _selectedOptionIndex == null
                    ? null // Bouton an ap dezactive si moun lan pa chwazi anyen
                    : () {
                        // 1. Tcheke si repons lan bon pou ogmante nòt la
                        if (_selectedOptionIndex == currentQuestion["correctIndex"]) {
                          _score++;
                        }

                        // 2. Tcheke si se dènye kesyon an pou nou ale nan rezilta
                        if (isLastQuestion) {
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
                          // Sinon, ale nan pwochen kesyon an epi netwaye opsyon ki te chwazi a
                          setState(() {
                            _currentQuestionIndex++;
                            _selectedOptionIndex = null;
                          });
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D47A1),
                  disabledBackgroundColor: Colors.grey[300],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  isLastQuestion ? 'Valider le quiz' : 'Continuer',
                  style: TextStyle(
                    color: _selectedOptionIndex == null ? Colors.grey[600] : Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}