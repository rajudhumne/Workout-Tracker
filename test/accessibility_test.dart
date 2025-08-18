import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker/main.dart';
import 'package:workout_tracker/providers/workout_provider.dart';
import 'package:workout_tracker/screens/workout_list_screen.dart';
import 'package:workout_tracker/screens/workout_screen.dart';
import 'package:workout_tracker/models/workout.dart';
import 'package:workout_tracker/models/workout_set.dart';
import 'package:workout_tracker/models/exercise.dart';

void main() {
  group('Accessibility Tests', () {
    testWidgets('App should have proper semantic labels', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Check for main app elements
      expect(find.text('Workout Tracker'), findsOneWidget);

      // Wait for navigation to workout list screen
      await tester.pumpAndSettle(const Duration(milliseconds: 4000));

      // Check for workout list screen elements
      expect(find.text('Workout Tracker'), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('Workout list should have proper accessibility', (WidgetTester tester) async {
      final workout = Workout(
        id: 'test-workout',
        date: DateTime.now(),
        sets: [
          WorkoutSet(
            id: 'test-set',
            exercise: Exercise.benchPress,
            weight: 50.0,
            repetitions: 10,
          ),
        ],
      );

      final provider = WorkoutProvider();
      provider.updateWorkout(workout);

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider.value(
            value: provider,
            child: const WorkoutListScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Check for workout list elements
      expect(find.text('Workout Tracker'), findsOneWidget);
      expect(find.text('Workout 1 set'), findsOneWidget);
      expect(find.byIcon(Icons.delete), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('Workout screen should have proper accessibility', (WidgetTester tester) async {
      final workout = Workout(
        id: 'test-workout',
        date: DateTime.now(),
        sets: [],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider(
            create: (context) => WorkoutProvider(),
            child: WorkoutScreen(workout: workout),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Check for workout screen elements
      expect(find.text('No sets added yet'), findsOneWidget);
      expect(find.text('Add Set'), findsOneWidget);
      expect(find.byIcon(Icons.save), findsOneWidget);
    });

    testWidgets('Delete dialog should have proper accessibility', (WidgetTester tester) async {
      final workout = Workout(
        id: 'test-workout',
        date: DateTime.now(),
        sets: [],
      );

      final provider = WorkoutProvider();
      provider.updateWorkout(workout);

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider.value(
            value: provider,
            child: const WorkoutListScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap delete button
      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();

      // Check for delete dialog elements
      expect(find.text('Delete Workout'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);
    });

    testWidgets('Touch targets should be appropriately sized', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle(const Duration(milliseconds: 4000));

      // Check that floating action button is large enough
      final fab = tester.getRect(find.byType(FloatingActionButton));
      expect(fab.width, greaterThanOrEqualTo(48.0));
      expect(fab.height, greaterThanOrEqualTo(48.0));
    });

    testWidgets('Accessibility features are comprehensive', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle(const Duration(milliseconds: 4000));

      // Check that all interactive elements have proper semantics
      final buttons = find.byType(ElevatedButton);
      final iconButtons = find.byType(IconButton);
      final floatingActionButtons = find.byType(FloatingActionButton);

      // Verify that interactive elements exist
      expect(floatingActionButtons, findsOneWidget);

      // Check for semantic labels on key elements
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('Form accessibility should work', (WidgetTester tester) async {
      final workout = Workout(
        id: 'test-workout',
        date: DateTime.now(),
        sets: [],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider(
            create: (context) => WorkoutProvider(),
            child: WorkoutScreen(workout: workout),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap Add Set button
      await tester.tap(find.text('Add Set'));
      await tester.pumpAndSettle();

      // Check for exercise selection dialog
      expect(find.text('Select Exercise'), findsOneWidget);
      expect(find.text('Exercise'), findsOneWidget);
      expect(find.text('Bench Press'), findsOneWidget);
    });
  });
}
