import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/workout.dart';
import '../models/workout_set.dart';
import '../models/exercise.dart';

class WorkoutProvider with ChangeNotifier {
  List<Workout> _workouts = [];
  final Uuid _uuid = const Uuid();
  static const String _storageKey = 'workouts';

  List<Workout> get workouts => List.unmodifiable(_workouts);

  WorkoutProvider() {
    _loadWorkouts();
  }

  Future<void> _loadWorkouts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final workoutsJson = prefs.getStringList(_storageKey) ?? [];
      
      _workouts = workoutsJson
          .map((json) => Workout.fromJson(jsonDecode(json)))
          .toList();
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading workouts: $e');
    }
  }

  Future<void> _saveWorkouts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final workoutsJson = _workouts
          .map((workout) => jsonEncode(workout.toJson()))
          .toList();
      
      await prefs.setStringList(_storageKey, workoutsJson);
    } catch (e) {
      debugPrint('Error saving workouts: $e');
    }
  }

  Workout createWorkout() {
    final workout = Workout(
      id: _uuid.v4(),
      date: DateTime.now(),
      sets: [],
    );
    
    _workouts.add(workout);
    _saveWorkouts();
    notifyListeners();
    return workout;
  }

  void updateWorkout(Workout workout) {
    final index = _workouts.indexWhere((w) => w.id == workout.id);
    if (index != -1) {
      _workouts[index] = workout;
      _saveWorkouts();
      notifyListeners();
    }
  }

  void deleteWorkout(String workoutId) {
    _workouts.removeWhere((workout) => workout.id == workoutId);
    _saveWorkouts();
    notifyListeners();
  }

  Workout? getWorkout(String workoutId) {
    try {
      return _workouts.firstWhere((workout) => workout.id == workoutId);
    } catch (e) {
      return null;
    }
  }

  WorkoutSet createSet({
    required Exercise exercise,
    required double weight,
    required int repetitions,
  }) {
    return WorkoutSet(
      id: _uuid.v4(),
      exercise: exercise,
      weight: weight,
      repetitions: repetitions,
    );
  }
}
