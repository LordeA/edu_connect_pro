import 'package:flutter/material.dart';

class ForumDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> question;

  const ForumDetailsScreen({super.key, required this.question});

  @override
  State<ForumDetailsScreen> createState() => _ForumDetailsScreenState();
}

class _ForumDetailsScreenState extends State<ForumDetailsScreen> {
  final TextEditingController _replyController = TextEditingController();
  
  final List<Map<String, String>> _replies = [
    {
      'author': 'Jean-Pierre',
      'time': 'Il y a 1h',
      'content': 'Mwen te gen menm pwoblèm nan tou. Mwen te rezoud li lè m te mete yon ChangeNotifierProvider nan tèt pwojè a!'
    },
  ];

  void _addReply() {
    if (_replyController.text.trim().isNotEmpty) {
      final DateTime now = DateTime.now();
      final String formattedTime = 
          "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

      setState(() {
        _replies.add({
          'author': 'Moi',
          'time': formattedTime,
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
                              CircleAvatar(
                                backgroundColor: widget.question['avatarColor'] ?? const Color(0xFF0D47A1),
                                child: const Icon(Icons.person, color: Colors.white),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.question['title'] ?? 'Anonyme',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    widget.question['author'] ?? '',
                                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Detay sou sijè sa a kap diskite nan kominote a...',
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
                    icon: const Icon(Icons.send, color: Color(0xFF0D47A1)),
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