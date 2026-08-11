import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/firestore_models.dart';
import '../../services/course_service.dart';

class AddCourseScreen extends StatefulWidget {
  final CourseModel? course;

  const AddCourseScreen({super.key, this.course});

  @override
  State<AddCourseScreen> createState() => _AddCourseScreenState();
}

class _AddCourseScreenState extends State<AddCourseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  final _coverUrlController = TextEditingController();
  final _chapterTitleController = TextEditingController();
  final _chapterContentController = TextEditingController();
  final _chapterMediaController = TextEditingController();
  final List<Map<String, dynamic>> _chapters = [];
  final List<TextEditingController> _questionControllers = [];
  final List<List<TextEditingController>> _optionControllers = [];
  final List<TextEditingController> _correctIndexControllers = [];
  XFile? _coverImage;
  bool _isLoading = false;
  bool _hasQuiz = false;

  @override
  void initState() {
    super.initState();
    if (widget.course != null) {
      _titleController.text = widget.course!.titre;
      _descriptionController.text = widget.course!.description;
      _categoryController.text = widget.course!.categorie;
      _coverUrlController.text = widget.course!.coverURL;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _coverUrlController.dispose();
    _chapterTitleController.dispose();
    _chapterContentController.dispose();
    _chapterMediaController.dispose();
    for (final controller in _questionControllers) {
      controller.dispose();
    }
    for (final options in _optionControllers) {
      for (final controller in options) {
        controller.dispose();
      }
    }
    for (final controller in _correctIndexControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _pickCoverImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _coverImage = picked);
    }
  }

  Future<void> _saveCourse() async {
    if (!_formKey.currentState!.validate()) return;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Connectez-vous pour créer un cours.')));
      return;
    }

    setState(() => _isLoading = true);
    try {
      if (widget.course == null) {
        await CourseService().createCourse(
          teacherId: user.uid,
          titre: _titleController.text,
          description: _descriptionController.text,
          categorie: _categoryController.text,
          coverURL: _coverUrlController.text,
          coverImage: _coverImage,
          chapters: _chapters,
          quizQuestions: const [],
        );
      } else {
        await CourseService().updateCourse(
          courseId: widget.course!.id,
          title: _titleController.text,
          description: _descriptionController.text,
          categorie: _categoryController.text,
          coverURL: _coverUrlController.text,
          coverImage: _coverImage,
          chapters: _chapters,
          quizQuestions: const [],
        );
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(widget.course == null ? 'Cours créé avec succès.' : 'Cours mis à jour.')));
      context.go('/teacher-dashboard');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur : $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _addChapter() {
    if (_chapterTitleController.text.trim().isEmpty) return;
    setState(() {
      _chapters.add({
        'titre': _chapterTitleController.text.trim(),
        'contenu': _chapterContentController.text.trim(),
        'media': _chapterMediaController.text.trim(),
        'hasQuiz': _hasQuiz,
        'quizQuestions': _questionControllers.isEmpty ? [] : _questionControllers.asMap().entries.map((entry) {
          final index = entry.key;
          final question = _questionControllers[index].text.trim();
          final options = _optionControllers[index].map((controller) => controller.text.trim()).toList();
          final correctIndex = int.tryParse(_correctIndexControllers[index].text) ?? 0;
          return {
            'question': question,
            'options': options,
            'correctIndex': correctIndex.clamp(0, 3),
          };
        }).where((question) => (question['question'] as String).isNotEmpty).toList(),
      });
      _chapterTitleController.clear();
      _chapterContentController.clear();
      _chapterMediaController.clear();
      _hasQuiz = false;
      _questionControllers.clear();
      _optionControllers.clear();
      _correctIndexControllers.clear();
    });
  }

  void _addQuestion() {
    setState(() {
      _questionControllers.add(TextEditingController());
      _optionControllers.add(List.generate(4, (_) => TextEditingController()));
      _correctIndexControllers.add(TextEditingController(text: '0'));
    });
  }

  void _saveQuestion(int index) {
    final question = _questionControllers[index].text.trim();
    if (question.isEmpty) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Question préparée pour le chapitre courant.')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.course == null ? 'Créer un cours' : 'Modifier le cours'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/teacher-dashboard'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Titre du cours'),
                validator: (value) => value == null || value.trim().isEmpty ? 'Obligatoire' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) => value == null || value.trim().isEmpty ? 'Obligatoire' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'Catégorie'),
                validator: (value) => value == null || value.trim().isEmpty ? 'Obligatoire' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _coverUrlController,
                decoration: const InputDecoration(labelText: 'URL de couverture (optionnelle)'),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: _pickCoverImage,
                icon: const Icon(Icons.image),
                label: const Text('Choisir une image de couverture'),
              ),
              if (_coverImage != null) ...[
                const SizedBox(height: 8),
                Text('Image sélectionnée : ${_coverImage!.name}'),
              ],
              if (_coverImage != null && File(_coverImage!.path).existsSync())
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Image.file(File(_coverImage!.path), height: 140),
                ),
              const SizedBox(height: 24),
              const Text('Chapitres', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: _chapterTitleController,
                decoration: const InputDecoration(labelText: 'Titre du chapitre'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _chapterContentController,
                maxLines: 4,
                decoration: const InputDecoration(labelText: 'Contenu enrichi (Markdown / texte)'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _chapterMediaController,
                decoration: const InputDecoration(labelText: 'Liens / images / ressources supplémentaires'),
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Associer un quiz à ce chapitre'),
                value: _hasQuiz,
                onChanged: (value) => setState(() => _hasQuiz = value),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  onPressed: _addChapter,
                  icon: const Icon(Icons.add),
                  label: const Text('Ajouter chapitre'),
                ),
              ),
              if (_chapters.isNotEmpty) ...[
                const SizedBox(height: 12),
                ..._chapters.map((chapter) => Card(
                      child: ListTile(
                        title: Text(chapter['titre']),
                        subtitle: Text(chapter['hasQuiz'] == true ? 'Avec quiz' : 'Sans quiz'),
                      ),
                    )),
              ],
              const SizedBox(height: 24),
              const Text('Questions de quiz', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: _addQuestion,
                icon: const Icon(Icons.quiz_outlined),
                label: const Text('Ajouter une question'),
              ),
              const SizedBox(height: 8),
              ...List.generate(_questionControllers.length, (index) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        TextField(
                          controller: _questionControllers[index],
                          decoration: InputDecoration(labelText: 'Question ${index + 1}'),
                        ),
                        const SizedBox(height: 8),
                        ...List.generate(4, (optionIndex) {
                          return TextField(
                            controller: _optionControllers[index][optionIndex],
                            decoration: InputDecoration(labelText: 'Option ${optionIndex + 1}'),
                          );
                        }),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _correctIndexControllers[index],
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Indice de la bonne réponse (0-3)'),
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () => _saveQuestion(index),
                            child: const Text('Enregistrer question'),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _isLoading ? null : _saveCourse,
                  icon: _isLoading
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.save),
                  label: Text(_isLoading ? (widget.course == null ? 'Création...' : 'Mise à jour...') : (widget.course == null ? 'Créer le cours' : 'Enregistrer les modifications')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}