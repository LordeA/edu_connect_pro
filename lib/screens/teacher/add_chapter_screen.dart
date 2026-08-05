import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/chapter_model.dart';
import '../../services/course_service.dart';

class AddChapterScreen extends StatefulWidget {
  final String courseId;
  const AddChapterScreen({super.key, required this.courseId});

  @override
  State<AddChapterScreen> createState() => _AddChapterScreenState();
}

class _AddChapterScreenState extends State<AddChapterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _contentCtrl = TextEditingController();
  final _orderCtrl = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _contentCtrl.dispose();
    _orderCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final svc = Provider.of<CourseService>(context, listen: false);
      final chapter = ChapterModel(
        id: '',
        title: _titleCtrl.text.trim(),
        content: _contentCtrl.text.trim(),
        order: int.tryParse(_orderCtrl.text) ?? 0,
        hasQuiz: false,
      );
      await svc.addChapter(courseId: widget.courseId, chapter: chapter);
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajouter un chapitre')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(controller: _titleCtrl, decoration: const InputDecoration(labelText: 'Titre'), validator: (v) => v == null || v.isEmpty ? 'Requis' : null),
              TextFormField(controller: _contentCtrl, decoration: const InputDecoration(labelText: 'Contenu (Markdown)'), maxLines: 6),
              TextFormField(controller: _orderCtrl, decoration: const InputDecoration(labelText: 'Ordre'), keyboardType: TextInputType.number),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _loading ? null : _submit, child: _loading ? const CircularProgressIndicator() : const Text('Ajouter')),
            ],
          ),
        ),
      ),
    );
  }
}
