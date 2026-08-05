import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProgressProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  double _progress = 0.0;
  double get progress => _progress;

  // Load progress from Firestore and cache locally
  Future<void> loadProgress(String studentId, String courseId) async {
    final key = 'progress_${studentId}_$courseId';
    final doc = await _firestore.collection('inscriptions').doc('${studentId}_$courseId').get();
    if (doc.exists) {
      _progress = (doc.data()?['progressionPourcentage'] as num?)?.toDouble() ?? 0.0;
      // cache locally
      final sp = await SharedPreferences.getInstance();
      await sp.setString(key, jsonEncode({'progress': _progress, 'updatedAt': DateTime.now().toIso8601String()}));
      notifyListeners();
    } else {
      // try load from cache
      final sp = await SharedPreferences.getInstance();
      final s = sp.getString(key);
      if (s != null) {
        final data = jsonDecode(s) as Map<String, dynamic>;
        _progress = (data['progress'] as num?)?.toDouble() ?? 0.0;
        notifyListeners();
      }
    }
  }

  Future<void> updateProgress(String studentId, String courseId, double newProgress) async {
    _progress = newProgress;
    notifyListeners();
    await _firestore.collection('inscriptions').doc('${studentId}_$courseId').update({'progressionPourcentage': _progress, 'updatedAt': FieldValue.serverTimestamp()});
    final sp = await SharedPreferences.getInstance();
    await sp.setString('progress_${studentId}_$courseId', jsonEncode({'progress': _progress, 'updatedAt': DateTime.now().toIso8601String()}));
  }
}
