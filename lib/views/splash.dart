import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.forward();

    Future.delayed(const Duration(seconds: 3), () {
      Get.offAllNamed('/onboarding');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1B5E20), Color(0xFF2E7D32), Color(0xFF4CAF50)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated Logo
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _animation.value,
                    child: Container(
                      height: 140,
                      width: 140,
                      decoration: BoxDecoration(
                        gradient: const RadialGradient(
                          colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
                        ),
                        borderRadius: BorderRadius.circular(35),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 30,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.school,
                        size: 80,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),
              Text(
                "StudyPlanner",
                style: GoogleFonts.poppins(
                  fontSize: 36,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  shadows: [
                    Shadow(
                      color: Colors.black.withValues(alpha: 0.5),
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Learn. Practice. Succeed.",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
              const SizedBox(height: 60),
              // Premium Loader
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
