import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:edu_connect_pro/providers/auth_provider.dart';
import 'login_screen.dart';
import 'package:edu_connect_pro/screens/dashboard/student_dashboard.dart';
import 'package:edu_connect_pro/screens/dashboard/teacher_dashboard.dart';

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
  bool _splashCompleted = false;
  bool _navigated = false;

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
        _splashCompleted = true;
        Timer(const Duration(milliseconds: 400), () {
          _tryNavigate();
        });
      }
    });
  }

  void _tryNavigate() {
    if (!mounted || _navigated || !_splashCompleted) return;

    final authProvider = context.read<AuthProvider>();
    if (!authProvider.isInitialized) {
      Timer(const Duration(milliseconds: 100), _tryNavigate);
      return;
    }

    _navigated = true;
    if (authProvider.isAuthenticated && authProvider.rememberMe) {
      if (authProvider.isStudent && authProvider.user != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => StudentDashboard(userId: authProvider.user!.uid),
          ),
        );
        return;
      }
      if (authProvider.isTeacher) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const TeacherDashboard(),
          ),
        );
        return;
      }
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/splash_character.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stack) => Container(
                  color: const Color(0xFFE7EDFA),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    size: 72,
                      color: kDarkBlue.withAlpha(102),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xEEFFFFFF),
                      const Color(0x33FFFFFF),
                    ],
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 24),

                  Center(
                    child: Image.asset(
                      'assets/images/torque.png',
                      height: 90,
                      width: 90,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 16),

                  RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                        shadows: [
                          Shadow(
                            blurRadius: 6,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                          ),
                        ],
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
                  const SizedBox(height: 8),
                  const Text(
                    'Apprendre . Progresser . Réussir',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF3A3A3A),
                      shadows: [
                        Shadow(
                          blurRadius: 6,
                          color: Colors.black12,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                  ),

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
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF2A2A2A),
                              ),
                            ),
                            const SizedBox(height: 14),
                            Row(
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: LinearProgressIndicator(
                                      value: _progress.value,
                                      minHeight: 10,
                                      backgroundColor:
                                          const Color(0xFFE1E6EF),
                                      valueColor:
                                          const AlwaysStoppedAnimation<Color>(
                                        kBlue,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                SizedBox(
                                  width: 46,
                                  child: Text(
                                    '$pct%',
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(
                                      fontSize: 16,
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
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}