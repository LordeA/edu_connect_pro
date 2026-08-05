class Question {
  final String question;
  final List<String> options;
  final int correctIndex;

  Question({required this.question, required this.options, required this.correctIndex});

  factory Question.fromMap(Map<String, dynamic> m) => Question(
        question: m['question'] as String? ?? '',
        options: List<String>.from(m['options'] as List<dynamic>? ?? []),
        correctIndex: (m['correctIndex'] as int?) ?? 0,
      );

  Map<String, dynamic> toMap() => {
        'question': question,
        'options': options,
        'correctIndex': correctIndex,
      };
}

class QuizModel {
  final String id;
  final String chapterId;
  final List<Question> questions;
  final int durationMinutes;

  QuizModel({required this.id, required this.chapterId, required this.questions, required this.durationMinutes});

  factory QuizModel.fromMap(String id, Map<String, dynamic> m) => QuizModel(
        id: id,
        chapterId: m['chapitreId'] as String? ?? '',
        questions: (m['questions'] as List<dynamic>? ?? []).map((e) => Question.fromMap(e as Map<String, dynamic>)).toList(),
        durationMinutes: (m['dureeMinutes'] as int?) ?? 0,
      );

  Map<String, dynamic> toMap() => {
        'chapitreId': chapterId,
        'questions': questions.map((q) => q.toMap()).toList(),
        'dureeMinutes': durationMinutes,
      };
}
