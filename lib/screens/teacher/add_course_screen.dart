import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AddCourseScreen extends StatelessWidget {
  const AddCourseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Créer un nouveau cours'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Tounen nan dashboard pwofesè a
            context.go('/teacher/dashboard');
          },
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Text('Fòm pou ajoute kou a (CRUD) ap bati la a pa kòlèg yo.'),
        ),
      ),
    );
  }
}