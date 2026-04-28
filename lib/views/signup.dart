import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // One controller per input field
  final _fname = TextEditingController();
  final _lname = TextEditingController();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  final _confirm = TextEditingController();
  final _university = TextEditingController();
  final _course = TextEditingController();
  final _campus = TextEditingController();
  final _year = TextEditingController();

  bool _loading = false; // controls showing spinner vs button

  @override
  void dispose() {
    // Free all controllers from memory when screen is closed
    for (final c in [
      _fname,
      _lname,
      _email,
      _pass,
      _confirm,
      _university,
      _course,
      _campus,
      _year,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  // ── Show red error snackbar ───────────────────────────────
  void _err(String msg) => Get.snackbar(
    'Error',
    msg,
    backgroundColor: Colors.red,
    colorText: Colors.white,
  );

  // ── Validate all fields before submitting ─────────────────
  bool _valid() {
    if (_fname.text.trim().isEmpty) {
      _err('First name required');
      return false;
    }
    if (_lname.text.trim().isEmpty) {
      _err('Last name required');
      return false;
    }
    if (!_email.text.contains('@')) {
      _err('Valid email required');
      return false;
    }
    if (_pass.text.length < 6) {
      _err('Password min 6 characters');
      return false;
    }
    if (_pass.text != _confirm.text) {
      _err('Passwords do not match');
      return false;
    }
    if (_university.text.trim().isEmpty) {
      _err('University required');
      return false;
    }
    if (_course.text.trim().isEmpty) {
      _err('Course required');
      return false;
    }
    if (_campus.text.trim().isEmpty) {
      _err('Campus required');
      return false;
    }
    if (_year.text.trim().isEmpty) {
      _err('Year required');
      return false;
    }
    return true;
  }

  // ── Submit signup to server ───────────────────────────────
  Future<void> _signup() async {
    if (!_valid()) return;
    setState(() => _loading = true); // show spinner

    try {
      final res = await http.post(
        Uri.parse('http://localhost/studyplanner/signup.php'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          // Combine first + last name into one field
          'name': '${_fname.text.trim()} ${_lname.text.trim()}',
          'email': _email.text.trim(),
          'password': _pass.text,
          'university': _university.text.trim(),
          'course': _course.text.trim(),
          'campus': _campus.text.trim(),
          'year': _year.text.trim(),
        },
      );

      final data = jsonDecode(res.body);

      if (data['status'] == 'success') {
        Get.snackbar(
          'Success 🎓',
          'Account created!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        // Go back to login, clearing the stack
        Get.offAllNamed('/');
      } else {
        _err(data['message'] ?? 'Registration failed');
      }
    } catch (e) {
      _err('Network error: $e');
    } finally {
      setState(() => _loading = false); // always hide spinner
    }
  }

  // ── Reusable text field builder ───────────────────────────
  // Avoids repeating the same decoration 9 times
  Widget _field(
    TextEditingController c,
    String label,
    IconData icon, {
    bool obscure = false,
    TextInputType kb = TextInputType.text,
    String? hint,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: c,
        obscureText: obscure,
        keyboardType: kb,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, color: Colors.green),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.grey[50],
        ),
      ),
    );
  }

  // ── UI ────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        title: const Text(
          'Sign Up',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
        centerTitle: true,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Avatar icon
                const CircleAvatar(
                  radius: 36,
                  backgroundColor: Color(0xFFE8F5E9),
                  child: Icon(Icons.person_add, size: 36, color: Colors.green),
                ),
                const SizedBox(height: 20),

                // ── Personal info fields ──────────────────────
                _field(_fname, 'First Name', Icons.person),
                _field(_lname, 'Last Name', Icons.person_outline),
                _field(
                  _email,
                  'Email',
                  Icons.email,
                  kb: TextInputType.emailAddress,
                ),
                _field(_pass, 'Password', Icons.lock, obscure: true),
                _field(
                  _confirm,
                  'Confirm Password',
                  Icons.lock_outline,
                  obscure: true,
                ),

                // Divider between personal and academic sections
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Expanded(child: Divider()),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          'Academic Details',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),
                ),

                // ── Academic info fields ──────────────────────
                _field(
                  _university,
                  'University',
                  Icons.school,
                  hint: 'e.g. Daystar University',
                ),
                _field(
                  _course,
                  'Course',
                  Icons.book,
                  hint: 'e.g. Computer Science',
                ),
                _field(
                  _campus,
                  'Campus/County',
                  Icons.location_on,
                  hint: 'e.g. Nairobi',
                ),
                _field(
                  _year,
                  'Year of Study',
                  Icons.calendar_today,
                  kb: TextInputType.number,
                  hint: 'e.g. Year 2',
                ),

                // Show spinner while loading, button otherwise
                _loading
                    ? const CircularProgressIndicator(color: Colors.green)
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _signup,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Create Account',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                const SizedBox(height: 12),

                // Link back to login
                TextButton(
                  onPressed: () => Get.offAllNamed('/'),
                  child: const Text(
                    'Already have an account? Login',
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
