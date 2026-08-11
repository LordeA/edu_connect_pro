import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';

import '../../models/firestore_models.dart';
import '../../providers/auth_provider.dart' as app_auth;
import '../../services/course_service.dart';
import 'course_lecture_screen.dart';
import 'course_quiz_screen.dart';

class CourseDetailScreen extends StatefulWidget {
  final CourseModel course;

  const CourseDetailScreen({super.key, required this.course});

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  final CourseService _courseService = CourseService();

  bool _hasAccess = false;
  bool _isLoadingEnrollment = false;
  
  // Swiv 12 chapit yo lè yo konplete
  final Set<int> _completedChapters = {}; 
  
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  final ScrollController _scrollController = ScrollController();
  final GlobalKey _chaptersSectionKey = GlobalKey();

  List<ChapitreModel> _chapters = [];

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  bool get _isQuizUnlocked {
    return _completedChapters.length == _chapters.length && _chapters.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    _loadChapters();
    _checkEnrollmentStatus();
  }

  Future<void> _checkEnrollmentStatus() async {
    final authProvider = context.read<app_auth.AuthProvider>();
    final user = authProvider.user;
    if (user == null) return;

    final hasEnrollment = await _courseService.hasEnrollment(userId: user.uid, courseId: widget.course.id);

    if (!mounted) return;
    setState(() {
      _hasAccess = hasEnrollment;
    });
  }

  Future<void> _loadChapters() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('cours')
        .doc(widget.course.id)
        .collection('chapitres')
        .orderBy('ordre')
        .get();

