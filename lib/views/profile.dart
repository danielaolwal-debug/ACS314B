import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_1/controllers/logincontroller.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the global controller — no initState needed since it's StatelessWidget
    final ctrl = Get.find<Logincontroller>();

    // Use name from controller, fallback to 'Student' if empty
    final name = ctrl.studentName.value.isNotEmpty
        ? ctrl.studentName.value
        : 'Student';
    final email = ctrl.studentEmail.value;
    final course = ctrl.studentCourse.value;
    final year = ctrl.studentYear.value;
    final campus = ctrl.studentCampus.value;
    final university = ctrl.studentUniversity.value;

    return Scaffold(
      body: Container(
        // Dark green gradient background
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0D1F0F), Color(0xFF1B5E20), Color(0xFF2E7D32)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // ── Page title ──────────────────────────────────
              Text(
                'My Profile',
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              // ── Avatar circle showing first letter of name ──
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: const Color(0xFF4CAF50),
                  child: Text(
                    name[0].toUpperCase(), // first letter of name
                    style: const TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // ── Student name ────────────────────────────────
              Center(
                child: Text(
                  name,
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // ── Course + University subtitle ────────────────
              Center(
                child: Text(
                  course.isNotEmpty && university.isNotEmpty
                      ? '$course\n$university'
                      : course.isNotEmpty
                      ? course
                      : 'Student',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.white70,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // ── Daily goal card (static placeholder) ────────
              _goalCard(),
              const SizedBox(height: 32),

              // ── Account info section heading ─────────────────
              Text(
                'Account Info',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              // ── One info card per field ──────────────────────
              _InfoCard(Icons.book, 'Course', course.isNotEmpty ? course : '—'),
              _InfoCard(
                Icons.calendar_today,
                'Year',
                year.isNotEmpty ? year : '—',
              ),
              _InfoCard(Icons.email, 'Email', email.isNotEmpty ? email : '—'),
              _InfoCard(
                Icons.location_on,
                'Campus',
                campus.isNotEmpty ? campus : '—',
              ),
              _InfoCard(
                Icons.school,
                'University',
                university.isNotEmpty ? university : '—',
              ),
              const SizedBox(height: 32),

              // ── Logout button ────────────────────────────────
              ElevatedButton.icon(
                onPressed: () {
                  ctrl.clearProfile(); // wipe all stored data
                  Get.offAllNamed('/'); // go back to login
                },
                icon: const Icon(Icons.logout),
                label: const Text(
                  'Log Out',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade500,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // ── Daily Goal Card ───────────────────────────────────────
  Widget _goalCard() => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.08),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.white24),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.flag, color: Colors.green),
            SizedBox(width: 8),
            Text(
              'Daily Goal',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Text(
          'Study 4 hours today\nProgress: 2.5/4 hrs',
          style: TextStyle(color: Colors.white70, height: 1.4),
        ),
        const SizedBox(height: 10),
        // Progress bar — 62.5% filled
        LinearProgressIndicator(
          value: 0.625,
          backgroundColor: Colors.white24,
          color: Colors.green,
          minHeight: 8,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    ),
  );
}

// ── Reusable Info Card widget ─────────────────────────────────
// Shows one row: icon | label | value
class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title, value;
  const _InfoCard(this.icon, this.title, this.value);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white60, size: 20),
          const SizedBox(width: 12),
          Text(
            '$title:',
            style: const TextStyle(color: Colors.white60, fontSize: 13),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
