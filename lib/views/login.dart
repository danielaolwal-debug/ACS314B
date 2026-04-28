import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/controllers/logincontroller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Get the global controller registered in main.dart
  final ctrl = Get.find<Logincontroller>();

  // Controllers that read what the user types
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    // Always dispose controllers to free memory when screen closes
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  // ── Login Logic ───────────────────────────────────────────
  Future<void> _login() async {
    // Basic validation before hitting the server
    if (_email.text.trim().isEmpty || _password.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Enter email and password',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      // Send POST request to the PHP login endpoint
      final res = await http.post(
        Uri.parse('http://localhost/studyplanner/login.php'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'email': _email.text.trim(), 'password': _password.text},
      );

      // Parse the JSON response from the server
      final data = jsonDecode(res.body);

      if (data['success'] == true) {
        // Save all profile fields into the global controller
        ctrl.setProfile(
          id: data['student_id'] ?? 0,
          name: data['name'] ?? '',
          email: data['email'] ?? '',
          course: data['course'] ?? '',
          year: data['year'] ?? '',
          campus: data['campus'] ?? '',
          university: data['university'] ?? '',
        );
        // Navigate to home, removing login from the stack
        Get.offAllNamed('/HomeScreen');
      } else {
        // Show whatever error message the server sent back
        Get.snackbar(
          'Login Failed',
          data['message'] ?? 'Invalid credentials',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      // Catches network errors (no internet, wrong URL, etc.)
      Get.snackbar(
        'Network Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // ── UI ────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        title: const Text(
          'Login',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Avatar icon at the top
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: Color(0xFFE8F5E9),
                    child: Icon(Icons.person, size: 40, color: Colors.green),
                  ),
                  const SizedBox(height: 24),

                  // Email input field
                  TextField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: _inputDecor('Email', Icons.email),
                  ),
                  const SizedBox(height: 16),

                  // Password field — wrapped in Obx so eye icon updates reactively
                  Obx(
                    () => TextField(
                      controller: _password,
                      obscureText: !ctrl.isPasswordVisible.value,
                      decoration: _inputDecor('Password', Icons.lock).copyWith(
                        suffixIcon: IconButton(
                          icon: Icon(
                            ctrl.isPasswordVisible.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.green,
                          ),
                          onPressed: ctrl.togglePassword, // flip show/hide
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Login button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Redirect to sign up screen
                  TextButton(
                    onPressed: () => Get.toNamed('/signup'),
                    child: const Text(
                      "Don't have an account? Sign Up",
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Reusable input decoration helper ─────────────────────
  // Keeps field styling consistent without repeating code
  InputDecoration _inputDecor(String label, IconData icon) => InputDecoration(
    labelText: label,
    prefixIcon: Icon(icon, color: Colors.green),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    filled: true,
    fillColor: Colors.grey[100],
  );
}
