import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ModernCard extends StatelessWidget {
  final Widget child;
  const ModernCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 30,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: child,
    );
  }
}

class GradientContainer extends StatelessWidget {
  final Widget child;
  final bool isAuthScreen;
  const GradientContainer({
    super.key,
    required this.child,
    this.isAuthScreen = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: isAuthScreen
            ? const LinearGradient(
                colors: [
                  Color(0xFF1B5E20),
                  Color(0xFF2E7D32),
                  Color(0xFF4CAF50),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : const LinearGradient(
                colors: [Color(0xFFF8FAFC), Color(0xFFE8F5E8)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
      ),
      child: child,
    );
  }
}

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  const AuthHeader({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            gradient: const RadialGradient(
              colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
            ),
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(Icons.school, size: 50, color: Colors.white),
        ),
        const SizedBox(height: 24),
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          subtitle,
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ),
      ],
    );
  }
}
