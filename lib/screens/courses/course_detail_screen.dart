import 'package:flutter/material.dart';
import 'chapter_reader_screen.dart';
import '../quiz/quiz_screen.dart';

class CourseDetailScreen extends StatelessWidget {
  final String courseTitle;

  const CourseDetailScreen({super.key, required this.courseTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(courseTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banyè anlè a (Banner)
            Container(
              height: 180,
              width: double.infinity,
              color: const Color(0xFF0D47A1),
              child: const Center(
                child: Icon(Icons.code, size: 80, color: Colors.white),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Enfòmasyon pwofesè
                  const Row(
                    children: [
                      CircleAvatar(radius: 20, backgroundColor: Colors.amber, child: Icon(Icons.person, color: Colors.white)),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Prof. Jean Claude', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          Text('4.8 (120 avis)', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  
                  const Text(
                    'Apprenez à créer des applications mobiles modernes avec Flutter et Dart de A à Z.',
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  const SizedBox(height: 20),

                  // Ti bwat detay yo (Chapitres, Quiz, Durée)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildInfoTile('12', 'Chapitres'),
                      _buildInfoTile('8', 'Quiz'),
                      _buildInfoTile('10h', 'Durée'),
                    ],
                  ),
                  const SizedBox(height: 25),

                  // Bouton S'inscrire
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
onPressed: () {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const QuizScreen()),
  );
},                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4CAF50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text("S'inscrire au cours", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Lis Chapitres yo
                  const Text('Chapitres', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  
                  _buildChapterListTile(context, '1- Introduction à Flutter'),
                  _buildChapterListTile(context, '2- Installation & Configuration'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(String number, String label) {
    return Column(
      children: [
        Text(number, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0D47A1))),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildChapterListTile(BuildContext context, String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChapterReaderScreen(chapterTitle: title)),
          );
        },
      ),
    );
  }
}