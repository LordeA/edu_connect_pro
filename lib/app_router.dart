import 'package:flutter/material.dart';
import 'screens/auth/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/dashboard/teacher_dashboard.dart';
import 'screens/dashboard/student_dashboard.dart';
import 'screens/student/badges_screen.dart';
import 'screens/teacher/add_course_screen.dart';
import 'screens/teacher/course_management_screen.dart';

class AppRouter {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String teacherDashboard = '/teacher-dashboard';
  static const String studentDashboard = '/student-dashboard';
  static const String progression = '/progression';
  static const String addCourse = '/teacher/add-course';
  static const String courseManagement = '/teacher/courses';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case teacherDashboard:
        return MaterialPageRoute(builder: (_) => const TeacherDashboard());
      case studentDashboard:
        return MaterialPageRoute(builder: (_) =>const StudentDashboard(userId: 'ID_ELÈV_LA', // Ranplase ak ID itilizatè aktyèl la si sa nesesè
        ));
      case progression:
        return MaterialPageRoute(builder: (_) => const BadgesScreen());
      case addCourse:
        return MaterialPageRoute(builder: (_) => const AddCourseScreen());
      case courseManagement:
        return MaterialPageRoute(builder: (_) => const CourseManagementScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Route non trouvée : ${settings.name}')),
          ),
        );
    }
  }
}