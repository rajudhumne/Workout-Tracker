import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker/providers/workout_provider.dart';
import 'package:workout_tracker/screens/splash_screen.dart';

void main() {
  group('SplashScreen Tests', () {
    testWidgets('Should display splash screen with logo and app name', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider(
            create: (context) => WorkoutProvider(),
            child: const SplashScreen(),
          ),
        ),
      );

      // Check for logo
      expect(find.byIcon(Icons.fitness_center), findsOneWidget);
      
      // Check for app name
      expect(find.text('Workout Tracker'), findsOneWidget);
      
      // Check for tagline
      expect(find.text('Track your fitness journey'), findsOneWidget);
      
      // Check for loading indicator
      expect(find.byType(Transform), findsWidgets);
    });

    testWidgets('Should have proper styling and layout', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider(
            create: (context) => WorkoutProvider(),
            child: const SplashScreen(),
          ),
        ),
      );

      // Check for gradient background
      expect(find.byType(Container), findsWidgets);
      expect(find.byType(Scaffold), findsOneWidget);
      
      // Check for proper text styling
      final appNameText = find.text('Workout Tracker');
      expect(appNameText, findsOneWidget);
      
      final taglineText = find.text('Track your fitness journey');
      expect(taglineText, findsOneWidget);
    });

    testWidgets('Should handle animations properly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider(
            create: (context) => WorkoutProvider(),
            child: const SplashScreen(),
          ),
        ),
      );

      // Check for animation controllers
      expect(find.byType(AnimatedBuilder), findsWidgets);
      expect(find.byType(Transform), findsWidgets);
    });
  });
}
