import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/semantics.dart';
import '../theme/app_theme.dart';
import 'workout_list_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoOpacityAnimation;
  late Animation<double> _textSlideAnimation;
  late Animation<double> _textOpacityAnimation;

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controllers
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    // Logo animations
    _logoScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));
    
    _logoOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeIn,
    ));

    // Text animations
    _textSlideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeOut,
    ));
    
    _textOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeIn,
    ));

    // Start animations
    _logoController.forward();
    
    // Start text animation after logo starts
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _textController.forward();
      }
    });

    // Navigate to main screen after delay
    Future.delayed(const Duration(milliseconds: 3000), () {
      if (mounted) {
        // Announce navigation to screen reader
        SemanticsService.announce(
          'Navigating to workout list',
          TextDirection.ltr,
        );
        
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const WorkoutListScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBlue,
      body: Semantics(
        label: 'Splash screen. Workout Tracker app is loading.',
        child: SafeArea(
          child: Column(
            children: [
              // Logo section
              Expanded(
                flex: 3,
                child: Center(
                  child: AnimatedBuilder(
                    animation: _logoController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _logoScaleAnimation.value,
                        child: Opacity(
                          opacity: _logoOpacityAnimation.value,
                          child: Semantics(
                            label: 'Workout Tracker app logo',
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(60),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.fitness_center,
                                size: 60,
                                color: AppTheme.primaryBlue,
                                semanticLabel: 'Fitness center icon',
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              
              // Text section
              Expanded(
                flex: 2,
                child: AnimatedBuilder(
                  animation: _textController,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _textSlideAnimation.value),
                      child: Opacity(
                        opacity: _textOpacityAnimation.value,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Semantics(
                              label: 'Workout Tracker',
                              header: true,
                              child: Text(
                                'Workout Tracker',
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(0, 2),
                                      blurRadius: 4,
                                      color: Colors.black26,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Semantics(
                              label: 'Track your fitness journey',
                              child: Text(
                                'Track your fitness journey',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white70,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(0, 1),
                                      blurRadius: 2,
                                      color: Colors.black12,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              // Loading section
              Expanded(
                flex: 1,
                child: Center(
                  child: Semantics(
                    label: 'Loading indicator',
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      backgroundColor: Colors.white.withOpacity(0.3),
                    ),
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
