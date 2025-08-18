import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/semantics.dart';
import '../models/workout_set.dart';
import '../models/exercise.dart';
import '../theme/app_theme.dart';

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
        SnackBar(
          content: const Text('Please enter valid weight and repetitions'),
          backgroundColor: AppTheme.primaryRed,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      
      // Provide feedback to screen reader
      SemanticsService.announce(
        'Please enter valid weight and repetitions',
        TextDirection.ltr,
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
    final formTitle = widget.isNewSet ? 'Add Set' : 'Edit Set';
    final buttonText = widget.isNewSet ? 'Add Set' : 'Save Set';
    
    return Semantics(
      label: '$formTitle form',
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 24,
          right: 24,
          top: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header with gradient
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryBlue.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Semantics(
                    label: formTitle,
                    header: true,
                    child: Text(
                      formTitle,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Semantics(
                    label: 'Close form',
                    button: true,
                    child: IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                        semanticLabel: 'Close',
                      ),
                      onPressed: () {
                        // Announce to screen reader
                        SemanticsService.announce(
                          'Form closed',
                          TextDirection.ltr,
                        );
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Exercise Selection
            Semantics(
              label: 'Exercise selection dropdown',
              child: DropdownButtonFormField<Exercise>(
                value: _selectedExercise,
                decoration: InputDecoration(
                  labelText: 'Exercise',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  helperText: 'Select the exercise for this set',
                  prefixIcon: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBlue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.fitness_center,
                      color: Colors.white,
                      size: 20,
                      semanticLabel: 'Exercise icon',
                    ),
                  ),
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
                    
                    // Provide feedback to screen reader
                    SemanticsService.announce(
                      'Selected ${value.displayName}',
                      TextDirection.ltr,
                    );
                  }
                },
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Weight Input
            Semantics(
              label: 'Weight input field in kilograms',
              child: TextFormField(
                initialValue: _weight.toString(),
                decoration: InputDecoration(
                  labelText: 'Weight (kg)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  suffixText: 'kg',
                  helperText: 'Enter the weight used for this set',
                  prefixIcon: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryGreen,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.monitor_weight,
                      color: Colors.white,
                      size: 20,
                      semanticLabel: 'Weight icon',
                    ),
                  ),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _weight = double.tryParse(value) ?? 0.0;
                  });
                },
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Repetitions Input
            Semantics(
              label: 'Repetitions input field',
              child: TextFormField(
                initialValue: _repetitions.toString(),
                decoration: InputDecoration(
                  labelText: 'Repetitions',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  suffixText: 'reps',
                  helperText: 'Enter the number of repetitions performed',
                  prefixIcon: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryOrange,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.repeat,
                      color: Colors.white,
                      size: 20,
                      semanticLabel: 'Repetitions icon',
                    ),
                  ),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _repetitions = int.tryParse(value) ?? 0;
                  });
                },
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Save Button
            Semantics(
              label: buttonText,
              button: true,
              enabled: true,
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.primaryGreen,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryGreen.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    buttonText,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
