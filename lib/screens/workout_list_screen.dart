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
        title: const Text('Workout Tracker'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        // Accessibility for app bar
        automaticallyImplyLeading: false,
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
        child: Consumer<WorkoutProvider>(
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
                        'No workouts yet',
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
                          'Tap the + button to start your first workout',
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
      ),
      floatingActionButton: Semantics(
        label: 'Add new workout',
        button: true,
        child: Container(
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryOrange.withOpacity(0.4),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: FloatingActionButton(
            onPressed: () {
              final workoutProvider = Provider.of<WorkoutProvider>(
                context,
                listen: false,
              );
              final newWorkout = workoutProvider.createWorkout();
              
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WorkoutScreen(workout: newWorkout),
                ),
              );
            },
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: const Icon(Icons.add, semanticLabel: 'Add workout', size: 28),
          ),
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
            label: 'Workout icon',
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: AppTheme.secondaryGradient,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryBlue.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.fitness_center,
                color: Colors.white,
                size: 28,
              ),
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
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.primaryPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.primaryPurple.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Semantics(
                  label: '$setCount $setText',
                  child: Text(
                    '$setCount $setText',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.primaryPurple,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Semantics(
                label: 'Delete workout',
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
                      size: 20,
                    ),
                    onPressed: () => _showDeleteDialog(context),
                  ),
                ),
              ),
            ],
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WorkoutScreen(workout: workout),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Delete Workout',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to delete this workout? This action cannot be undone.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          actions: [
            Semantics(
              label: 'Cancel delete workout',
              button: true,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
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
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppTheme.primaryRed, AppTheme.primaryRed.withOpacity(0.8)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextButton(
                  onPressed: () {
                    final workoutProvider = Provider.of<WorkoutProvider>(
                      context,
                      listen: false,
                    );
                    workoutProvider.deleteWorkout(workout.id);
                    Navigator.of(context).pop();
                    
                    // Provide feedback to screen reader
                    SemanticsService.announce(
                      'Workout deleted',
                      TextDirection.ltr,
                    );
                  },
                  child: const Text(
                    'Delete',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
