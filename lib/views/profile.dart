import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/controllers/logincontroller.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final Logincontroller _loginController = Get.find<Logincontroller>();

  // ── User details from server ─────────────────────────────────
  String _name = '';
  String _email = '';
  String _course = '';
  String _year = '';
  String _campus = '';
  String _university = '';
  bool _loading = true;
  String _errorMsg = '';

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    final studentId = _loginController.studentId.value;

    // ── Immediately show the name saved at login ─────────────
    setState(() {
      _name = _loginController.studentName.value;
    });

    if (studentId == 0) {
      setState(() => _loading = false);
      return;
    }

    try {
      final response = await http
          .post(
            Uri.parse("http://localhost/studyplanner/get_profile.php"),
            headers: {"Content-Type": "application/x-www-form-urlencoded"},
            body: {"student_id": studentId.toString()},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true) {
          setState(() {
            _name = data['name'] ?? _name;
            _email = data['email'] ?? '';
            _course = data['course'] ?? '';
            _year = data['year'] ?? '';
            _campus = data['campus'] ?? '';
            _university = data['university'] ?? '';
            _errorMsg = '';
          });
        } else {
          setState(
            () => _errorMsg = data['message'] ?? 'Failed to load profile',
          );
        }
      } else {
        setState(() => _errorMsg = 'Server error: ${response.statusCode}');
      }
    } catch (e) {
      // Network error — still show the name from login, just not the other details
      setState(
        () => _errorMsg = 'Could not load details. Check your connection.',
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  String get _displayName {
    if (_name.isNotEmpty) return _name;
    if (_loginController.studentName.value.isNotEmpty) {
      return _loginController.studentName.value;
    }
    return 'Student';
  }

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
            child: _loading
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: Colors.white),
                        SizedBox(height: 16),
                        Text(
                          "Loading profile...",
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  )
                : ListView(
                    children: [
                      // ── Title ──────────────────────────────────
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

                      // ── Avatar with first letter of name ───────
                      Center(
                        child: Container(
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
                            backgroundColor: Colors.white.withValues(
                              alpha: 0.1,
                            ),
                            child: Text(
                              _displayName.isNotEmpty
                                  ? _displayName[0].toUpperCase()
                                  : '?',
                              style: const TextStyle(
                                fontSize: 40,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // ── Name ────────────────────────────────────
                      Center(
                        child: Text(
                          _displayName,
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      Center(
                        child: Text(
                          _course.isNotEmpty && _university.isNotEmpty
                              ? "$_course\n$_university"
                              : _course.isNotEmpty
                              ? _course
                              : "Student",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.white.withValues(alpha: 0.8),
                            height: 1.5,
                          ),
                        ),
                      ),

                      // ── Error message if server failed ──────────
                      if (_errorMsg.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.orange.withOpacity(0.5),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.wifi_off,
                                color: Colors.orange,
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _errorMsg,
                                  style: const TextStyle(
                                    color: Colors.orange,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() => _loading = true);
                                  _fetchProfile();
                                },
                                child: const Text(
                                  "Retry",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: 32),

                      // ── Daily Goal ─────────────────────────────
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
                              backgroundColor: Colors.white.withValues(
                                alpha: 0.3,
                              ),
                              color: Colors.white,
                              minHeight: 8,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // ── Account Info ───────────────────────────
                      Text(
                        "Account Info",
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 16),

                      //  All pulled from signup data via server
                      _InfoCard(
                        icon: Icons.book,
                        title: "Course",
                        value: _course.isNotEmpty ? _course : '—',
                      ),
                      _InfoCard(
                        icon: Icons.calendar_today,
                        title: "Year",
                        value: _year.isNotEmpty ? _year : '—',
                      ),
                      _InfoCard(
                        icon: Icons.email,
                        title: "Email",
                        value: _email.isNotEmpty ? _email : '—',
                      ),
                      _InfoCard(
                        icon: Icons.location_on,
                        title: "Campus",
                        value: _campus.isNotEmpty ? _campus : '—',
                      ),
                      _InfoCard(
                        icon: Icons.school,
                        title: "University",
                        value: _university.isNotEmpty ? _university : '—',
                      ),

                      const SizedBox(height: 32),

                      // ── Logout ─────────────────────────────────
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        child: ElevatedButton(
                          onPressed: () {
                            _loginController.studentId.value = 0;
                            _loginController.studentName.value = '';
                            Get.snackbar(
                              "Logged Out",
                              "See you soon, $_displayName! 👋",
                              backgroundColor: Colors.red.shade400,
                              colorText: Colors.white,
                            );
                            Get.offAllNamed("/");
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

// ── Info Card ─────────────────────────────────────────────────
class _InfoCard extends StatelessWidget {
  final String title, value;
  final IconData icon;
  const _InfoCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white.withValues(alpha: 0.1), Colors.transparent],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 20),
          const SizedBox(width: 12),
          Text(
            "$title:",
            style: GoogleFonts.poppins(
              color: Colors.white.withValues(alpha: 0.7),
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
