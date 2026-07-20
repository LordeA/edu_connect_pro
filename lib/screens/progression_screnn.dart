import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProgressionScreen extends StatelessWidget {
  final String userId;

  const ProgressionScreen({super.key, required this.userId});

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
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(userId).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("Nou pa jwenn done pou elèv sa a."));
          }

          // N ap rekipere done yo nan Firebase kounye a!
          var userData = snapshot.data!.data() as Map<String, dynamic>;
          int chapitres = userData['chapitresTermines'] ?? 0;
          int quiz = userData['quizReussis'] ?? 0;
          String temps = userData['tempsPasse'] ?? "0h 00m";

          // Kalkil pousantaj (Egzanp sou yon total 12 chapit)
          double calculPourcentage = (chapitres / 12);
          int pourcentageAfficher = (calculPourcentage * 100).toInt();

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sèk Pwogrè Dinamik ak Firebase
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 180,
                        height: 180,
                        child: CircularProgressIndicator(
                          value: calculPourcentage > 1.0 ? 1.0 : calculPourcentage,
                          strokeWidth: 14,
                          backgroundColor: Colors.grey[200],
                          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF0D47A1)),
                        ),
                      ),
                      Text(
                        '$pourcentageAfficher%',
                        style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Kat Statistik ki soti nan Firebase
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
                  ),
                  child: Column(
                    children: [
                      _buildStatRow(Icons.access_time, 'Chapitres terminés', '$chapitres/12', Colors.green),
                      const Divider(height: 1, indent: 50),
                      _buildStatRow(Icons.access_time, 'Quiz réussis', '$quiz/8', Colors.green),
                      const Divider(height: 1, indent: 50),
                      _buildStatRow(Icons.access_time, 'Temps passé', temps, Colors.green),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Seksyon Badges
                const Text(
                  'Badges obtenus',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildBadgeItem(Icons.emoji_events, Colors.amber),
                    const SizedBox(width: 16),
                    if (quiz >= 3) _buildBadgeItem(Icons.star, Colors.orange),
                    if (quiz >= 3) const SizedBox(width: 16),
                    if (quiz >= 6) _buildBadgeItem(Icons.star, Colors.orange),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatRow(IconData icon, String title, String value, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(width: 16),
          Expanded(child: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
          Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black54)),
        ],
      ),
    );
  }

  Widget _buildBadgeItem(IconData icon, Color color) {
    return Container(
      width: 55,
      height: 55,
      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
      child: Icon(icon, color: color, size: 32),
    );
  }
}