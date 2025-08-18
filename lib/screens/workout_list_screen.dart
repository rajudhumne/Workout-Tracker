import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/semantics.dart';
import 'package:provider/provider.dart';
import '../providers/workout_provider.dart';
import '../models/workout.dart';
import '../theme/app_theme.dart';
import 'workout_screen.dart';

class WorkoutListScreen extends StatelessWidget {
  const WorkoutListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Semantics(
          label: 'Workout Tracker - Main screen',
          header: true,
          child: const Text('Workout Tracker'),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        // Accessibility for app bar
        automaticallyImplyLeading: false,
      ),
      body: Consumer<WorkoutProvider>(
        builder: (context, workoutProvider, child) {
          final workouts = workoutProvider.workouts;
          
          if (workouts.isEmpty) {
            return Semantics(
              label: 'No workouts available. Tap the add button to create your first workout.',
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryBlue,
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryBlue.withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.fitness_center,
                        size: 50,
                        color: Colors.white,
                        semanticLabel: 'Fitness center icon',
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'No workouts yet',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppTheme.primaryBlue.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        'Tap the + button to start your first workout',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppTheme.primaryBlue,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return Semantics(
            label: 'Workout list with ${workouts.length} workouts',
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: workouts.length,
              itemBuilder: (context, index) {
                final workout = workouts[index];
                return WorkoutListTile(workout: workout);
              },
            ),
          );
        },
      ),
      floatingActionButton: Semantics(
        label: 'Create new workout',
        button: true,
        enabled: true,
        child: FloatingActionButton(
          onPressed: () {
            final workoutProvider = Provider.of<WorkoutProvider>(
              context,
              listen: false,
            );
            final newWorkout = workoutProvider.createWorkout();
            
            // Announce to screen reader
            SemanticsService.announce(
              'Creating new workout',
              TextDirection.ltr,
            );
            
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WorkoutScreen(workout: newWorkout),
              ),
            );
          },
          backgroundColor: AppTheme.primaryBlue,
          elevation: 4,
          child: const Icon(Icons.add, semanticLabel: 'Add workout', size: 28),
        ),
      ),
    );
  }
}

class WorkoutListTile extends StatelessWidget {
  final Workout workout;

  const WorkoutListTile({
    super.key,
    required this.workout,
  });

  @override
  Widget build(BuildContext context) {
    final workoutDate = '${workout.date.day}/${workout.date.month}/${workout.date.year}';
    final setCount = workout.sets.length;
    final setText = setCount == 1 ? 'set' : 'sets';
    
    return Semantics(
      label: 'Workout from $workoutDate with $setCount $setText. Double tap to view details.',
      button: true,
      enabled: true,
      child: InkWell(
        onTap: () {
          // Announce to screen reader
          SemanticsService.announce(
            'Opening workout from $workoutDate',
            TextDirection.ltr,
          );
          
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WorkoutScreen(workout: workout),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryBlue.withOpacity(0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(
                Icons.fitness_center,
                color: Colors.white,
                size: 24,
                semanticLabel: 'Fitness center icon',
              ),
            ),
            title: Text(
              'Workout $setCount $setText',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            subtitle: Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.primaryGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.primaryGreen.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Text(
                workoutDate,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.primaryGreen,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppTheme.primaryBlue.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    '$setCount $setText',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.primaryBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Semantics(
                  label: 'Delete workout',
                  button: true,
                  enabled: true,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.primaryRed.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppTheme.primaryRed.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: AppTheme.primaryRed,
                        size: 20,
                        semanticLabel: 'Delete',
                      ),
                      onPressed: () => _showDeleteDialog(context),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Semantics(
          label: 'Delete workout confirmation dialog',
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Semantics(
              label: 'Delete Workout',
              header: true,
              child: Text(
                'Delete Workout',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            content: Semantics(
              label: 'Are you sure you want to delete this workout? This action cannot be undone.',
              child: Text(
                'Are you sure you want to delete this workout? This action cannot be undone.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
            actions: [
              Semantics(
                label: 'Cancel delete workout',
                button: true,
                enabled: true,
                child: TextButton(
                  onPressed: () {
                    // Announce to screen reader
                    SemanticsService.announce(
                      'Delete cancelled',
                      TextDirection.ltr,
                    );
                    Navigator.of(context).pop();
                  },
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
                label: 'Confirm delete workout',
                button: true,
                enabled: true,
                child: ElevatedButton(
                  onPressed: () {
                    final workoutProvider = Provider.of<WorkoutProvider>(
                      context,
                      listen: false,
                    );
                    workoutProvider.deleteWorkout(workout.id);
                    Navigator.of(context).pop();
                    
                    // Provide feedback to screen reader
                    SemanticsService.announce(
                      'Workout deleted successfully',
                      TextDirection.ltr,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryRed,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Delete',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
