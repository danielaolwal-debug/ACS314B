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
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController universityController = TextEditingController();
  final TextEditingController courseController = TextEditingController();
  final TextEditingController campusController = TextEditingController();
  final TextEditingController yearController = TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    firstnameController.dispose();
    lastnameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    universityController.dispose();
    courseController.dispose();
    campusController.dispose();
    yearController.dispose();
    super.dispose();
  }

  bool _validateForm() {
    if (firstnameController.text.trim().isEmpty) {
      _error("First name is required");
      return false;
    }
    if (lastnameController.text.trim().isEmpty) {
      _error("Last name is required");
      return false;
    }
    if (emailController.text.trim().isEmpty) {
      _error("Email is required");
      return false;
    }
    if (!emailController.text.trim().contains('@')) {
      _error("Please enter a valid email");
      return false;
    }
    if (passwordController.text.isEmpty) {
      _error("Password is required");
      return false;
    }
    if (passwordController.text.length < 6) {
      _error("Password must be at least 6 characters");
      return false;
    }
    if (passwordController.text != confirmPasswordController.text) {
      _error("Passwords do not match");
      return false;
    }
    if (universityController.text.trim().isEmpty) {
      _error("University is required");
      return false;
    }
    if (courseController.text.trim().isEmpty) {
      _error("Course is required");
      return false;
    }
    if (campusController.text.trim().isEmpty) {
      _error("Campus/County is required");
      return false;
    }
    if (yearController.text.trim().isEmpty) {
      _error("Year is required");
      return false;
    }
    return true;
  }

  void _error(String msg) {
    Get.snackbar(
      "Error",
      msg,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  Future<void> _signup() async {
    if (!_validateForm()) return;
    setState(() => isLoading = true);

    try {
      final response = await http.post(
        Uri.parse("http://localhost/studyplanner/signup.php"),
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {
          'name':
              '${firstnameController.text.trim()} ${lastnameController.text.trim()}',
          'email': emailController.text.trim(),
          'password': passwordController.text.trim(),
          'university': universityController.text.trim(),
          'course': courseController.text.trim(),
          'campus': campusController.text.trim(),
          'year': yearController.text.trim(),
        },
      );

      final serverData = jsonDecode(response.body);

      if (response.statusCode == 200 && serverData['status'] == "success") {
        Get.snackbar(
          "Success 🎓",
          "Account created! Welcome ${firstnameController.text.trim()}!",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.offAllNamed("/");
      } else {
        _error(
          serverData['error'] ?? serverData['message'] ?? "Registration failed",
        );
      }
    } catch (e) {
      _error("Network error: ${e.toString()}");
    } finally {
      setState(() => isLoading = false);
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscure = false,
    TextInputType keyboard = TextInputType.text,
    String? hint,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboard,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.green),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey[50],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        title: const Text(
          "Sign Up",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
        centerTitle: true,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Card(
          color: Colors.white,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Avatar
                Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: const Icon(
                    Icons.person_add,
                    size: 40,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 24),

                // ── Personal Info ───────────────────────────────
                _buildTextField(
                  controller: firstnameController,
                  label: "First Name",
                  icon: Icons.person,
                ),
                const SizedBox(height: 16),

                _buildTextField(
                  controller: lastnameController,
                  label: "Last Name",
                  icon: Icons.person_outline,
                ),
                const SizedBox(height: 16),

                _buildTextField(
                  controller: emailController,
                  label: "Email",
                  icon: Icons.email,
                  keyboard: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),

                _buildTextField(
                  controller: passwordController,
                  label: "Password",
                  icon: Icons.lock,
                  obscure: true,
                ),
                const SizedBox(height: 16),

                _buildTextField(
                  controller: confirmPasswordController,
                  label: "Confirm Password",
                  icon: Icons.lock_outline,
                  obscure: true,
                ),
                const SizedBox(height: 24),

                // ── Divider ─────────────────────────────────────
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        "Academic Details",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 16),

                // ── Academic Info ───────────────────────────────
                _buildTextField(
                  controller: universityController,
                  label: "University",
                  icon: Icons.school,
                  hint: "e.g. Daystar University",
                ),
                const SizedBox(height: 16),

                _buildTextField(
                  controller: courseController,
                  label: "Course",
                  icon: Icons.book,
                  hint: "e.g. Computer Science",
                ),
                const SizedBox(height: 16),

                _buildTextField(
                  controller: campusController,
                  label: "Campus / County",
                  icon: Icons.location_on,
                  hint: "e.g. Nairobi",
                ),
                const SizedBox(height: 16),

                _buildTextField(
                  controller: yearController,
                  label: "Year of Study",
                  icon: Icons.calendar_today,
                  keyboard: TextInputType.number,
                  hint: "e.g. Year 2",
                ),
                const SizedBox(height: 28),

                // ── Sign Up Button ──────────────────────────────
                isLoading
                    ? const CircularProgressIndicator(color: Colors.green)
                    : SizedBox(
                        width: double.infinity,
                        child: MaterialButton(
                          onPressed: _signup,
                          color: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: const Text(
                            "Create Account",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),

                const SizedBox(height: 16),

                // Login redirect
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?"),
                    TextButton(
                      onPressed: () => Get.offAllNamed("/"),
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
