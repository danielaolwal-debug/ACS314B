import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

TextEditingController email = TextEditingController();
TextEditingController password = TextEditingController();
TextEditingController confirmPassword = TextEditingController();
TextEditingController firstname = TextEditingController();
TextEditingController lastname = TextEditingController();

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        title: const Text("Sign Up"),
        backgroundColor: Colors.green,
        centerTitle: true,
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
                  TextField(
                    controller: firstname,
                    decoration: InputDecoration(
                      labelText: "First Name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: lastname,
                    decoration: InputDecoration(
                      labelText: "Last Name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: email,
                    decoration: InputDecoration(
                      labelText: "Email or Username",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: password,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: confirmPassword,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Confirm Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 50,
                      ),
                    ),
                    onPressed: () {
                      if (password.text == confirmPassword.text &&
                          password.text.isNotEmpty) {
                        Get.snackbar(
                          "Success",
                          "Account created successfully",
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                        );
                      } else {
                        Get.snackbar(
                          "Error",
                          "Passwords do not match",
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      }
                    },
                    child: GestureDetector(
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(fontSize: 16),
                      ),
                      onTap: () async {
                        if (firstname.text.isEmpty) {
                          Get.snackbar(
                            "Error",
                            "First name cannot be empty",
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                        } else if (lastname.text.isEmpty) {
                          Get.snackbar(
                            "Error",
                            "Last name cannot be empty",
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                        } else if (password.text.isEmpty ||
                            confirmPassword.text.isEmpty ||
                            password.text.toString().compareTo(
                                  confirmPassword.text,
                                ) !=
                                0) {
                          Get.snackbar(
                            "Error",
                            "Password Confirm should be non-empty and matching",
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                        }
                        ;
                        final response = await http.get(
                          Uri.parse(
                            "http://192.168.12.1/studyplanner/create.php?firstname=${firstname.text}&lastname=${lastname.text}&email=${email.text}&password=${password.text}",
                          ),
                        );
                        if (response.statusCode == 200) {
                          final serverData = jsonDecode(response.body);
                          if (serverData['success'] == 1) {
                            Get.snackbar(
                              "Success",
                              "Account created successfully",
                              backgroundColor: Colors.green,
                              colorText: Colors.white,
                            );
                            Get.toNamed("/");
                          } else {
                            Get.snackbar(
                              "Error",
                              "Failed to create account",
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                          }
                        } else {
                          Get.snackbar(
                            "Error",
                            "Failed to create account",
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account?",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.toNamed("/");
                        },
                        child: const Text("Login"),
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
