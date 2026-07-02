// ============================================================
// EduConnect Pro — Configuration GoRouter avec guards
// Membre A — lib/router.dart
// ============================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';

// NOUVO ENPÒTASYON POU PAJ PWOFESÈ YO
import 'screens/teacher/teacher_dashboard_screen.dart';
import 'screens/teacher/add_course_screen.dart';

// Écran temporaire étudiant (en attendant le travail du Membre concerné)
class StudentHomeScreen extends StatelessWidget {
  const StudentHomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Espace Étudiant'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => context.read<AuthProvider>().logout(),
          ),
        ],
      ),
      body: const Center(child: Text('Bienvenue, Étudiant ✓')),
    );
  }
}

// ----------------------------------------------------------
// GÉNÉRATION DU ROUTEUR
// ----------------------------------------------------------
GoRouter createRouter(AuthProvider authProvider) {
  return GoRouter(
    initialLocation: '/login',
    refreshListenable: authProvider, // Réévalue les redirections à chaque changement d'état
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),

      // =========================================
      // NOUVO WOUT POU ESPAS ENSEIGNANT AN
      // =========================================
      GoRoute(
        path: '/teacher/dashboard', // Nou ranplase '/teacher-home' ak sa
        builder: (context, state) => const TeacherDashboardScreen(),
      ),
      GoRoute(
        path: '/teacher/add-course',
        builder: (context, state) => const AddCourseScreen(),
      ),

      // Wout etidyan an rete la
      GoRoute(
        path: '/student-home',
        builder: (context, state) => const StudentHomeScreen(),
      ),
    ],

    // ----------------------------------------------------------
    // GUARD GLOBAL — exécuté avant chaque navigation
    // ----------------------------------------------------------
    redirect: (context, state) {
      final isAuth = authProvider.isAuthenticated;
      final isLoggingIn = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';

      // Pas connecté et essaie d'accéder à une page protégée → redirection login
      if (!isAuth && !isLoggingIn) {
        return '/login';
      }

      // Connecté mais reste sur login/register → redirection vers son espace
      if (isAuth && isLoggingIn) {
        if (authProvider.isTeacher) return '/teacher/dashboard'; // Mizajou isit la
        if (authProvider.isStudent) return '/student-home';
        // Rôle pas encore chargé, on attend
        return null;
      }

      // Connecté en tant qu'étudiant qui essaie d'accéder à l'espace enseignant
      // NOUVO: startsWith pwoteje TOUT wout ki kòmanse ak /teacher (dashboard + add-course)
      if (isAuth && authProvider.isStudent && state.matchedLocation.startsWith('/teacher')) {
        return '/student-home';
      }

      // Connecté en tant qu'enseignant qui essaie d'accéder à l'espace étudiant
      if (isAuth && authProvider.isTeacher && state.matchedLocation == '/student-home') {
        return '/teacher/dashboard'; // Mizajou isit la
      }

      return null; // Pas de redirection nécessaire
    },
  );
}