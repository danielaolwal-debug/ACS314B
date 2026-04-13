import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Get.offAllNamed('/onboarding');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(Icons.school, size: 70, color: Colors.green),
            ),
            const SizedBox(height: 24),
            const Text(
              "StudyPlanner",
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Learn. Practice. Succeed.",
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 60),
            const CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          ],
        ),
      ),
    );
  }
}
