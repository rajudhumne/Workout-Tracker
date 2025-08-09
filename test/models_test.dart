import 'package:flutter_test/flutter_test.dart';
import 'package:workout_tracker/models/exercise.dart';
import 'package:workout_tracker/models/workout_set.dart';
import 'package:workout_tracker/models/workout.dart';

void main() {
  group('Exercise Tests', () {
    test('Exercise enum should have correct display names', () {
      expect(Exercise.barbellRow.displayName, 'Barbell Row');
      expect(Exercise.benchPress.displayName, 'Bench Press');
      expect(Exercise.shoulderPress.displayName, 'Shoulder Press');
      expect(Exercise.deadlift.displayName, 'Deadlift');
      expect(Exercise.squat.displayName, 'Squat');
    });

    test('Exercise toString should return display name', () {
      expect(Exercise.benchPress.toString(), 'Bench Press');
      expect(Exercise.deadlift.toString(), 'Deadlift');
    });
  });

  group('WorkoutSet Tests', () {
    test('WorkoutSet should be created with correct values', () {
      final set = WorkoutSet(
        id: 'test-id',
        exercise: Exercise.benchPress,
        weight: 50.0,
        repetitions: 10,
      );

      expect(set.id, 'test-id');
      expect(set.exercise, Exercise.benchPress);
      expect(set.weight, 50.0);
      expect(set.repetitions, 10);
    });

    test('WorkoutSet toJson should return correct map', () {
      final set = WorkoutSet(
        id: 'test-id',
        exercise: Exercise.deadlift,
        weight: 75.0,
        repetitions: 8,
      );

      final json = set.toJson();
      expect(json['id'], 'test-id');
      expect(json['exercise'], 'deadlift');
      expect(json['weight'], 75.0);
      expect(json['repetitions'], 8);
    });

    test('WorkoutSet fromJson should create correct object', () {
      final json = {
        'id': 'test-id',
        'exercise': 'benchPress',
        'weight': 60.0,
        'repetitions': 12,
      };

      final set = WorkoutSet.fromJson(json);
      expect(set.id, 'test-id');
      expect(set.exercise, Exercise.benchPress);
      expect(set.weight, 60.0);
      expect(set.repetitions, 12);
    });

    test('WorkoutSet copyWith should create new instance with updated values', () {
      final original = WorkoutSet(
        id: 'test-id',
        exercise: Exercise.benchPress,
        weight: 50.0,
        repetitions: 10,
      );

      final updated = original.copyWith(
        weight: 55.0,
        repetitions: 8,
      );

      expect(updated.id, 'test-id');
      expect(updated.exercise, Exercise.benchPress);
      expect(updated.weight, 55.0);
      expect(updated.repetitions, 8);
    });
  });

  group('Workout Tests', () {
    test('Workout should be created with correct values', () {
      final date = DateTime(2024, 1, 1);
      final workout = Workout(
        id: 'workout-id',
        date: date,
        sets: [],
      );

      expect(workout.id, 'workout-id');
      expect(workout.date, date);
      expect(workout.sets, isEmpty);
    });

    test('Workout addSet should add set to workout', () {
      final workout = Workout(
        id: 'workout-id',
        date: DateTime.now(),
        sets: [],
      );

      final set = WorkoutSet(
        id: 'set-id',
        exercise: Exercise.benchPress,
        weight: 50.0,
        repetitions: 10,
      );

      workout.addSet(set);
      expect(workout.sets.length, 1);
      expect(workout.sets.first, set);
    });

    test('Workout removeSet should remove set from workout', () {
      final set = WorkoutSet(
        id: 'set-id',
        exercise: Exercise.benchPress,
        weight: 50.0,
        repetitions: 10,
      );

      final workout = Workout(
        id: 'workout-id',
        date: DateTime.now(),
        sets: [set],
      );

      workout.removeSet('set-id');
      expect(workout.sets, isEmpty);
    });

    test('Workout updateSet should update existing set', () {
      final originalSet = WorkoutSet(
        id: 'set-id',
        exercise: Exercise.benchPress,
        weight: 50.0,
        repetitions: 10,
      );

      final workout = Workout(
        id: 'workout-id',
        date: DateTime.now(),
        sets: [originalSet],
      );

      final updatedSet = originalSet.copyWith(weight: 55.0, repetitions: 8);
      workout.updateSet(updatedSet);

      expect(workout.sets.length, 1);
      expect(workout.sets.first.weight, 55.0);
      expect(workout.sets.first.repetitions, 8);
    });

    test('Workout toJson should return correct map', () {
      final date = DateTime(2024, 1, 1);
      final set = WorkoutSet(
        id: 'set-id',
        exercise: Exercise.benchPress,
        weight: 50.0,
        repetitions: 10,
      );

      final workout = Workout(
        id: 'workout-id',
        date: date,
        sets: [set],
      );

      final json = workout.toJson();
      expect(json['id'], 'workout-id');
      expect(json['date'], date.toIso8601String());
      expect(json['sets'], isA<List>());
      expect(json['sets'].length, 1);
    });

    test('Workout fromJson should create correct object', () {
      final date = DateTime(2024, 1, 1);
      final json = {
        'id': 'workout-id',
        'date': date.toIso8601String(),
        'sets': [
          {
            'id': 'set-id',
            'exercise': 'benchPress',
            'weight': 50.0,
            'repetitions': 10,
          }
        ],
      };

      final workout = Workout.fromJson(json);
      expect(workout.id, 'workout-id');
      expect(workout.date, date);
      expect(workout.sets.length, 1);
      expect(workout.sets.first.exercise, Exercise.benchPress);
    });
  });
}
