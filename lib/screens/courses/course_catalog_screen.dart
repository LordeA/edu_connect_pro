import 'package:flutter/material.dart';
import 'course_detail_screen.dart'; // Sa enpòtan anpil pou paj 7 la ka louvri!

class CourseCatalogScreen extends StatefulWidget {
  const CourseCatalogScreen({super.key});

  @override
  State<CourseCatalogScreen> createState() => _CourseCatalogScreenState();
}

class _CourseCatalogScreenState extends State<CourseCatalogScreen> {
  String _selectedCategory = 'Tous';

  final List<Map<String, dynamic>> _allCourses = [
    {
      'title': 'Flutter & Dart',
      'level': 'Avancé',
      'students': '120 étudiants',
      'rating': '4.8',
      'progress': 0.72,
      'color': Colors.blue,
      'category': 'Développement',
    },
    {
      'title': 'UI/UX Design',
      'level': 'Intermédiaire',
      'students': '56 étudiants',
      'rating': '4.7',
      'progress': 0.45,
      'color': Colors.purple,
      'category': 'Design',
    },
    {
      'title': 'Marketing Digital',
      'level': 'Débutant',
      'students': '120 étudiants',
      'rating': '4.6',
      'progress': 0.30,
      'color': Colors.orange,
      'category': 'Business',
    },
    {
      'title': 'Gestion de Projet',
      'level': 'Intermédiaire',
      'students': '85 étudiants',
      'rating': '4.5',
      'progress': 0.60,
      'color': Colors.green,
      'category': 'Business',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> filteredCourses = _selectedCategory == 'Tous'
        ? _allCourses
        : _allCourses.where((course) => course['category'] == _selectedCategory).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Catalogue des cours', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Barre de recherche
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
              ),
              child: const TextField(
                decoration: InputDecoration(
                  icon: Icon(Icons.search, color: Colors.grey),
                  hintText: 'Rechercher un cours...',
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 25),

            // 2. Bouton Kategori yo
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildCategoryButton('Tous'),
                  _buildCategoryButton('Développement'),
                  _buildCategoryButton('Design'),
                  _buildCategoryButton('Business'),
                ],
              ),
            ),
            const SizedBox(height: 25),

            // 3. Lis kou yo (Konekte kounye a ak paj 7 la nèt ale)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredCourses.length,
              itemBuilder: (context, index) {
                final course = filteredCourses[index];
                return _buildCatalogCourseItem(
                  context,
                  course['title'],
                  '${course['level']} - ${course['students']}',
                  course['rating'],
                  course['progress'],
                  course['color'],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryButton(String categoryName) {
    final bool isSelected = _selectedCategory == categoryName;
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedCategory = categoryName; 
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF0D47A1) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: isSelected ? null : Border.all(color: Colors.grey.shade300),
          ),
          child: Text(
            categoryName,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCatalogCourseItem(BuildContext context, String title, String subtitle, String rating, double progress, Color color) {
    return GestureDetector(
      onTap: () {
        // Isit la nou fòse navigasyon an louvri paj 7 la (CourseDetailScreen)
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CourseDetailScreen(courseTitle: title),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.01), blurRadius: 5)],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.assignment, color: Colors.blue), 
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      const SizedBox(width: 4),
                      Text(rating, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black54)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Text('${(progress * 100).toInt()}%', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}