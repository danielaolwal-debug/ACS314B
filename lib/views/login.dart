import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_application_1/controllers/logincontroller.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Logincontroller logincontroller = Get.put(Logincontroller());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> loginUser() async {
    if (emailController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Enter email",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (passwordController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Enter password",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse("http://localhost/studyplanner/login.php"),
        body: {
          'email': emailController.text.trim(),
          'password': passwordController.text.trim(),
        },
      );

      if (response.statusCode == 200) {
        final serverData = jsonDecode(response.body);

        if (serverData['success'] == true) {
          final user = serverData['user'];
          Get.snackbar(
            "Welcome",
            "Hello ${user['firstname'].toString().isEmpty ? user['lastname'] : user['firstname']}!",
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          // ✅ Fixed route name to match your GetPage definition
          Get.offAllNamed("/HomeScreen");
        } else {
          Get.snackbar(
            "Login Failed",
            serverData['message'] ?? "Invalid credentials",
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          "Server Error",
          "Code: ${response.statusCode}",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Network Error",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        title: const Text(
          "Login",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Card(
            elevation: 5,
            margin: const EdgeInsets.all(20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Avatar
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.green,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Email field
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "Email",
                      prefixIcon: const Icon(Icons.email, color: Colors.green),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Password field
                  Obx(
                    () => TextField(
                      controller: passwordController,
                      obscureText: !logincontroller.isPasswordVisible.value,
                      decoration: InputDecoration(
                        labelText: "Password",
                        prefixIcon: const Icon(Icons.lock, color: Colors.green),
                        suffixIcon: GestureDetector(
                          onTap: () => logincontroller.togglePassword(),
                          child: Icon(
                            logincontroller.isPasswordVisible.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.green,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ✅ Fixed Login button
                  MaterialButton(
                    onPressed: loginUser,
                    color: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 80,
                    ),
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Sign up redirect
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      TextButton(
                        onPressed: () => Get.toNamed('/signup'),
                        child: const Text(
                          "Sign Up",
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
      ),
    );
  }
}
