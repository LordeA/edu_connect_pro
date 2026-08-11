import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/firestore_models.dart';
import '../../services/course_service.dart';
import 'add_course_screen.dart';
import 'teacher_course_detail_screen.dart';

class CourseManagementScreen extends StatelessWidget {
  const CourseManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Scaffold(body: Center(child: Text('Connectez-vous pour gérer vos cours.')));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des cours'),
        actions: [
          IconButton(
            onPressed: () => context.push('/teacher/add-course'),
            icon: const Icon(Icons.add_circle_outline),
          ),
        ],
      ),
      body: StreamBuilder<List<CourseModel>>(
        stream: CourseService().streamCoursesForTeacher(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Aucun cours créé pour le moment.'),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: () => context.push('/teacher/add-course'),
                    icon: const Icon(Icons.add),
                    label: const Text('Créer un cours'),
                  ),
                ],
              ),
            );
          }

          final courses = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: courses.length,
            itemBuilder: (context, index) {
              final course = courses[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text(course.titre),
                  subtitle: Text('${course.categorie} • ${course.chapitresCount} chapitres'),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => TeacherCourseDetailScreen(course: course)),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => AddCourseScreen(course: course)),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Supprimer ce cours ?'),
                              content: Text('Cette action supprimera aussi ses chapitres et quiz associés.'),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuler')),
                                FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Supprimer')),
                              ],
                            ),
                          );
                          if (confirm == true) {
                            await CourseService().deleteCourse(course.id);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cours supprimé.')));
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
