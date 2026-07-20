import 'package:flutter/material.dart';

// ==========================================
// 1. PAJ DETAY KESYON AK REPONS YO
// ==========================================
class ForumDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> question;

  const ForumDetailsScreen({super.key, required this.question});

  @override
  State<ForumDetailsScreen> createState() => _ForumDetailsScreenState();
}

class _ForumDetailsScreenState extends State<ForumDetailsScreen> {
  final TextEditingController _replyController = TextEditingController();
  
  // Kèk egzanp repons tanporè pou ranpli paj la
  final List<Map<String, String>> _replies = [
    {
      'author': 'Jean-Pierre',
      'time': 'Il y a 1h',
      'content': 'Mwen te gen menm pwoblèm nan tou. Mwen te rezoud li lè m te mete yon ChangeNotifierProvider nan tèt pwojè a!'
    },
    {
      'author': 'Marie Lucie',
      'time': 'Il y a 30 min',
      'content': 'Ou ka tcheke dokiman ofisyèl Flutter a sou Provider tou, li bay bèl egzanp senp.'
    }
  ];

  void _addReply() {
    if (_replyController.text.trim().isNotEmpty) {
      setState(() {
        _replies.add({
          'author': 'Moi',
          'time': 'À l\'instant',
          'content': _replyController.text.trim(),
        });
        _replyController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Détails de la discussion'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Kesyon an li menm
                  Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const CircleAvatar(
                                backgroundColor: Colors.grey,
                                child: Icon(Icons.person, color: Colors.white),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.question['author'] ?? 'Anonyme',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    widget.question['time'] ?? '',
                                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            widget.question['title'] ?? '',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Bonjour à tous, j\'aimerais avoir votre avis sur la meilleure façon de structurer mon code pour ce cas précis. Merci d\'avance pour vos réponses !',
                            style: TextStyle(color: Colors.black87, height: 1.4),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Réponses',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  // Lis repons yo
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _replies.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final reply = _replies[index];
                      return Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0.5,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const CircleAvatar(
                                    radius: 16,
                                    backgroundColor: Colors.blueGrey,
                                    child: Icon(Icons.person, color: Colors.white, size: 18),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(reply['author']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                                  const Spacer(),
                                  Text(reply['time']!, style: TextStyle(color: Colors.grey[500], fontSize: 11)),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(reply['content']!, style: const TextStyle(color: Colors.black87)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          // Jaden pou ekri yon nouvo repons anba nèt
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, -2))],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _replyController,
                      decoration: InputDecoration(
                        hintText: 'Écrire une réponse...',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.blue),
                    onPressed: _addReply,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// 2. PAJ POU POZE YON NOUVO KESYON
// ==========================================
class AskQuestionScreen extends StatefulWidget {
  const AskQuestionScreen({super.key});

  @override
  State<AskQuestionScreen> createState() => _AskQuestionScreenState();
}

class _AskQuestionScreenState extends State<AskQuestionScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  void _submit() {
    if (_titleController.text.trim().isNotEmpty) {
      // Nou retounen nouvo kesyon an bay paj fowòm nan
      Navigator.pop(context, {
        'title': _titleController.text.trim(),
        'author': 'Moi',
        'time': 'À l\'instant',
        'replies': 0,
        'isMine': true,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Poser une question'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Votre question (Titre)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: _descController,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  labelText: 'Détails de votre problème...',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0D47A1)),
                onPressed: _submit,
                child: const Text('Publier', style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}