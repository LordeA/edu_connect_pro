import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/course_service.dart';
import '../../providers/auth_provider.dart';

class CreateCourseScreen extends StatefulWidget {
  const CreateCourseScreen({super.key});

  @override
  State<CreateCourseScreen> createState() => _CreateCourseScreenState();
}

class _CreateCourseScreenState extends State<CreateCourseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _categoryCtrl = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _categoryCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final svc = Provider.of<CourseService>(context, listen: false);
      final auth = Provider.of<AuthProvider>(context, listen: false);
      final user = auth.user;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Veuillez vous connecter avant de créer un cours.')));
        setState(() => _loading = false);
        return;
      }
      // For now teacherId is placeholder; in real app use AuthProvider
      final teacherId = user.uid;
      final id = await svc.createCourse(
        teacherId: teacherId,
        title: _titleCtrl.text.trim(),
        description: _descCtrl.text.trim(),
        category: _categoryCtrl.text.trim(),
      );
      if (mounted) Navigator.pop(context, id);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Créer un cours')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(controller: _titleCtrl, decoration: const InputDecoration(labelText: 'Titre'), validator: (v) => v == null || v.isEmpty ? 'Requis' : null),
              TextFormField(controller: _descCtrl, decoration: const InputDecoration(labelText: 'Description'), validator: (v) => v == null || v.isEmpty ? 'Requis' : null),
              TextFormField(controller: _categoryCtrl, decoration: const InputDecoration(labelText: 'Catégorie')),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _loading ? null : _submit, child: _loading ? const CircularProgressIndicator() : const Text('Créer')),
            ],
          ),
        ),
      ),
    );
  }
}
