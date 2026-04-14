import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0D1F0F), Color(0xFF1B5E20), Color(0xFF2E7D32)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: ListView(
              children: [
                // 🔹 Title - Premium style
                Text(
                  "My Profile",
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // 🔹 Avatar + Name - Glowing effect
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const RadialGradient(
                      colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withValues(alpha: 0.2),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.white.withValues(alpha: 0.1),
                    child: const Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Daniela Olwal", // ✅ Your name!
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.5),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
                Text(
                  "Computer Science Student\nASC 314B - Daystar University",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.white.withValues(alpha: 0.8),
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 32),

                // 🔹 Stats - Premium cards
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    _PremiumStat("42", "Lessons", Icons.menu_book_rounded),
                    _PremiumStat("18", "Quizzes", Icons.quiz_rounded),
                    _PremiumStat(
                      "14",
                      "Streak",
                      Icons.local_fire_department_rounded,
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // 🔹 Goal - Glass morphism effect
                Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withValues(alpha: 0.1),
                        Colors.white.withValues(alpha: 0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Color(0xFF4CAF50),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.flag,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            "Daily Goal",
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Study 4 hours today\nProgress: 2.5/4 hrs",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.white.withValues(alpha: 0.9),
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 12),
                      LinearProgressIndicator(
                        value: 0.625,
                        backgroundColor: Colors.white.withValues(alpha: 0.3),
                        color: Colors.white,
                        minHeight: 8,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // 🔹 Info - Premium cards
                Text(
                  "Account Info",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                _InfoCard("Course", "Computer Science (ASC 314B)"),
                _InfoCard("Year", "Year 2"),
                _InfoCard("Email", "daniela@daystar.ac.ke"),
                _InfoCard("Campus", "Nairobi"),

                const SizedBox(height: 32),

                // 🔹 Logout - Premium button
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: ElevatedButton(
                    onPressed: () {
                      // ✅ WORKING LOGOUT!
                      Get.snackbar(
                        "Logged Out",
                        "See you soon, Daniela! 👋",
                        backgroundColor: Colors.red.shade400,
                        colorText: Colors.white,
                      );
                      Get.offAllNamed("/"); // Back to login
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade500,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.logout, size: 24),
                        const SizedBox(width: 12),
                        Text(
                          "Log Out",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// 🔹 Premium Stat Cards (Your structure upgraded)
class _PremiumStat extends StatelessWidget {
  final String value, label;
  final IconData icon;
  const _PremiumStat(this.value, this.label, this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withValues(alpha: 0.15),
            Colors.white.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 32, color: Colors.white.withValues(alpha: 0.9)),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.poppins(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

// 🔹 Premium Info Cards
class _InfoCard extends StatelessWidget {
  final String title, value;
  const _InfoCard(this.title, this.value);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white.withValues(alpha: 0.1), Colors.transparent],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$title:",
            style: GoogleFonts.poppins(
              color: Colors.white.withValues(alpha: 0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
