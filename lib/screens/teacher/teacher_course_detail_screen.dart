import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/firestore_models.dart';
import '../../providers/auth_provider.dart' as app_auth;
import '../../services/course_service.dart';

class TeacherCourseDetailScreen extends StatefulWidget {
  final CourseModel course;

  const TeacherCourseDetailScreen({super.key, required this.course});

  @override
  State<TeacherCourseDetailScreen> createState() => _TeacherCourseDetailScreenState();
}

class _TeacherCourseDetailScreenState extends State<TeacherCourseDetailScreen> {
  final CourseService _courseService = CourseService();
  final TextEditingController _announcementController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _announcementController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _publishAnnouncement() async {
    final authProvider = context.read<app_auth.AuthProvider>();
    if (authProvider.user == null) return;
    if (_announcementController.text.trim().isEmpty) return;

    await _courseService.addAnnouncement(
      courseId: widget.course.id,
      authorId: authProvider.user!.uid,
      authorName: authProvider.user!.email ?? 'Enseignant',
      role: 'teacher',
      content: _announcementController.text.trim(),
    );
    _announcementController.clear();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Annonce publiée.')));
    }
  }

  Future<void> _postComment() async {
    final authProvider = context.read<app_auth.AuthProvider>();
    if (authProvider.user == null) return;
    if (_commentController.text.trim().isEmpty) return;

    await _courseService.addComment(
      courseId: widget.course.id,
      authorId: authProvider.user!.uid,
      authorName: authProvider.user!.email ?? 'Enseignant',
      role: 'teacher',
      content: _commentController.text.trim(),
    );
    _commentController.clear();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Message envoyé.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.course.titre)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.course.titre, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(widget.course.description, style: TextStyle(color: Colors.grey[700])),
            const SizedBox(height: 16),
            const Text('Étudiants inscrits', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _courseService.getCourseParticipants(widget.course.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('Aucun étudiant inscrit pour le moment.');
                }

                final students = [...snapshot.data!];
                students.sort((a, b) => ((b['progressPourcentage'] as double?) ?? 0.0).compareTo((a['progressPourcentage'] as double?) ?? 0.0));

                return Column(
                  children: students.map((student) {
                    final progress = ((student['progressPourcentage'] as double?) ?? 0.0).clamp(0.0, 100.0);
                    final score = ((student['scoreMoyen'] as double?) ?? 0.0);
                    final time = (student['tempsPasseMinutes'] as int?) ?? 0;
                    return Card(
                      child: ListTile(
                        title: Text(student['nom'] as String),
                        subtitle: Text('Progression: ${progress.toStringAsFixed(0)}% • Score moyen: ${score.toStringAsFixed(1)} • Temps: $time min'),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: progress >= 80 ? Colors.green.shade50 : (progress >= 50 ? Colors.orange.shade50 : Colors.blue.shade50),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            progress >= 80 ? 'Très avancé' : (progress >= 50 ? 'En cours' : 'À démarrer'),
                            style: TextStyle(
                              color: progress >= 80 ? Colors.green.shade800 : (progress >= 50 ? Colors.orange.shade800 : Colors.blue.shade800),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
            const SizedBox(height: 24),
            const Text('Publier une annonce', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _announcementController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Annonce visible par tous les inscrits', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                onPressed: _publishAnnouncement,
                icon: const Icon(Icons.announcement_outlined),
                label: const Text('Publier'),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Forum du cours', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _commentController,
              maxLines: 2,
              decoration: const InputDecoration(labelText: 'Répondre aux questions des étudiants', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                onPressed: _postComment,
                icon: const Icon(Icons.chat_bubble_outline),
                label: const Text('Envoyer'),
              ),
            ),
            const SizedBox(height: 16),
            StreamBuilder<List<CommentaireModel>>(
              stream: _courseService.streamCourseComments(widget.course.id),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const SizedBox.shrink();
                final comments = snapshot.data!;
                if (comments.isEmpty) {
                  return const Text('Aucune discussion pour le moment.');
                }
                return Column(
                  children: comments.map((comment) => Card(
                    child: ListTile(
                      title: Text(comment.auteurNom),
                      subtitle: Text(comment.contenu),
                      trailing: Text(comment.role == 'teacher' ? 'Enseignant' : 'Étudiant'),
                    ),
                  )).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
