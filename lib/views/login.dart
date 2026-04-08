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
  // ✅ Moved inside State to avoid lifecycle issues
  final Logincontroller logincontroller = Get.put(Logincontroller());
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        title: const Text(
          "Login",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Card(
            color: Colors.white,
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            margin: const EdgeInsets.all(20),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
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

                  TextField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      labelText: "Email or Username",
                      prefixIcon: const Icon(Icons.person, color: Colors.green),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                  ),
                  const SizedBox(height: 15),

                  Obx(
                    () => TextField(
                      controller: passwordController,
                      obscureText: logincontroller.isPasswordVisible.value,
                      decoration: InputDecoration(
                        labelText: "Password",
                        prefixIcon: const Icon(Icons.lock, color: Colors.green),
                        suffixIcon: GestureDetector(
                          onTap: () => logincontroller.togglePassword(),
                          child: Icon(
                            logincontroller.isPasswordVisible.value
                                ? Icons.visibility_off
                                : Icons.visibility,
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

                  MaterialButton(
                    onPressed: () {
                      Get.toNamed('/home');
                    },
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
                  const SizedBox(height: 15),

                  GestureDetector(
                    onTap: () {
                      bool success = logincontroller.login(
                        usernameController.text,
                        passwordController.text,
                      );
                      if (success) {
                        Get.offAndToNamed("/homeScreen");
                      } else {
                        Get.snackbar(
                          "Login Failed",
                          "Invalid Username or Password",
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      }
                    },
                    child: const Text(
                      "Login with credentials",
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account?",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
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
                      GestureDetector(
                        child: const Text("login"),
                        onTap: () async {
                          if (usernameController.text.isEmpty) {
                            Get.snackbar(
                              "Error",
                              "Enter username or email",
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                          } else if (passwordController.text.isEmpty) {
                            Get.snackbar(
                              "Error",
                              "Enter password",
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                          } else {
                            // ✅ Fixed: corrected spelling of 'response'
                            final response = await http.get(
                              Uri.parse(
                                "http://192.168.0.111/studyplanner/login.php?username=${usernameController.text}&password=${passwordController.text}",
                              ),
                            );

                            // ✅ Fixed: properly structured if/else with correct braces
                            if (response.statusCode == 200) {
                              final serverData = jsonDecode(response.body);

                              // ✅ Fixed: added null else branch to ternary
                              // ✅ Fixed: square brackets for map access
                              if (serverData['success'] == true) {
                                Get.offAndToNamed("/homeScreen");
                              } else {
                                Get.snackbar(
                                  "Wrong credentials",
                                  serverData['message'], // ✅ Fixed: [] not ()
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                );
                              }
                            } else {
                              Get.snackbar(
                                "Error",
                                "Server error: ${response.statusCode}",
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                              );
                            }
                          }
                        },
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
