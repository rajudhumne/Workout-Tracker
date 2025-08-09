# Workout Tracker

A Flutter application for tracking workout sessions with multiple sets and exercises.

## Features

### Workout List Screen
- View all recorded workouts
- Delete workouts with confirmation dialog
- Tap on any workout to edit it
- Empty state with helpful guidance

### Workout Screen
- Add multiple sets to a workout
- Edit existing sets with exercise selection, weight, and repetitions
- Delete individual sets
- Real-time updates and persistence

### Available Exercises
- Barbell Row
- Bench Press
- Shoulder Press
- Deadlift
- Squat

## Project Structure

```
lib/
├── models/
│   ├── exercise.dart          # Exercise enum
│   ├── workout_set.dart       # Individual set model
│   └── workout.dart          # Complete workout model
├── providers/
│   └── workout_provider.dart  # State management
├── screens/
│   ├── workout_list_screen.dart  # Main list screen
│   └── workout_screen.dart       # Workout editing screen
├── widgets/
│   └── set_form.dart         # Set editing form
└── main.dart                 # App entry point

test/
├── models_test.dart          # Unit tests for models
└── widget_test.dart          # Widget tests

integration_test/
└── app_test.dart            # Integration tests
```

## Setup

1. Ensure Flutter is installed on your system
2. Clone or download the project
3. Run `flutter pub get` to install dependencies
4. Run `flutter run` to start the application

## Dependencies

- `flutter`: Core Flutter framework
- `provider`: State management
- `shared_preferences`: Local data persistence
- `uuid`: Unique ID generation

## Testing

The application includes comprehensive testing at multiple levels:

### Unit Tests
Run with: `flutter test test/models_test.dart`

Tests cover:
- Exercise enum functionality
- WorkoutSet creation, serialization, and updates
- Workout management operations

### Widget Tests
Run with: `flutter test test/widget_test.dart`

Tests cover:
- App initialization
- Workout list screen rendering
- Empty state display
- Workout tile interactions

### Integration Tests
Run with: `flutter test integration_test/app_test.dart`

Tests cover:
- Complete workout creation workflow
- Form validation
- Multiple sets with different exercises
- Navigation between screens

## Usage Example

1. **Create a Workout**: Tap the + button on the main screen
2. **Add Sets**: Tap "Add Set" to add exercises to your workout
3. **Edit Sets**: Tap the edit icon on any set to modify exercise, weight, or repetitions
4. **Delete Sets**: Tap the delete icon to remove individual sets
5. **Save Workout**: Changes are automatically saved
6. **Delete Workout**: Use the delete button on the workout list to remove entire workouts

## Data Persistence

Workouts are automatically saved to local storage using SharedPreferences. Data persists between app sessions and device restarts.

## Example Workout

A typical workout might look like:
- Set 1: Bench Press - 40kg, 10 repetitions
- Set 2: Bench Press - 45kg, 8 repetitions
- Set 3: Bench Press - 50kg, 8 repetitions
- Set 4: Deadlift - 70kg, 8 repetitions
- Set 5: Deadlift - 75kg, 6 repetitions

## Architecture

The app follows a clean architecture pattern with:
- **Models**: Data structures and business logic
- **Providers**: State management using Provider pattern
- **Screens**: UI components for different app views
- **Widgets**: Reusable UI components

The app uses Provider for state management and SharedPreferences for data persistence, ensuring a simple yet effective architecture for the workout tracking functionality.
