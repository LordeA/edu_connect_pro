import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/course_model.dart';
import '../models/chapter_model.dart';

class CourseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> createCourse({
    required String teacherId,
    required String title,
    required String description,
    String category = '',
    String coverURL = '',
  }) async {
    final ref = await _firestore.collection('cours').add({
      'teacherId': teacherId,
      'title': title,
      'description': description,
      'category': category,
      'coverURL': coverURL,
      'chapitresCompte': 0,
      'inscritCount': 0,
      'isPublié': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return ref.id;
  }

  Future<void> addChapter({required String courseId, required ChapterModel chapter}) async {
    final col = _firestore.collection('cours').doc(courseId).collection('chapitres');
    await col.add(chapter.toMap());
    // increment chapter count
    final courseRef = _firestore.collection('cours').doc(courseId);
    await courseRef.update({'chapitresCompte': FieldValue.increment(1)});
  }

  Stream<List<ChapterModel>> chaptersStream(String courseId) {
    final col = _firestore.collection('cours').doc(courseId).collection('chapitres').orderBy('ordre');
    return col.snapshots().map((snap) => snap.docs.map((d) => ChapterModel.fromMap(d.id, d.data())).toList());
  }

  Future<void> enrollStudent({required String courseId, required String studentId}) async {
    final insRef = _firestore.collection('inscriptions').doc('${studentId}_$courseId');
    await insRef.set({
      'studentId': studentId,
      'courseId': courseId,
      'progressionPourcentage': 0,
      'chapitresTermines': [],
      'inscritAt': FieldValue.serverTimestamp(),
    });
    await _firestore.collection('cours').doc(courseId).update({'inscritCount': FieldValue.increment(1)});
  }

  Future<CourseModel?> getCourse(String id) async {
    final doc = await _firestore.collection('cours').doc(id).get();
    if (!doc.exists) return null;
    return CourseModel.fromMap(doc.id, doc.data()!);
  }
}
