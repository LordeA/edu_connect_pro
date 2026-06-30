// ============================================================
// EduConnect Pro — Modèles Firestore complets
// Membre B — Semaine 1
// Structure : users / cours / chapitres / quiz /
//             inscriptions / quiz_results
// ============================================================

import 'package:cloud_firestore/cloud_firestore.dart';

// ============================================================
// COLLECTION : users/{uid}
// ============================================================
class UserModel {
  final String uid;
  final String role; // 'teacher' | 'student'
  final String nom;
  final String avatarURL;
  final String institution;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.role,
    required this.nom,
    required this.avatarURL,
    required this.institution,
    required this.createdAt,
  });

  // Convertir un document Firestore en UserModel
  factory UserModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      role: data['role'] ?? 'student',
      nom: data['nom'] ?? '',
      avatarURL: data['avatarURL'] ?? '',
      institution: data['institution'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  // Convertir un UserModel en Map pour Firestore
  Map<String, dynamic> toMap() {
    return {
      'role': role,
      'nom': nom,
      'avatarURL': avatarURL,
      'institution': institution,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}

// ============================================================
// COLLECTION : cours/{courseId}
// ============================================================
class CourseModel {
  final String id;
  final String teacherId;     // UID de l'enseignant auteur
  final String titre;
  final String description;
  final String categorie;     // Ex: 'Programmation', 'Réseaux'
  final String coverURL;      // URL image de couverture (Firebase Storage)
  final int chapitresCount;   // Nombre total de chapitres
  final int inscritCount;     // Nombre d'étudiants inscrits
  final bool isPublie;        // Visible dans le catalogue ou non
  final DateTime createdAt;

  CourseModel({
    required this.id,
    required this.teacherId,
    required this.titre,
    required this.description,
    required this.categorie,
    required this.coverURL,
    required this.chapitresCount,
    required this.inscritCount,
    required this.isPublie,
    required this.createdAt,
  });

  factory CourseModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CourseModel(
      id: doc.id,
      teacherId: data['teacherId'] ?? '',
      titre: data['titre'] ?? '',
      description: data['description'] ?? '',
      categorie: data['categorie'] ?? '',
      coverURL: data['coverURL'] ?? '',
      chapitresCount: data['chapitresCount'] ?? 0,
      inscritCount: data['inscritCount'] ?? 0,
      isPublie: data['isPublie'] ?? false,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'teacherId': teacherId,
      'titre': titre,
      'description': description,
      'categorie': categorie,
      'coverURL': coverURL,
      'chapitresCount': chapitresCount,
      'inscritCount': inscritCount,
      'isPublie': isPublie,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}

// ============================================================
// SOUS-COLLECTION : cours/{courseId}/chapitres/{chapitreId}
// ============================================================
class ChapitreModel {
  final String id;
  final String titre;
  final String contenu;   // Texte Markdown du chapitre
  final int ordre;        // Position dans le cours (1, 2, 3...)
  final bool hasQuiz;     // Indique si un quiz est associé

  ChapitreModel({
    required this.id,
    required this.titre,
    required this.contenu,
    required this.ordre,
    required this.hasQuiz,
  });

  factory ChapitreModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ChapitreModel(
      id: doc.id,
      titre: data['titre'] ?? '',
      contenu: data['contenu'] ?? '',
      ordre: data['ordre'] ?? 0,
      hasQuiz: data['hasQuiz'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'titre': titre,
      'contenu': contenu,
      'ordre': ordre,
      'hasQuiz': hasQuiz,
    };
  }
}

// ============================================================
// SOUS-COLLECTION : cours/{courseId}/quizes/{quizId}
// ============================================================

// Modèle d'une question individuelle
class QuestionModel {
  final String question;
  final List<String> options;   // 4 options de réponse
  final int correctIndex;       // Index de la bonne réponse (0-3)

  QuestionModel({
    required this.question,
    required this.options,
    required this.correctIndex,
  });

  factory QuestionModel.fromMap(Map<String, dynamic> map) {
    return QuestionModel(
      question: map['question'] ?? '',
      options: List<String>.from(map['options'] ?? []),
      correctIndex: map['correctIndex'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'options': options,
      'correctIndex': correctIndex,
    };
  }
}

// Modèle du quiz complet
class QuizModel {
  final String id;
  final String chapitreId;            // Chapitre associé
  final List<QuestionModel> questions;
  final int? dureeMinutes;            // Temps limite (optionnel)

  QuizModel({
    required this.id,
    required this.chapitreId,
    required this.questions,
    this.dureeMinutes,
  });

  factory QuizModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return QuizModel(
      id: doc.id,
      chapitreId: data['chapitreId'] ?? '',
      questions: (data['questions'] as List<dynamic>? ?? [])
          .map((q) => QuestionModel.fromMap(q as Map<String, dynamic>))
          .toList(),
      dureeMinutes: data['dureeMinutes'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'chapitreId': chapitreId,
      'questions': questions.map((q) => q.toMap()).toList(),
      'dureeMinutes': dureeMinutes,
    };
  }
}

// ============================================================
// COLLECTION : inscriptions/{studentId_courseId}
// Clé composite : "${studentId}_${courseId}"
// ============================================================
class InscriptionModel {
  final String studentId;
  final String courseId;
  final double progressPourcentage;       // 0.0 à 100.0
  final List<String> chapitresTermines;   // IDs des chapitres lus
  final DateTime inscritAt;

  InscriptionModel({
    required this.studentId,
    required this.courseId,
    required this.progressPourcentage,
    required this.chapitresTermines,
    required this.inscritAt,
  });

  // ID du document Firestore (clé composite)
  static String buildId(String studentId, String courseId) {
    return '${studentId}_$courseId';
  }

  factory InscriptionModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return InscriptionModel(
      studentId: data['studentId'] ?? '',
      courseId: data['courseId'] ?? '',
      progressPourcentage: (data['progressPourcentage'] ?? 0).toDouble(),
      chapitresTermines: List<String>.from(data['chapitresTermines'] ?? []),
      inscritAt: (data['inscritAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'studentId': studentId,
      'courseId': courseId,
      'progressPourcentage': progressPourcentage,
      'chapitresTermines': chapitresTermines,
      'inscritAt': Timestamp.fromDate(inscritAt),
    };
  }
}

// ============================================================
// COLLECTION : quiz_results/{resultId}
// CRITIQUE : un seul résultat par étudiant par quiz
// Clé composite : "${studentId}_${quizId}"
// ============================================================
class QuizResultModel {
  final String id;
  final String studentId;
  final String quizId;
  final String courseId;
  final double score;           // Score en pourcentage (0-100)
  final List<int> reponses;     // Index des réponses choisies par l'étudiant
  final DateTime soumisAt;

  QuizResultModel({
    required this.id,
    required this.studentId,
    required this.quizId,
    required this.courseId,
    required this.score,
    required this.reponses,
    required this.soumisAt,
  });

  // ID du document (clé composite garantissant l'unicité)
  static String buildId(String studentId, String quizId) {
    return '${studentId}_$quizId';
  }

  factory QuizResultModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return QuizResultModel(
      id: doc.id,
      studentId: data['studentId'] ?? '',
      quizId: data['quizId'] ?? '',
      courseId: data['courseId'] ?? '',
      score: (data['score'] ?? 0).toDouble(),
      reponses: List<int>.from(data['reponses'] ?? []),
      soumisAt: (data['soumisAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'studentId': studentId,
      'quizId': quizId,
      'courseId': courseId,
      'score': score,
      'reponses': reponses,
      'soumisAt': Timestamp.fromDate(soumisAt),
    };
  }
}

// ============================================================
// SOUS-COLLECTION : cours/{courseId}/commentaires/{commentId}
// Utilisée pour le forum temps réel (Stream)
// ============================================================
class CommentaireModel {
  final String id;
  final String auteurId;    // UID de l'auteur (teacher ou student)
  final String auteurNom;
  final String contenu;
  final String role;        // 'teacher' | 'student' (pour distinguer visuellement)
  final DateTime createdAt;

  CommentaireModel({
    required this.id,
    required this.auteurId,
    required this.auteurNom,
    required this.contenu,
    required this.role,
    required this.createdAt,
  });

  factory CommentaireModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CommentaireModel(
      id: doc.id,
      auteurId: data['auteurId'] ?? '',
      auteurNom: data['auteurNom'] ?? '',
      contenu: data['contenu'] ?? '',
      role: data['role'] ?? 'student',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'auteurId': auteurId,
      'auteurNom': auteurNom,
      'contenu': contenu,
      'role': role,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
