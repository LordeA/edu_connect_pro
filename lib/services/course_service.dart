import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../models/firestore_models.dart';

class CourseService {
  late final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final FirebaseStorage _storage = FirebaseStorage.instance;

  CollectionReference<Map<String, dynamic>> get _coursesRef =>
      _firestore.collection('cours');

  CollectionReference<Map<String, dynamic>> get _inscriptionsRef =>
      _firestore.collection('inscriptions');

  String buildEnrollmentId({required String userId, required String courseId}) {
    return '${userId}_$courseId';
  }

  Future<void> enrollStudent({required String userId, required String courseId}) async {
    final enrollmentId = buildEnrollmentId(userId: userId, courseId: courseId);
    final docRef = _firestore.collection('inscriptions').doc(enrollmentId);

    await docRef.set({
      'studentId': userId,
      'courseId': courseId,
      'progressPourcentage': 0.0,
      'chapitresTermines': [],
      'inscritAt': Timestamp.now(),
    });

    try {
      await _coursesRef.doc(courseId).update({
        'inscritCount': FieldValue.increment(1),
      });
    } catch (_) {
      // Keep the enrollment itself successful even if the course counter update is rejected.
    }
  }

  Future<bool> hasEnrollment({required String userId, required String courseId}) async {
    final enrollmentId = buildEnrollmentId(userId: userId, courseId: courseId);
    final doc = await _inscriptionsRef.doc(enrollmentId).get();
    return doc.exists;
  }

  Future<void> updateEnrollmentProgress({
    required String userId,
    required String courseId,
    required List<String> completedChapterIds,
    int totalChapters = 0,
  }) async {
    final enrollmentId = buildEnrollmentId(userId: userId, courseId: courseId);
    final progress = totalChapters <= 0
        ? 0.0
        : ((completedChapterIds.length / totalChapters) * 100).clamp(0.0, 100.0);

    await _inscriptionsRef.doc(enrollmentId).set({
      'studentId': userId,
      'courseId': courseId,
      'progressPourcentage': progress,
      'chapitresTermines': completedChapterIds,
      'tempsPasseMinutes': FieldValue.increment(0),
    }, SetOptions(merge: true));
  }

  Stream<List<AnnouncementModel>> streamAnnouncements(String courseId) {
    return _coursesRef.doc(courseId).collection('annonces').orderBy('createdAt', descending: true).snapshots().map(
          (snapshot) => snapshot.docs.map((doc) => AnnouncementModel.fromDoc(doc)).toList(),
        );
  }

  Future<void> addAnnouncement({
    required String courseId,
    required String authorId,
    required String authorName,
    required String role,
    required String content,
  }) async {
    if (content.trim().isEmpty) return;

    await _coursesRef.doc(courseId).collection('annonces').add({
      'courseId': courseId,
      'auteurId': authorId,
      'auteurNom': authorName,
      'contenu': content.trim(),
      'role': role,
      'createdAt': Timestamp.now(),
    });
  }

  Stream<List<CommentaireModel>> streamCourseComments(String courseId) {
    return _coursesRef.doc(courseId).collection('commentaires').orderBy('createdAt', descending: true).snapshots().map(
          (snapshot) => snapshot.docs.map((doc) => CommentaireModel.fromDoc(doc)).toList(),
        );
  }

  Future<void> addComment({
    required String courseId,
    required String authorId,
    required String authorName,
    required String role,
    required String content,
  }) async {
    if (content.trim().isEmpty) return;

    await _coursesRef.doc(courseId).collection('commentaires').add({
      'auteurId': authorId,
      'auteurNom': authorName,
      'contenu': content.trim(),
      'role': role,
      'createdAt': Timestamp.now(),
    });
  }

