import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class TeacherDashboardScreen extends StatelessWidget {
  const TeacherDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Enseignant'),
        actions: [
  IconButton(
    icon: const Icon(Icons.logout),
    onPressed: () => context.read<AuthProvider>().logout(),
  ),
],
      ),
      body: const Center(
        child: Text('Lis kou ou yo ap parèt la a.'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navigasyon pou ale nan paj kreyasyon kou a
          context.go('/teacher/add-course');
        },
        label: const Text('Ajoute yon kou'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}