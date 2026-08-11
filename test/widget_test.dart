import 'package:flutter_test/flutter_test.dart';

import 'package:edu_connect_pro/services/course_service.dart';

void main() {
  test('buildEnrollmentId creates a stable Firestore document key', () {
    final service = CourseService();

    expect(
      service.buildEnrollmentId(userId: 'user123', courseId: 'course456'),
      'user123_course456',
    );
  });
}