  Future<List<Map<String, dynamic>>> getCourseParticipants(String courseId) async {
    final snapshot = await _inscriptionsRef.where('courseId', isEqualTo: courseId).get();
    final participants = <Map<String, dynamic>>[];

    for (final doc in snapshot.docs) {
      final data = doc.data();
      final studentId = data['studentId'] as String? ?? '';
      if (studentId.isEmpty) continue;

      final userDoc = await _firestore.collection('users').doc(studentId).get();
      final userData = userDoc.data() ?? {};
      final quizResults = await _firestore
          .collection('quiz_results')
          .where('courseId', isEqualTo: courseId)
          .where('studentId', isEqualTo: studentId)
          .get();

      final scores = quizResults.docs
          .map((result) => (result.data()['score'] as num?)?.toDouble() ?? 0.0)
          .toList();
      final averageScore = scores.isEmpty ? 0.0 : scores.reduce((a, b) => a + b) / scores.length;

      participants.add({
        'studentId': studentId,
        'nom': userData['nom'] ?? 'Étudiant',
        'progressPourcentage': (data['progressPourcentage'] as num?)?.toDouble() ?? 0.0,
        'scoreMoyen': averageScore,
        'tempsPasseMinutes': (data['tempsPasseMinutes'] as num?)?.toInt() ?? 0,
        'inscritAt': (data['inscritAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      });
    }

    participants.sort((a, b) => (b['progressPourcentage'] as double).compareTo(a['progressPourcentage'] as double));
    return participants;
  }

  Stream<List<CourseModel>> streamCoursesForTeacher(String teacherId) {
    return _coursesRef
        .where('teacherId', isEqualTo: teacherId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CourseModel.fromDoc(doc))
            .toList());
  }

  Future<List<CourseModel>> getPublishedCourses() async {
    final snapshot = await _coursesRef
        .where('isPublie', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs.map((doc) => CourseModel.fromDoc(doc)).toList();
  }

  Future<String> createCourse({
    required String teacherId,
    required String titre,
    required String description,
    required String categorie,
    required String coverURL,
    XFile? coverImage,
    required List<Map<String, dynamic>> chapters,
    required List<Map<String, dynamic>> quizQuestions,
  }) async {
    final courseRef = _coursesRef.doc();
    final courseId = courseRef.id;

    String resolvedCoverUrl = coverURL.trim();
    if (coverImage != null) {
      resolvedCoverUrl = await _uploadCoverImage(courseId: courseId, imageFile: coverImage);
    }

    final course = CourseModel(
      id: courseId,
      teacherId: teacherId,
      titre: titre.trim(),
      description: description.trim(),
      categorie: categorie.trim(),
      coverURL: resolvedCoverUrl,
      chapitresCount: chapters.length,
      inscritCount: 0,
      isPublie: true,
      createdAt: DateTime.now(),
    );

    await courseRef.set(course.toMap());

    final validChapters = chapters.where((chapter) => chapter['titre']?.toString().trim().isNotEmpty ?? false).toList();
    for (var i = 0; i < validChapters.length; i++) {
      final chapterData = validChapters[i];
      final chapterRef = courseRef.collection('chapitres').doc();
      final chapter = {
        'titre': chapterData['titre'],
        'contenu': chapterData['contenu'] ?? '',
        'media': chapterData['media'] ?? '',
        'ordre': i + 1,
        'hasQuiz': chapterData['hasQuiz'] == true,
      };
      await chapterRef.set(chapter);

      if (chapterData['hasQuiz'] == true) {
        final quizQuestionsForChapter = List<Map<String, dynamic>>.from(chapterData['quizQuestions'] ?? []);
        if (quizQuestionsForChapter.isNotEmpty) {
          await chapterRef.collection('quizes').add({
            'chapitreId': chapterRef.id,
            'questions': quizQuestionsForChapter.map((q) => {
              'question': q['question'] ?? '',
              'options': q['options'] ?? ['','','',''],
              'correctIndex': q['correctIndex'] ?? 0,
            }).toList(),
            'dureeMinutes': 10,
          });
        }
      }
    }

    return courseId;
  }

  Future<void> updateCourse({
    required String courseId,
    required String title,
    required String description,
    required String categorie,
    required String coverURL,
    XFile? coverImage,
    required List<Map<String, dynamic>> chapters,
    required List<Map<String, dynamic>> quizQuestions,
  }) async {
    final courseRef = _coursesRef.doc(courseId);
    final existing = await courseRef.get();

    String resolvedCoverUrl = coverURL.trim();
    if (coverImage != null) {
      resolvedCoverUrl = await _uploadCoverImage(courseId: courseId, imageFile: coverImage);
    } else if (resolvedCoverUrl.isEmpty) {
      resolvedCoverUrl = (existing.data()?['coverURL'] as String? ?? '').trim();
    }

    final createdAt = existing.exists
        ? ((existing.data()?['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now())
        : DateTime.now();

    final course = CourseModel(
      id: courseId,
      teacherId: existing.data()?['teacherId'] as String? ?? '',
      titre: title.trim(),
      description: description.trim(),
      categorie: categorie.trim(),
      coverURL: resolvedCoverUrl,
      chapitresCount: chapters.length,
      inscritCount: (existing.data()?['inscritCount'] as int?) ?? 0,
      isPublie: true,
      createdAt: createdAt,
    );

    await courseRef.set(course.toMap(), SetOptions(merge: false));

    await _deleteCollectionDocs(ref: courseRef.collection('chapitres'));
    await _deleteCollectionDocs(ref: courseRef.collection('quizes'));

    final validChapters = chapters.where((chapter) => chapter['titre']?.toString().trim().isNotEmpty ?? false).toList();
    for (var i = 0; i < validChapters.length; i++) {
      final chapterData = validChapters[i];
      final chapterRef = courseRef.collection('chapitres').doc();
      await chapterRef.set({
        'titre': chapterData['titre'],
        'contenu': chapterData['contenu'] ?? '',
        'media': chapterData['media'] ?? '',
        'ordre': i + 1,
        'hasQuiz': chapterData['hasQuiz'] == true,
      });

      if (chapterData['hasQuiz'] == true) {
        final quizQuestionsForChapter = List<Map<String, dynamic>>.from(chapterData['quizQuestions'] ?? []);
        if (quizQuestionsForChapter.isNotEmpty) {
          await chapterRef.collection('quizes').add({
            'chapitreId': chapterRef.id,
            'questions': quizQuestionsForChapter.map((q) => {
              'question': q['question'] ?? '',
              'options': q['options'] ?? ['','','',''],
              'correctIndex': q['correctIndex'] ?? 0,
            }).toList(),
            'dureeMinutes': 10,
          });
        }
      }
    }
  }

  Future<void> deleteCourse(String courseId) async {
    final courseRef = _coursesRef.doc(courseId);
    await _deleteCollectionDocs(ref: courseRef.collection('chapitres'));
    await _deleteCollectionDocs(ref: courseRef.collection('quizes'));
    await courseRef.delete();
  }

  Future<String> _uploadCoverImage({required String courseId, required XFile imageFile}) async {
    final storageRef = _storage.ref().child('courses/$courseId/${DateTime.now().millisecondsSinceEpoch}.jpg');
    if (imageFile.path.isNotEmpty) {
      final file = File(imageFile.path);
      final uploadTask = await storageRef.putFile(file);
      return await uploadTask.ref.getDownloadURL();
    }

    final bytes = await imageFile.readAsBytes();
    final uploadTask = await storageRef.putData(bytes);
    return await uploadTask.ref.getDownloadURL();
  }

  Future<void> _deleteCollectionDocs({required CollectionReference<Map<String, dynamic>> ref}) async {
    final snapshot = await ref.get();
    if (snapshot.docs.isEmpty) return;

    final batch = _firestore.batch();
    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }
}
