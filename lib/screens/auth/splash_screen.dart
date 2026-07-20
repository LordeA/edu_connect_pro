import 'dart:async';
import 'package:flutter/material.dart';

/// Splash screen d'EduConnect Pro.
/// - Logo + nom de l'app + slogan en haut
/// - Illustration du personnage (asset) au centre, dans un cercle
/// - Barre de progression animée "Chargement..." en bas
/// - Vague décorative tout en bas
///
/// FAIRE avant utilisation :
/// 1. Placer l'image du personnage dans : assets/images/splash_character.png
/// 2. Dans pubspec.yaml, ajouter :
///      flutter:
///        assets:
///          - assets/images/splash_character.png
/// 3. Naviguer vers ce widget au démarrage (ex: home: const SplashScreen())
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _progress;

  static const Color kBlue = Color(0xFF1E4FD9);
  static const Color kDarkBlue = Color(0xFF17307A);
  static const Color kGreen = Color(0xFF1FA24A);

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );
    _progress = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();

    // Une fois le chargement termin�, on passe � l'�cran suivant.
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Timer(const Duration(milliseconds: 400), () {
          if (!mounted) return;
          Navigator.of(context).pushReplacementNamed('/login');
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF3F6FC), Color(0xFFFFFFFF)],
          ),
        ),
        child: Stack(
          children: [
            // Vague d�corative en bas de l'�cran
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: ClipPath(
                clipper: _WaveClipper(),
                child: Container(
                  height: size.height * 0.12,
                  color: const Color(0xFFDCE6FA),
                ),
              ),
            ),

            SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 32),

                  // --- Logo + nom de l'app ---
                  _buildLogo(),
                  const SizedBox(height: 8),
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                      ),
                      children: [
                        TextSpan(
                          text: 'EduConnect ',
                          style: TextStyle(color: kBlue),
                        ),
                        TextSpan(
                          text: 'Pro',
                          style: TextStyle(color: kGreen),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Apprendre . Progresser . R�ussir',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF3A3A3A),
                    ),
                  ),

                  const Spacer(),

                  // --- Illustration du personnage ---
                  _buildCharacter(size),

                  const Spacer(),

                  // --- Barre de progression + pourcentage ---
                  AnimatedBuilder(
                    animation: _progress,
                    builder: (context, _) {
                      final pct = (_progress.value * 100).round();
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Column(
                          children: [
                            const Text(
                              'Chargement...',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF2A2A2A),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: LinearProgressIndicator(
                                      value: _progress.value,
                                      minHeight: 8,
                                      backgroundColor:
                                          const Color(0xFFE1E6EF),
                                      valueColor:
                                          const AlwaysStoppedAnimation<Color>(
                                        kBlue,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                SizedBox(
                                  width: 42,
                                  child: Text(
                                    '$pct%',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF2A2A2A),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 90,
      height: 70,
      alignment: Alignment.center,
      child: const Icon(
        Icons.school_rounded,
        size: 64,
        color: kBlue,
      ),
    );
  }

  Widget _buildCharacter(Size size) {
    final double circleSize = size.width * 0.72;
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: circleSize,
          height: circleSize,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFE7EDFA),
          ),
        ),
        Positioned(
          top: 10,
          right: 4,
          child: Icon(Icons.add, color: kBlue.withOpacity(0.5), size: 18),
        ),
        Positioned(
          bottom: 24,
          left: 0,
          child: Icon(Icons.circle, color: kBlue.withOpacity(0.3), size: 12),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Image.asset(
            'assets/images/splash_character.png',
            width: circleSize * 0.9,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stack) => Icon(
              Icons.person,
              size: circleSize * 0.5,
              color: kDarkBlue.withOpacity(0.4),
            ),
          ),
        ),
      ],
    );
  }
}

class _WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height * 0.4);
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.9,
      size.width * 0.5,
      size.height * 0.55,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.2,
      size.width,
      size.height * 0.5,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
