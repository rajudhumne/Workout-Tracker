import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:workout_tracker/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Workout Tracker Integration Tests', () {
    testWidgets('Complete workout creation and editing workflow', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Verify we start on the workout list screen
      expect(find.text('Workout Tracker'), findsOneWidget);
      expect(find.text('No workouts yet'), findsOneWidget);

      // Create a new workout
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Verify we're on the workout screen
      expect(find.text('Add Set'), findsOneWidget);
      expect(find.text('No sets added yet'), findsOneWidget);

      // Add first set
      await tester.tap(find.text('Add Set'));
      await tester.pumpAndSettle();

      // Verify set was added and we can edit it
      expect(find.text('Bench Press'), findsOneWidget);
      expect(find.text('0kg × 0 reps'), findsOneWidget);

      // Edit the first set
      await tester.tap(find.byIcon(Icons.edit).first);
      await tester.pumpAndSettle();

      // Verify edit form is shown
      expect(find.text('Edit Set'), findsOneWidget);
      expect(find.text('Exercise'), findsOneWidget);
      expect(find.text('Weight (kg)'), findsOneWidget);
      expect(find.text('Repetitions'), findsOneWidget);

      // Change exercise to Deadlift
      await tester.tap(find.text('Bench Press'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Deadlift'));
      await tester.pumpAndSettle();

      // Enter weight
      await tester.tap(find.byType(TextFormField).at(1));
      await tester.enterText(find.byType(TextFormField).at(1), '75');
      await tester.pumpAndSettle();

      // Enter repetitions
      await tester.tap(find.byType(TextFormField).at(2));
      await tester.enterText(find.byType(TextFormField).at(2), '8');
      await tester.pumpAndSettle();

      // Save the set
      await tester.tap(find.text('Save Set'));
      await tester.pumpAndSettle();

      // Verify the set was updated
      expect(find.text('Deadlift'), findsOneWidget);
      expect(find.text('75kg × 8 reps'), findsOneWidget);

      // Add another set
      await tester.tap(find.text('Add Set'));
      await tester.pumpAndSettle();

      // Verify we now have 2 sets
      expect(find.text('Bench Press'), findsOneWidget);
      expect(find.text('Deadlift'), findsOneWidget);

      // Go back to workout list
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Verify workout appears in list
      expect(find.text('Workout 2 sets'), findsOneWidget);
      expect(find.text('2 sets'), findsOneWidget);

      // Delete the workout
      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();

      // Confirm deletion
      expect(find.text('Delete Workout'), findsOneWidget);
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      // Verify we're back to empty state
      expect(find.text('No workouts yet'), findsOneWidget);
    });

    testWidgets('Form validation test', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Create a new workout
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Add a set
      await tester.tap(find.text('Add Set'));
      await tester.pumpAndSettle();

      // Edit the set
      await tester.tap(find.byIcon(Icons.edit).first);
      await tester.pumpAndSettle();

      // Try to save with invalid values (0 weight and reps)
      await tester.tap(find.text('Save Set'));
      await tester.pumpAndSettle();

      // Verify error message is shown
      expect(find.text('Please enter valid weight and repetitions'), findsOneWidget);

      // Enter valid values
      await tester.tap(find.byType(TextFormField).at(1));
      await tester.enterText(find.byType(TextFormField).at(1), '50');
      await tester.pumpAndSettle();

      await tester.tap(find.byType(TextFormField).at(2));
      await tester.enterText(find.byType(TextFormField).at(2), '10');
      await tester.pumpAndSettle();

      // Save with valid values
      await tester.tap(find.text('Save Set'));
      await tester.pumpAndSettle();

      // Verify set was saved successfully
      expect(find.text('50kg × 10 reps'), findsOneWidget);
    });

    testWidgets('Multiple sets with different exercises', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Create a new workout
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Add multiple sets with different exercises
      for (int i = 0; i < 3; i++) {
        await tester.tap(find.text('Add Set'));
        await tester.pumpAndSettle();
      }

      // Verify we have 3 sets
      expect(find.text('Bench Press'), findsNWidgets(3));

      // Edit each set to have different exercises
      final exercises = ['Bench Press', 'Deadlift', 'Squat'];
      for (int i = 0; i < 3; i++) {
        await tester.tap(find.byIcon(Icons.edit).at(i));
        await tester.pumpAndSettle();

        // Change exercise
        await tester.tap(find.text('Bench Press'));
        await tester.pumpAndSettle();
        await tester.tap(find.text(exercises[i]));
        await tester.pumpAndSettle();

        // Enter weight and reps
        await tester.tap(find.byType(TextFormField).at(1));
        await tester.enterText(find.byType(TextFormField).at(1), '${50 + i * 5}');
        await tester.pumpAndSettle();

        await tester.tap(find.byType(TextFormField).at(2));
        await tester.enterText(find.byType(TextFormField).at(2), '${10 - i}');
        await tester.pumpAndSettle();

        await tester.tap(find.text('Save Set'));
        await tester.pumpAndSettle();
      }

      // Verify all exercises are different
      expect(find.text('Bench Press'), findsOneWidget);
      expect(find.text('Deadlift'), findsOneWidget);
      expect(find.text('Squat'), findsOneWidget);

      // Go back to workout list
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Verify workout shows correct number of sets
      expect(find.text('Workout 3 sets'), findsOneWidget);
    });
  });
}
