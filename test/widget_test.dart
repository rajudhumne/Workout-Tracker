import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker/main.dart';
import 'package:workout_tracker/providers/workout_provider.dart';
import 'package:workout_tracker/screens/workout_list_screen.dart';
import 'package:workout_tracker/models/workout.dart';
import 'package:workout_tracker/models/workout_set.dart';
import 'package:workout_tracker/models/exercise.dart';

void main() {
  group('App Widget Tests', () {
    testWidgets('App should render without crashing', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('App should show WorkoutListScreen as home', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      expect(find.byType(WorkoutListScreen), findsOneWidget);
    });
  });

  group('WorkoutListScreen Widget Tests', () {
    testWidgets('Should show empty state when no workouts', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider(
            create: (context) => WorkoutProvider(),
            child: const WorkoutListScreen(),
          ),
        ),
      );

      expect(find.text('No workouts yet'), findsOneWidget);
      expect(find.text('Tap the + button to start your first workout'), findsOneWidget);
      expect(find.byIcon(Icons.fitness_center), findsOneWidget);
    });

    testWidgets('Should show workout list when workouts exist', (WidgetTester tester) async {
      final provider = WorkoutProvider();
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

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider.value(
            value: provider,
            child: const WorkoutListScreen(),
          ),
        ),
      );

      // Add workout to provider
      provider.updateWorkout(workout);
      await tester.pump();

      expect(find.text('Workout 1 sets'), findsOneWidget);
      expect(find.text('1 sets'), findsOneWidget);
    });

    testWidgets('Should show floating action button', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider(
            create: (context) => WorkoutProvider(),
            child: const WorkoutListScreen(),
          ),
        ),
      );

      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('Should show app bar with correct title', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider(
            create: (context) => WorkoutProvider(),
            child: const WorkoutListScreen(),
          ),
        ),
      );

      expect(find.text('Workout Tracker'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });
  });

  group('WorkoutListTile Widget Tests', () {
    testWidgets('Should display workout information correctly', (WidgetTester tester) async {
      final workout = Workout(
        id: 'test-workout',
        date: DateTime(2024, 1, 15),
        sets: [
          WorkoutSet(
            id: 'set-1',
            exercise: Exercise.benchPress,
            weight: 50.0,
            repetitions: 10,
          ),
          WorkoutSet(
            id: 'set-2',
            exercise: Exercise.deadlift,
            weight: 75.0,
            repetitions: 8,
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WorkoutListTile(workout: workout),
          ),
        ),
      );

      expect(find.text('Workout 2 sets'), findsOneWidget);
      expect(find.text('15/1/2024'), findsOneWidget);
      expect(find.text('2 sets'), findsOneWidget);
      expect(find.byIcon(Icons.delete), findsOneWidget);
    });

    testWidgets('Should show delete dialog when delete button is pressed', (WidgetTester tester) async {
      final workout = Workout(
        id: 'test-workout',
        date: DateTime.now(),
        sets: [],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WorkoutListTile(workout: workout),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();

      expect(find.text('Delete Workout'), findsOneWidget);
      expect(find.text('Are you sure you want to delete this workout? This action cannot be undone.'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);
    });
  });

  group('Add Set Dropdown Tests', () {
    testWidgets('Should show exercise selection dialog when add set is pressed', (WidgetTester tester) async {
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

      // Find and tap the Add Set button
      await tester.tap(find.text('Add Set'));
      await tester.pumpAndSettle();

      // Verify the exercise selection dialog appears
      expect(find.text('Select Exercise'), findsOneWidget);
      expect(find.text('Exercise'), findsOneWidget);
      expect(find.text('Bench Press'), findsOneWidget);
      expect(find.text('Barbell Row'), findsOneWidget);
      expect(find.text('Shoulder Press'), findsOneWidget);
      expect(find.text('Deadlift'), findsOneWidget);
      expect(find.text('Squat'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Select'), findsOneWidget);
    });
  });
}
