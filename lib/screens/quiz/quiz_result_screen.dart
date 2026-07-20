import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_connect_pro/screens/badges_list_screen.dart';

// =========================================================================
// 1. PAJ REZILTA KUIS LA (QuizResultScreen) - KOUNYEA LI SOVE NAN FIREBASE
// =========================================================================
class QuizResultScreen extends StatelessWidget {
  final int score;
  final int totalQuestions;
  // Nou ajoute userId pou n ka konnen pou ki elèv n ap sove nòt la
  final String userId = "ID_ELÈV_LA"; 

  const QuizResultScreen({
    super.key,
    required this.score,
    required this.totalQuestions,
  });

  @override
  Widget build(BuildContext context) {
    final double percentage = (score / totalQuestions) * 100;

    String appreciation = "Excellent!";
    String message = "Felicitation!";
    Color scoreColor = const Color(0xFF2E7D32);

    if (percentage >= 80) {
      appreciation = "Excellent!";
      message = "Felicitation!";
      scoreColor = const Color(0xFF2E7D32);
    } else if (percentage >= 50) {
      appreciation = "Bien joué!";
      message = "Pas mal!";
      scoreColor = Colors.orange;
    } else {
      appreciation = "Continuez à apprendre!";
      message = "Dommage!";
      scoreColor = Colors.red;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              Center(
                child: Icon(
                  Icons.emoji_events,
                  size: 130,
                  color: Colors.amber[600],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$message ',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const Text('🎉', style: TextStyle(fontSize: 22)),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Vous avez terminé le quiz',
                style: TextStyle(fontSize: 15, color: Colors.grey[700]),
              ),
              const SizedBox(height: 20),
              Text(
                '$score/$totalQuestions',
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text(
                '${percentage.toInt()}%',
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: scoreColor),
              ),
              const SizedBox(height: 5),
              Text(
                appreciation,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),

              // Kat klike sou Badges yo
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BadgesListScreen(),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          const Icon(Icons.star, color: Color(0xFF0D47A1), size: 40),
                          Icon(Icons.star, color: Colors.amber[700], size: 22),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Badge obtenu',
                              style: TextStyle(fontSize: 12, color: Colors.grey[600], fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Maitrise Flutter',
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right, color: Colors.grey[400]),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              // Bouton "Continuer" k ap mete Firebase ajou kounye a
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () async {
                    // Nou montre yon Loading pandan n ap sove nan Firebase
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => const Center(child: CircularProgressIndicator()),
                    );

                    try {
                      // Nou mete nòt kuis la ak chapit la ajou nan Firestore
                      await FirebaseFirestore.instance.collection('users').doc(userId).set({
                        'quizReussis': FieldValue.increment(1),
                        'chapitresTermines': percentage >= 50 ? FieldValue.increment(1) : FieldValue.increment(0),
                        'tempsPasse': '2h 45m',
                      }, SetOptions(merge: true));
                    } catch (e) {
                      debugPrint("Erè lè n ap sove nan Firebase: $e");
                    }

                    // Nou fèmen loading an
                    if (context.mounted) Navigator.pop(context);

                    // Nou deplase ale sou paj ProgressionScreen an
                    if (context.mounted) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProgressionScreen(userId: userId),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D47A1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Continuer',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

// =========================================================================
// 2. PAJ PWOGRÈ DINAMIK AK FIREBASE (ProgressionScreen)
// =========================================================================
class ProgressionScreen extends StatefulWidget {
  final String userId;

  const ProgressionScreen({
    super.key,
    required this.userId,
  });

  @override
  State<ProgressionScreen> createState() => _ProgressionScreenState();
}

class _ProgressionScreenState extends State<ProgressionScreen> {
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
        stream: FirebaseFirestore.instance.collection('users').doc(widget.userId).snapshots(),
        builder: (context, snapshot) {
          // Pandan n ap tann done yo chaje depi nan Firebase
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Si nou pa jwenn dokiman sa a nan Firebase ditou
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(
              child: Text(
                "Aucune donnée de progression trouvée.",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            );
          }

          // Nou rekipere done yo nan dokiman an kounye a
          final userData = snapshot.data!.data() as Map<String, dynamic>;
          final int chapitresTermines = userData['chapitresTermines'] ?? 0;
          final int quizReussis = userData['quizReussis'] ?? 0;
          final String tempsPasse = userData['tempsPasse'] ?? "0h 00m";

          // Kalkil pousantaj pwogrè a (Pa egzanp sou yon total 12 chapit)
          double calculPourcentage = (chapitresTermines / 12);
          if (calculPourcentage > 1.0) calculPourcentage = 1.0; // Pou l pa depase 100%
          
          int pourcentageAfficher = (calculPourcentage * 100).toInt();

          // Yon ti sekirite pou UI a si pousantaj la se 0%
          double progressValue = calculPourcentage == 0 ? 0.02 : calculPourcentage;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sèk Pwogrè Dinamik selon Firebase
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 180,
                        height: 180,
                        child: CircularProgressIndicator(
                          value: progressValue,
                          strokeWidth: 14,
                          backgroundColor: Colors.grey[200],
                          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF0D47A1)),
                        ),
                      ),
                      Text(
                        '$pourcentageAfficher%',
                        style: const TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Kat Statistik Dinamik ak Done Firebase yo
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildStatRow(Icons.menu_book, 'Chapitres terminés', '$chapitresTermines/12', Colors.green),
                      const Divider(height: 1, indent: 50),
                      _buildStatRow(Icons.assignment_turned_in, 'Quiz réussis', '$quizReussis/12', Colors.green),
                      const Divider(height: 1, indent: 50),
                      _buildStatRow(Icons.access_time, 'Temps passé', tempsPasse, Colors.green),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Seksyon Badges obtenus
                // Seksyon Badges obtenus (KORÈK 100%)
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    const Text(
      'Badges obtenus',
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
    ),
    TextButton(
      onPressed: () {
        // Si w vle wè tout badges yo
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const BadgesListScreen(),
          ),
        );
      },
      child: const Text('Voir tout', style: TextStyle(color: Colors.blue)),
    ),
  ],
),
                const SizedBox(height: 12),

                // Badges yo ap parèt selon pwogrè reyèl timoun nan nan Firebase
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildBadgeItem(Icons.emoji_events, Colors.amber),
                    const SizedBox(width: 16),
                    if (pourcentageAfficher >= 40) _buildBadgeItem(Icons.star, Colors.orange),
                    if (pourcentageAfficher >= 40) const SizedBox(width: 16),
                    if (pourcentageAfficher >= 75) _buildBadgeItem(Icons.workspace_premium, Colors.purple),
                    if (pourcentageAfficher >= 75) const SizedBox(width: 16),
                    if (pourcentageAfficher == 100) _buildBadgeItem(Icons.military_tech, Colors.red),
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
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeItem(IconData icon, Color color) {
    return Container(
      width: 55,
      height: 55,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 1)),
        ],
        border: Border.all(color: color.withOpacity(0.5), width: 1),
      ),
      child: Icon(icon, color: color, size: 32),
    );
  }
}