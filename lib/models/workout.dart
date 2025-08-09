import 'workout_set.dart';

class Workout {
  final String id;
  final DateTime date;
  List<WorkoutSet> sets;

  Workout({
    required this.id,
    required this.date,
    required this.sets,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'sets': sets.map((set) => set.toJson()).toList(),
    };
  }

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      id: json['id'],
      date: DateTime.parse(json['date']),
      sets: (json['sets'] as List)
          .map((setJson) => WorkoutSet.fromJson(setJson))
          .toList(),
    );
  }

  Workout copyWith({
    String? id,
    DateTime? date,
    List<WorkoutSet>? sets,
  }) {
    return Workout(
      id: id ?? this.id,
      date: date ?? this.date,
      sets: sets ?? this.sets,
    );
  }

  void addSet(WorkoutSet set) {
    sets.add(set);
  }

  void removeSet(String setId) {
    sets.removeWhere((set) => set.id == setId);
  }

  void updateSet(WorkoutSet updatedSet) {
    final index = sets.indexWhere((set) => set.id == updatedSet.id);
    if (index != -1) {
      sets[index] = updatedSet;
    }
  }
}