    setState(() {
      _chapters = snapshot.docs.map((doc) => ChapitreModel.fromDoc(doc)).toList();
    });
  }

  void _scrollToChapters() {
    Scrollable.ensureVisible(
      _chaptersSectionKey.currentContext!,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _registerToCourse(BuildContext? snackBarContext) async {
    final authProvider = context.read<app_auth.AuthProvider>();
    final user = authProvider.user;
    if (user == null) {
      if (snackBarContext != null && snackBarContext.mounted) {
        ScaffoldMessenger.of(snackBarContext).showSnackBar(const SnackBar(content: Text('Connectez-vous pour vous inscrire.')));
      }
      return;
    }

    setState(() => _isLoadingEnrollment = true);
    try {
      await _courseService.enrollStudent(userId: user.uid, courseId: widget.course.id);

      final refreshedEnrollment = await _courseService.hasEnrollment(userId: user.uid, courseId: widget.course.id);

      if (!mounted) return;
      setState(() {
        _hasAccess = refreshedEnrollment;
        _isLoadingEnrollment = false;
      });
      if (snackBarContext != null && snackBarContext.mounted) {
        ScaffoldMessenger.of(snackBarContext).showSnackBar(
          SnackBar(
            content: Text(refreshedEnrollment ? 'Inscription réussie.' : 'L’inscription a été enregistrée localement, mais la confirmation n’a pas encore été retrouvée.'),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoadingEnrollment = false);
      if (snackBarContext != null && snackBarContext.mounted) {
        ScaffoldMessenger.of(snackBarContext).showSnackBar(SnackBar(content: Text('Erreur d’inscription : $e')));
      }
    }
  }

  void _showRegistrationSheet(BuildContext context) {
    final screenContext = context;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext bc) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.0),
              topRight: Radius.circular(25.0),
            ),
          ),
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(bc).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Formulaire d\'inscription',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue[900]),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _nomController,
                    keyboardType: TextInputType.name,
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s-àâäéèêëîïôöùûüçÀÂÄÉÈÊËÎÏÔÖÙÛÜÇ]'))],
                    decoration: InputDecoration(
                      labelText: 'Nom',
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    validator: (value) => (value == null || value.trim().isEmpty) ? 'Veuillez saisir votre nom' : null,
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _prenomController,
                    keyboardType: TextInputType.name,
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s-àâäéèêëîïôöùûüçÀÂÄÉÈÊËÎÏÔÖÙÛÜÇ]'))],
                    decoration: InputDecoration(
                      labelText: 'Prénom',
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    validator: (value) => (value == null || value.trim().isEmpty) ? 'Veuillez saisir votre prénom' : null,
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Adresse Email',
                      prefixIcon: const Icon(Icons.email_outlined),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    validator: (value) => (value == null || value.trim().isEmpty) ? 'Veuillez saisir votre email' : null,
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      labelText: 'Numéro de téléphone',
                      prefixIcon: const Icon(Icons.phone_outlined),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    validator: (value) => (value == null || value.trim().isEmpty) ? 'Veuillez saisir votre téléphone' : null,
                  ),
                  const SizedBox(height: 25),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          Navigator.pop(bc);
                          await _registerToCourse(screenContext);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0D47A1),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('Valider et Commencer', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner bleu
            Container(
              width: double.infinity,
              height: 180,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF0D47A1), Color(0xFF1976D2)]),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(widget.course.titre, style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 15),

            // Seksyon Enfòmasyon Pwofesè a
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  const Icon(Icons.person, color: Color(0xFF0D47A1), size: 18),
                  const SizedBox(width: 6),
                  Text(
                    widget.course.categorie,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(width: 15),
                  const Icon(Icons.star, color: Colors.amber, size: 18),
                  const SizedBox(width: 4),
                  const Text(
                    '4.8',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(width: 15),
                  Icon(Icons.people_alt_outlined, color: Colors.grey[600], size: 18),
                  const SizedBox(width: 6),
                  Text(
                    '${widget.course.inscritCount} inscrits',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),

            // Deskripsyon Kou a
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                widget.course.description.isNotEmpty
                    ? widget.course.description
                    : 'Apprenez à créer des applications mobiles modernes avec ${widget.course.titre} de A à Z.',
                style: TextStyle(color: Colors.grey[700], fontSize: 14),
              ),
            ),
            const SizedBox(height: 20),

            // GRID BLÒK ENTÈRAKTIF YO
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 1. Bouton Chapitres
                  GestureDetector(
                    onTap: _scrollToChapters,
                    child: _buildDetailInfo('${_chapters.length}', 'Chapitres', isActive: true),
                  ),

                  // 2. Bouton Quiz
                  GestureDetector(
                    onTap: () {
                      if (!_hasAccess) {
                        _showRegistrationSheet(context);
                      } else if (!_isQuizUnlocked) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('⚠️ Terminez d\'abord les ${_chapters.length} chapitres pour débloquer le Quiz !'),
                            backgroundColor: Colors.orange,
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CourseQuizScreen(courseTitle: widget.course.titre)),
                        );
                      }
                    },
                    child: _buildDetailInfo(
                      '8', 
                      'Quiz', 
                      isActive: _isQuizUnlocked, 
                      isLocked: !_isQuizUnlocked,
                    ),
                  ),

                  // 3. Durée (Static)
                  _buildDetailInfo('10h', 'Durée', isActive: false),
                ],
              ),
            ),
            const SizedBox(height: 25),

            // Bouton S'inscrire
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                onPressed: _hasAccess || _isLoadingEnrollment ? null : () => _showRegistrationSheet(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _hasAccess ? Colors.grey : const Color(0xFF00C853),
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: _isLoadingEnrollment
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : Text(_hasAccess ? 'Déjà inscrit au cours' : 'S\'inscrire au cours', style: const TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 25),

            // Seksyon Chapitres Title
            Padding(
              key: _chaptersSectionKey,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Chapitres', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(
                    'Progression: ${_completedChapters.length}/${_chapters.length}',
                    style: TextStyle(
                      color: _isQuizUnlocked ? Colors.green : Colors.orange[800], 
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Lis 12 Chapit yo
            if (_chapters.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Text('Aucun chapitre publié pour ce cours pour le moment.'),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _chapters.length,
                itemBuilder: (context, index) {
                  final chapter = _chapters[index];
                  final isCompleted = _completedChapters.contains(index);
                  return GestureDetector(
                    onTap: () async {
                      if (_hasAccess) {
                        final result = await Navigator.push<bool>(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CourseLectureScreen(
                              chapterTitle: chapter.titre,
                              chapterNumero: index + 1,
                              chapterContent: chapter.contenu,
                              chapterMedia: chapter.media,
                            ),
                          ),
                        );

                        if (result == true) {
                          setState(() {
                            _completedChapters.add(index);
                          });
                        }
                      } else {
                        _showRegistrationSheet(context);
                      }
                    },
                    child: Opacity(
                      opacity: _hasAccess ? 1.0 : 0.5,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isCompleted ? Colors.green : Colors.grey.shade200,
                            width: isCompleted ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isCompleted ? Icons.check_circle : (_hasAccess ? Icons.play_circle_fill : Icons.lock),
                              color: isCompleted ? Colors.green : (_hasAccess ? const Color(0xFF0D47A1) : Colors.grey),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                chapter.titre,
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // Ti Widget pou bwat detay yo
  Widget _buildDetailInfo(String value, String label, {required bool isActive, bool isLocked = false}) {
    return Container(
      width: 95,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isActive ? const Color(0xFF0D47A1) : Colors.grey.shade200,
          width: isActive ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                  color: isActive ? const Color(0xFF0D47A1) : Colors.black87,
                ),
              ),
              if (isLocked) ...[
                const SizedBox(width: 4),
                const Icon(Icons.lock, size: 14, color: Colors.grey),
              ]
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive ? const Color(0xFF0D47A1) : Colors.grey[600],
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}