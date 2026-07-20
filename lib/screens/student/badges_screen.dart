import 'package:flutter/material.dart';

class BadgesScreen extends StatelessWidget {
  const BadgesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Progression', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Gwo Sèk Pousantaj la (65%)
            Center(
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, spreadRadius: 2),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 150,
                      height: 150,
                      child: CircularProgressIndicator(
                        value: 0.65,
                        strokeWidth: 14,
                        backgroundColor: Colors.grey[200],
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF0D47A1)),
                      ),
                    ),
                    const Text(
                      '65%',
                      style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Color(0xFF212121)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 35),

            // 2. Lis Liy Pwogresyon yo (Chapit, Kwi, Tan)
            _buildProgressItem(Icons.check_circle_outline, 'Chapitres terminés', '9/12'),
            _buildProgressItem(Icons.check_circle_outline, 'Quiz réussis', '6/8'),
            _buildProgressItem(Icons.access_time, 'Temps passé', '12h 30m'),

            const SizedBox(height: 30),

            // 3. Seksyon Badges obtenus
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Badges obtenus',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('Voir tout', style: TextStyle(color: Colors.blue)),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Ranje Badj yo jan yo ye nan makèt la
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildBadgeIcon(Icons.emoji_events, Colors.amber, true),
                _buildBadgeIcon(Icons.star, Colors.indigo, true),
                _buildBadgeIcon(Icons.local_fire_department, Colors.orange, true),
                _buildBadgeIcon(Icons.school, Colors.grey, false), 
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressItem(IconData icon, String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF4CAF50), size: 28),
              const SizedBox(width: 15),
              Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            ],
          ),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54)),
        ],
      ),
    );
  }

  Widget _buildBadgeIcon(IconData icon, Color color, bool isUnlocked) {
    return Opacity(
      opacity: isUnlocked ? 1.0 : 0.3,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          shape: BoxShape.circle,
          border: Border.all(color: isUnlocked ? color : Colors.transparent, width: 2),
        ),
        child: Icon(icon, size: 30, color: color),
      ),
    );
  }
}