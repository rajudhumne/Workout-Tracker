import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/workout_provider.dart';
import '../models/workout.dart';
import '../models/workout_set.dart';
import '../models/exercise.dart';
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
          title: const Text('Select Exercise'),
          content: DropdownButtonFormField<Exercise>(
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
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (selectedExercise != null) {
                  Navigator.pop(context);
                  _showSetForm(selectedExercise!);
                }
              },
              child: const Text('Select'),
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
      builder: (context) => SetForm(
        set: newSet,
        isNewSet: true,
        onSave: (updatedSet) {
          setState(() {
            _workout.addSet(updatedSet);
          });
          _saveWorkout();
        },
      ),
    );
  }

  void _editSet(WorkoutSet set) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => SetForm(
        set: set,
        onSave: (updatedSet) {
          setState(() {
            _workout.updateSet(updatedSet);
          });
          _saveWorkout();
        },
      ),
    );
  }

  void _deleteSet(String setId) {
    setState(() {
      _workout.removeSet(setId);
    });
    _saveWorkout();
  }

  void _saveWorkout() {
    final workoutProvider = Provider.of<WorkoutProvider>(
      context,
      listen: false,
    );
    workoutProvider.updateWorkout(_workout);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout - ${_workout.date.day}/${_workout.date.month}/${_workout.date.year}'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveWorkout,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _workout.sets.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.fitness_center,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No sets added yet',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Tap the + button to add your first set',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _addSet,
                icon: const Icon(Icons.add),
                label: const Text('Add Set'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ),
        ],
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
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: Text(
            setNumber.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          set.exercise.displayName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('${set.weight}kg × ${set.repetitions} reps'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
