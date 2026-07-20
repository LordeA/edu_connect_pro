import 'package:flutter/material.dart';

class QuizListScreen extends StatelessWidget {
  const QuizListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quiz Disponibles')),
      body: ListView(
        children: [
          _buildQuizItem('Flutter Avancé', true), // Disponib
          _buildQuizItem('Firebase Database', false), // Verouye
          _buildQuizItem('UI/UX Design', false), // Verouye
        ],
      ),
    );
  }

  Widget _buildQuizItem(String title, bool isAvailable) {
    return ListTile(
      leading: Icon(isAvailable ? Icons.quiz : Icons.lock, color: isAvailable ? Colors.blue : Colors.grey),
      title: Text(title),
      trailing: isAvailable ? const Icon(Icons.arrow_forward) : null,
      onTap: isAvailable ? () { /* Navige sou paj quiz la */ } : null,
    );
  }
}