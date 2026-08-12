import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:edu_connect_pro/screens/quiz/quiz_result_screen.dart';
import '../auth/login_screen.dart';

class CourseQuizScreen extends StatefulWidget {
  final String courseId;
  final String courseTitle;

  const CourseQuizScreen({super.key, required this.courseId, required this.courseTitle});

  @override
  State<CourseQuizScreen> createState() => _CourseQuizScreenState();
}

class _CourseQuizScreenState extends State<CourseQuizScreen> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  int? _selectedAnswerIndex;
  List<Map<String, dynamic>> _questions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('questions')
          .where('courseId', isEqualTo: widget.courseId)
          .get();

      if (mounted) {
        setState(() {
          _questions = snapshot.docs.map((doc) => doc.data()).toList();
          // Fallback to hardcoded questions if Firestore is empty
          if (_questions.isEmpty) {
            _questions = _buildFallbackQuestions(widget.courseTitle);
          }
          _currentQuestionIndex = 0;
          _score = 0;
          _selectedAnswerIndex = null;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        // On error, use fallback questions
        setState(() {
          _questions = _buildFallbackQuestions(widget.courseTitle);
          _currentQuestionIndex = 0;
          _score = 0;
          _selectedAnswerIndex = null;
          _isLoading = false;
        });
      }
    }
  }

  List<Map<String, dynamic>> _buildFallbackQuestions(String courseTitle) {
    switch (courseTitle) {
      case 'Flutter & Dart':
        return [
          {
            "question": "Quelle est la fonction principale de Flutter?",
            "options": [
              "Créer des sites web uniquement",
              "Créer des applications mobiles natives multiplateformes",
              "Gérer des bases de données",
              "Compiler du code Python"
            ],
            "correctIndex": 1
          },
          {
            "question": "Quel langage de programmation utilise Flutter?",
            "options": ["Java", "Swift", "Dart", "Kotlin"],
            "correctIndex": 2
          },
          {
            "question": "Qui a développé Flutter?",
            "options": ["Apple", "Google", "Microsoft", "Facebook"],
            "correctIndex": 1
          },
          {
            "question": "Quel composant est la base de toute l'UI dans Flutter?",
            "options": ["Widget", "Activity", "ViewController", "Element"],
            "correctIndex": 0
          },
          {
            "question": "Quelle commande permet de créer un nouveau projet Flutter?",
            "options": [
              "flutter start project",
              "flutter create mon_projet",
              "flutter new project",
              "flutter init"
            ],
            "correctIndex": 1
          },
        ];
      case 'Marketing Digital':
        return [
          {
            "question": "Quelle est l'objectif principal du marketing digital?",
            "options": [
              "Vendre uniquement en magasin",
              "Promouvoir un produit ou service via des canaux numériques ciblés",
              "Créer uniquement des brochures papier",
              "Remplacer tous les réseaux sociaux"
            ],
            "correctIndex": 1
          },
          {
            "question": "Que permet le marketing numérique de mesurer facilement?",
            "options": [
              "La satisfaction des clients uniquement",
              "Les performances et résultats en temps réel",
              "Rien du tout",
              "Seulement les ventes en magasin"
            ],
            "correctIndex": 1
          },
          {
            "question": "Quel canal est souvent utilisé pour le marketing par email?",
            "options": [
              "La radio uniquement",
              "Les campagnes email ciblées",
              "Les appels téléphoniques manuels",
              "Les affiches de rue seulement"
            ],
            "correctIndex": 1
          },
          {
            "question": "Que signifie le community management?",
            "options": [
              "Créer des pages web sans contenu",
              "Animer et entretenir une relation avec les abonnés",
              "Prendre des photos de produits uniquement",
              "Supprimer les commentaires clients"
            ],
            "correctIndex": 1
          },
          {
            "question": "Quel est l'avantage du marketing automation?",
            "options": [
              "Il automatise les messages au bon moment et réduit les tâches répétitives",
              "Il remplace complètement le marketing humain",
              "Il n'a aucun effet sur les conversions",
              "Il arrête les campagnes sociales"
            ],
            "correctIndex": 0
          },
        ];
      case 'UI/UX Design':
        return [
          {
            "question": "Quel est l'objectif principal du design centré utilisateur?",
            "options": [
              "Maximiser le nombre de lignes de code",
              "Comprendre les besoins et comportements de l'utilisateur",
              "Remplacer entièrement le marketing",
              "Supprimer la navigation dans l'application"
            ],
            "correctIndex": 1
          },
          {
            "question": "Pourquoi les grilles de mise en page sont-elles utiles?",
            "options": [
              "Elles rendent le design plus lent",
              "Elles structurent l'information et l'alignement visuel",
              "Elles remplacent le contenu textuel",
              "Elles empêchent toute adaptation mobile"
            ],
            "correctIndex": 1
          },
        ];
      default:
        return [
          {
            "question": "Quelle est la finalité principale de ce cours?",
            "options": [
              "Apprendre et appliquer les concepts du module",
              "Ignorer les objectifs du cours",
              "Supprimer toutes les activités",
              "Rendre le cours inaccessible"
            ],
            "correctIndex": 0
          },
        ];
    }
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
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text('Quiz - ${widget.courseTitle}', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_questions.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text('Quiz - ${widget.courseTitle}', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Aucun quiz disponible pour ce cours.', style: TextStyle(color: Colors.grey[700], fontSize: 16)),
          ),
        ),
      );
    }

    // Safety check: ensure _currentQuestionIndex is valid
    if (_currentQuestionIndex < 0 || _currentQuestionIndex >= _questions.length) {
      _currentQuestionIndex = 0;
    }

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
              const SizedBox(width: 12),
              // Bouton dekoneksyon nan AppBar la
              IconButton(
                icon: const Icon(Icons.logout, color: Colors.red),
                onPressed: () => showLogoutConfirmation(context),
                tooltip: 'Se déconnecter',
              ),
              const SizedBox(width: 8),
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
                  widthFactor: _questions.isEmpty ? 0.0 : (_currentQuestionIndex + 1) / _questions.length,
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