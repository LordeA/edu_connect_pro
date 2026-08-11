import 'package:flutter/material.dart';

class CourseLectureScreen extends StatelessWidget {
  final String chapterTitle;
  final int chapterNumero;
  final String chapterContent;
  final String chapterMedia;

  const CourseLectureScreen({
    super.key,
    required this.chapterTitle,
    required this.chapterNumero,
    this.chapterContent = '',
    this.chapterMedia = '',
  });

  @override
  Widget build(BuildContext context) {
    final cleanTitle = chapterTitle.replaceFirst(RegExp(r'^\d+\s*-\s*'), '');
    final bodyText = chapterContent.isNotEmpty
        ? chapterContent
        : 'Flutter est un framework UI de Google pour créer des applications natives sur mobile, web et desktop à partir d\'une seule base de code.';
    final resources = chapterMedia
        .split(RegExp(r'\r?\n'))
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context, false),
        ),
        title: Text(
          'Chapitre $chapterNumero sur 12',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Kontni chapit la (Woulo / Scroll)
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    
                    // Gwo Tit Chapit la (egz: "Les bases de Flutter")
                    Text(
                      cleanTitle,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Kat Ilistrasyon an (Gradient fonse ak logo Flutter nan mitan)
                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Liy dekorasyon nan background nan
                          Positioned(
                            right: -10,
                            top: -10,
                            child: Icon(
                              Icons.grid_4x4,
                              size: 140,
                              color: Colors.white.withValues(alpha: 0.02),
                            ),
                          ),
                          // Logo Flutter a nan mitan
                          const FlutterLogo(size: 70),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),

                    Text(
                      bodyText,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                        height: 1.5,
                      ),
                    ),
                    if (resources.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F7FF),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFCFD8E3)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Ressources du chapitre', style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            ...resources.map((resource) => Padding(
                                  padding: const EdgeInsets.only(bottom: 6),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Icon(Icons.link, size: 16, color: Color(0xFF0D47A1)),
                                      const SizedBox(width: 6),
                                      Expanded(child: Text(resource, style: const TextStyle(color: Colors.black87))),
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),

            // Seksyon kontwòl anba a (Bar de progression ak bouton "Précédent" / "Suivant")
            Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24, top: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 1. Bar de progression divize an de ak nimewo a nan mitan
                  Row(
                    children: [
                      // Pati vèt la ki montre pwogrè a
                      Expanded(
                        flex: chapterNumero,
                        child: Container(
                          height: 6,
                          decoration: BoxDecoration(
                            color: const Color(0xFF00C853),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                      // Tèks pwogrè a nan mitan bar la
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          '$chapterNumero/12',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      // Pati gri a ki montre sa k rete a
                      Expanded(
                        flex: 12 - chapterNumero,
                        child: Container(
                          height: 6,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // 2. Bouton navigasyon yo (Précédent ak Suivant)
                  Row(
                    children: [
                      // Bouton Précédent
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context, false); // Tounen san make l kòm konplete
                            },
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.white,
                              side: BorderSide(color: Colors.grey.shade200, width: 1.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 1,
                              shadowColor: Colors.black.withValues(alpha: 0.05),
                            ),
                            child: const Text(
                              'Précédent',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Bouton Suivant
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context, true); // Retounen vre pou di chapit la fini!
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0D47A1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 2,
                            ),
                            child: const Text(
                              'Suivant',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}