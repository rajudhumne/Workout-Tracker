import 'exercise.dart';

class WorkoutSet {
  final String id;
  Exercise exercise;
  double weight;
  int repetitions;

  WorkoutSet({
    required this.id,
    required this.exercise,
    required this.weight,
    required this.repetitions,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'exercise': exercise.name,
      'weight': weight,
      'repetitions': repetitions,
    };
  }

  factory WorkoutSet.fromJson(Map<String, dynamic> json) {
    return WorkoutSet(
      id: json['id'],
      exercise: Exercise.values.firstWhere(
        (e) => e.name == json['exercise'],
      ),
      weight: json['weight'].toDouble(),
      repetitions: json['repetitions'],
    );
  }

  WorkoutSet copyWith({
    String? id,
    Exercise? exercise,
    double? weight,
    int? repetitions,
  }) {
    return WorkoutSet(
      id: id ?? this.id,
      exercise: exercise ?? this.exercise,
      weight: weight ?? this.weight,
      repetitions: repetitions ?? this.repetitions,
    );
  }
}
