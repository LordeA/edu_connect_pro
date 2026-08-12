// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:edu_connect_pro/screens/courses/course_quiz_screen.dart';

void main() {
  testWidgets('Marketing Digital quiz uses marketing-related questions', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: CourseQuizScreen(courseId: 'test_course_id', courseTitle: 'Marketing Digital'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('marketing', findRichText: true), findsWidgets);
    expect(find.text('Quelle est la fonction principale de Flutter?'), findsNothing);
  });
}
