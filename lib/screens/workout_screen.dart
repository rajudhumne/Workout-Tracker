import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/semantics.dart';
import 'package:provider/provider.dart';
import '../providers/workout_provider.dart';
import '../models/workout.dart';
import '../models/workout_set.dart';
import '../models/exercise.dart';
import '../theme/app_theme.dart';
import '../widgets/set_form.dart';

class WorkoutScreen extends StatefulWidget {
  final Workout workout;

  const WorkoutScreen({
    super.key,
    required this.workout,
  });

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  late Workout _workout;

  @override
  void initState() {
    super.initState();
    _workout = widget.workout;
  }

  void _addSet() {
    Exercise? selectedExercise = Exercise.benchPress;
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Select Exercise',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Semantics(
            label: 'Exercise selection dropdown',
            child: DropdownButtonFormField<Exercise>(
              value: selectedExercise,
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
                setState(() {
                  selectedExercise = value;
                });
              },
            ),
          ),
          actions: [
            Semantics(
              label: 'Cancel exercise selection',
              button: true,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Semantics(
              label: 'Confirm exercise selection',
              button: true,
              child: Container(
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    if (selectedExercise != null) {
                      Navigator.pop(context);
                      _showSetForm(selectedExercise!);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  ),
                  child: const Text(
                    'Select',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSetForm(Exercise exercise) {
    final workoutProvider = Provider.of<WorkoutProvider>(
      context,
      listen: false,
    );
    
    final newSet = workoutProvider.createSet(
      exercise: exercise,
      weight: 0.0,
      repetitions: 0,
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SetForm(
        set: newSet,
        isNewSet: true,
        onSave: (updatedSet) {
          setState(() {
            _workout.addSet(updatedSet);
          });
          _saveWorkout();
          
          // Provide feedback to screen reader
          SemanticsService.announce(
            'Set added successfully',
            TextDirection.ltr,
          );
        },
      ),
    );
  }

  void _editSet(WorkoutSet set) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SetForm(
        set: set,
        onSave: (updatedSet) {
          setState(() {
            _workout.updateSet(updatedSet);
          });
          _saveWorkout();
          
          // Provide feedback to screen reader
          SemanticsService.announce(
            'Set updated successfully',
            TextDirection.ltr,
          );
        },
      ),
    );
  }

  void _deleteSet(String setId) {
    setState(() {
      _workout.removeSet(setId);
    });
    _saveWorkout();
    
    // Provide feedback to screen reader
    SemanticsService.announce(
      'Set deleted successfully',
      TextDirection.ltr,
    );
  }

  void _saveWorkout() {
    final workoutProvider = Provider.of<WorkoutProvider>(
      context,
      listen: false,
    );
    workoutProvider.updateWorkout(_workout);
    
    // Provide feedback to screen reader
    SemanticsService.announce(
      'Workout saved',
      TextDirection.ltr,
    );
  }

  @override
  Widget build(BuildContext context) {
    final workoutDate = '${_workout.date.day}/${_workout.date.month}/${_workout.date.year}';
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout - $workoutDate'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        actions: [
          Semantics(
            label: 'Save workout',
            button: true,
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                gradient: AppTheme.successGradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.save, semanticLabel: 'Save', color: Colors.white),
                onPressed: _saveWorkout,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.background,
              Theme.of(context).colorScheme.background.withOpacity(0.8),
            ],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: _workout.sets.isEmpty
                  ? Semantics(
                      label: 'No sets added yet. Tap the add set button to add your first set.',
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                gradient: AppTheme.secondaryGradient,
                                borderRadius: BorderRadius.circular(60),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.primaryBlue.withOpacity(0.3),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.fitness_center,
                                size: 60,
                                color: Colors.white,
                                semanticLabel: 'Fitness center icon',
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'No sets added yet',
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: AppTheme.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryOrange.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: AppTheme.primaryOrange.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                'Tap the + button to add your first set',
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: AppTheme.primaryOrange,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Semantics(
                      label: 'Workout sets list with ${_workout.sets.length} sets',
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _workout.sets.length,
                        itemBuilder: (context, index) {
                          final set = _workout.sets[index];
                          return SetCard(
                            set: set,
                            setNumber: index + 1,
                            onEdit: () => _editSet(set),
                            onDelete: () => _deleteSet(set.id),
                          );
                        },
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Semantics(
                label: 'Add new set to workout',
                button: true,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryOrange.withOpacity(0.4),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ElevatedButton.icon(
                    onPressed: _addSet,
                    icon: const Icon(Icons.add, semanticLabel: 'Add', color: Colors.white),
                    label: Text(
                      'Add Set',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SetCard extends StatelessWidget {
  final WorkoutSet set;
  final int setNumber;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const SetCard({
    super.key,
    required this.set,
    required this.setNumber,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final exerciseName = set.exercise.displayName;
    final setDetails = '${set.weight}kg × ${set.repetitions} reps';
    
    return Semantics(
      label: 'Set $setNumber: $exerciseName, $setDetails. Double tap to edit.',
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.surface,
              Theme.of(context).colorScheme.surface.withOpacity(0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: Semantics(
            label: 'Set number $setNumber',
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryOrange.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  setNumber.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
          title: Text(
            exerciseName,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          subtitle: Container(
            margin: const EdgeInsets.only(top: 4),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.primaryGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.primaryGreen.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Text(
              setDetails,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.primaryGreen,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Semantics(
                label: 'Edit set $setNumber',
                button: true,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.primaryBlue.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.edit,
                      semanticLabel: 'Edit',
                      color: AppTheme.primaryBlue,
                      size: 20,
                    ),
                    onPressed: onEdit,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Semantics(
                label: 'Delete set $setNumber',
                button: true,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.primaryRed.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.primaryRed.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: AppTheme.primaryRed,
                      semanticLabel: 'Delete',
                      size: 20,
                    ),
                    onPressed: onDelete,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
