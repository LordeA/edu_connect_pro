import 'package:flutter/material.dart';

class ChapterReaderScreen extends StatelessWidget {
  final String chapterTitle;

  const ChapterReaderScreen({super.key, required this.chapterTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Chapitre 2 sur 12', style: TextStyle(fontSize: 16, color: Colors.grey)),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(chapterTitle, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),

            // Zòn simulation videyo a
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF1565C0),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Icon(Icons.play_circle_fill, size: 60, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),

            // Tèks eksplikasyon an
            const Expanded(
              child: SingleChildScrollView(
                child: Text(
                  "Flutter est un framework UI de Google pour créer des applications natives sur mobile, web et desktop à partir d'une seule base de code.\n\nIl utilise le langage Dart et offre des performances exceptionnelles grâce à son moteur de rendu graphique propre.",
                  style: TextStyle(fontSize: 15, height: 1.5, color: Colors.black87),
                ),
              ),
            ),

            // Ti bar pwogresyon anba a
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 100,
                  child: LinearProgressIndicator(
                    value: 0.5,
                    backgroundColor: Colors.grey[200],
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                ),
                const SizedBox(width: 10),
                const Text('2/12', style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 20),

            // Bouton Précédent ak Suivant yo
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Précédent', style: TextStyle(color: Colors.black87)),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D47A1),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Suivant', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}