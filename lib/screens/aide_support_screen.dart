import 'package:flutter/material.dart';

class AideSupportScreen extends StatelessWidget {
  const AideSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Aide & Support', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('FAQ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0D47A1))),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  _buildFAQTile('Kijan pou m kòmanse yon kuis?', 'Ale sou paj kuis la, chwazi nivo ou vle a epi klike sou kòmanse.', isDark),
                  _buildFAQTile('Kouman pou m telechaje sètifika m?', 'Lè w fin pase tout kuis yo ak 80% oswa plis, bouton telechaje a ap parèt nan paj sètifika w.', isDark),
                  _buildFAQTile('Mwen jwenn yon erè nan kòd la, kisa pou m fè?', 'Ou ka poze kesyon nan Forum lan pou lòt elèv oswa pwofesè yo ka ede w rapid.', isDark),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQTile(String question, String answer, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        title: Text(question, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(answer, style: TextStyle(color: isDark ? Colors.grey[300] : Colors.grey[700])),
          )
        ],
      ),
    );
  }
}