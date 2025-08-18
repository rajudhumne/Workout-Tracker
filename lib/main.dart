import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/semantics.dart';
import 'package:provider/provider.dart';
import 'providers/workout_provider.dart';
import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WorkoutProvider(),
      child: MaterialApp(
        title: 'Workout Tracker',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        home: const SplashScreen(),
        debugShowCheckedModeBanner: false,
        // Enhanced accessibility features
        showSemanticsDebugger: false, // Set to true for debugging accessibility
        // Enable screen reader support
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              // Support for larger text sizes
              textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(0.8, 3.0),
            ),
            child: child!,
          );
        },
      ),
    );
  }
}
