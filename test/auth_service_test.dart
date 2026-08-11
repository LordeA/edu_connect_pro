import 'package:edu_connect_pro/services/auth_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('dashboard routes are resolved from user roles', () {
    expect(AuthService.dashboardRouteForRole('teacher'), '/teacher-dashboard');
    expect(AuthService.dashboardRouteForRole('student'), '/student-dashboard');
    expect(AuthService.dashboardRouteForRole(null), '/login');
  });
}
