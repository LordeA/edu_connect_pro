import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/quiz_model.dart';

class QuizService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Submit quiz answers. Enforces one submission by using document id: '{quizId}_{studentId}'
  Future<int> submitQuiz({
    required String quizId,
    required String studentId,
    required List<int> answers,
  }) async {
    final docId = '${quizId}_$studentId';
    final ref = _firestore.collection('quiz_results').doc(docId);
    final existing = await ref.get();
    if (existing.exists) {
      throw Exception('Quiz already submitted');
    }

    // Load quiz to compute score
    final quizDoc = await _firestore.collection('cours_quizes').doc(quizId).get();
    if (!quizDoc.exists) throw Exception('Quiz not found');
    final quiz = QuizModel.fromMap(quizDoc.id, quizDoc.data()!);

    int correct = 0;
    for (var i = 0; i < quiz.questions.length && i < answers.length; i++) {
      if (quiz.questions[i].correctIndex == answers[i]) correct++;
    }
    final score = ((correct / quiz.questions.length) * 100).toInt();

    await ref.set({
      'studentId': studentId,
      'quizId': quizId,
      'score': score,
      'reponses': answers,
      'soumisAt': FieldValue.serverTimestamp(),
    });

    return score;
  }
}
