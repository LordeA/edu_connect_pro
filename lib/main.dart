// ============================================================
// EduConnect Pro — main.dart
// Membre A — point d'entrée de l'application
// ============================================================

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:edu_connect_pro/firebase_options.dart';
import 'providers/auth_provider.dart';
import 'package:edu_connect_pro/app_router.dart';import 'providers/course_provider.dart';

void main() async {
  // 1. Toujou asire w Flutter mare ak sistèm nan anlè a piske n ap inisyalize Firebase
  WidgetsFlutterBinding.ensureInitialized();
  
  // 2. Inisyalize Firebase parfe anvan aplikasyon an demare
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Nou mete yon SÈL MultiProvider nan rasin aplikasyon an nèt
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),   // Pou koneksyon an
        ChangeNotifierProvider(create: (_) => CourseProvider()), // Pati pa w la (S2)!
        // Kòlèg yo (Membres B et C) ap ka ajoute ProgressProvider la a aprè:
        // ChangeNotifierProvider(create: (_) => ProgressProvider()),
      ],
      child: const _AppRoot(),
    );
  }
}

// Widget séparé pour pouvoir accéder à AuthProvider via context
// et construire le routeur APRÈS que MultiProvider soit monté
class _AppRoot extends StatelessWidget {
  const _AppRoot();

  @override
  @override
  Widget build(BuildContext context) {
    // Si w bezwen gade si moun nan konekte ak authProvider la, ou ka kite liy sa a
    // final authProvider = context.watch<AuthProvider>();

    return MaterialApp(
      title: 'EduConnect Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0D47A1)),
        useMaterial3: true,
      ),
      // Nou itilize wout premye paj la (Splash Screen) kòm premye wout
      initialRoute: AppRouter.splash,
      // Nou pase sistèm generateRoute nou te kreye a la
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
  }
