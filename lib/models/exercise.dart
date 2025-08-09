enum Exercise {
  barbellRow('Barbell Row'),
  benchPress('Bench Press'),
  shoulderPress('Shoulder Press'),
  deadlift('Deadlift'),
  squat('Squat');

  const Exercise(this.displayName);
  final String displayName;

  @override
  String toString() => displayName;
}
