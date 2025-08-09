import 'package:flutter/material.dart';
import '../models/workout_set.dart';
import '../models/exercise.dart';

class SetForm extends StatefulWidget {
  final WorkoutSet set;
  final Function(WorkoutSet) onSave;
  final bool isNewSet;

  const SetForm({
    super.key,
    required this.set,
    required this.onSave,
    this.isNewSet = false,
  });

  @override
  State<SetForm> createState() => _SetFormState();
}

class _SetFormState extends State<SetForm> {
  late Exercise _selectedExercise;
  late double _weight;
  late int _repetitions;

  @override
  void initState() {
    super.initState();
    _selectedExercise = widget.set.exercise;
    _weight = widget.set.weight;
    _repetitions = widget.set.repetitions;
  }

  void _save() {
    if (_weight <= 0 || _repetitions <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter valid weight and repetitions'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final updatedSet = widget.set.copyWith(
      exercise: _selectedExercise,
      weight: _weight,
      repetitions: _repetitions,
    );

    widget.onSave(updatedSet);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.isNewSet ? 'Add Set' : 'Edit Set',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Exercise Selection
          DropdownButtonFormField<Exercise>(
            value: _selectedExercise,
            decoration: const InputDecoration(
              labelText: 'Exercise',
              border: OutlineInputBorder(),
            ),
            items: Exercise.values.map((exercise) {
              return DropdownMenuItem(
                value: exercise,
                child: Text(exercise.displayName),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedExercise = value;
                });
              }
            },
          ),
          
          const SizedBox(height: 16),
          
          // Weight Input
          TextFormField(
            initialValue: _weight.toString(),
            decoration: const InputDecoration(
              labelText: 'Weight (kg)',
              border: OutlineInputBorder(),
              suffixText: 'kg',
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                _weight = double.tryParse(value) ?? 0.0;
              });
            },
          ),
          
          const SizedBox(height: 16),
          
          // Repetitions Input
          TextFormField(
            initialValue: _repetitions.toString(),
            decoration: const InputDecoration(
              labelText: 'Repetitions',
              border: OutlineInputBorder(),
              suffixText: 'reps',
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                _repetitions = int.tryParse(value) ?? 0;
              });
            },
          ),
          
          const SizedBox(height: 24),
          
          // Save Button
          ElevatedButton(
            onPressed: _save,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: Text(
              widget.isNewSet ? 'Add Set' : 'Save Set',
              style: const TextStyle(fontSize: 16),
            ),
          ),
          
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
