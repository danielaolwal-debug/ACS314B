import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1F0F),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            // 🔹 Title
            const Text(
              "My Profile",
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            // 🔹 Avatar + Name
            Column(
              children: const [
                CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40)),
                SizedBox(height: 10),
                Text(
                  "Daniella",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                Text(
                  "Computer Science Student",
                  style: TextStyle(color: Colors.white54),
                ),
              ],
            ),

            const SizedBox(height: 25),

            // 🔹 Stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                _Stat("42", "Lessons"),
                _Stat("18", "Quizzes"),
                _Stat("14", "Streak"),
              ],
            ),

            const SizedBox(height: 25),

            // 🔹 Goal
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                "Daily Goal: Study 4 hours\nProgress: 2.5 hrs today",
                style: TextStyle(color: Colors.white),
              ),
            ),

            const SizedBox(height: 25),

            // 🔹 Info
            const Text(
              "Account Info",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const _Info("Course", "Computer Science"),
            const _Info("Year", "Year 2"),
            const _Info("Email", "daniella@university.ac.ke"),
            const _Info("Campus", "Nairobi"),

            const SizedBox(height: 25),

            // 🔹 Logout
            ElevatedButton(onPressed: () {}, child: const Text("Log Out")),
          ],
        ),
      ),
    );
  }
}

// 🔹 Small reusable widgets (VERY IMPORTANT concept)

class _Stat extends StatelessWidget {
  final String value, label;
  const _Stat(this.value, this.label);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white54, fontSize: 12),
        ),
      ],
    );
  }
}

class _Info extends StatelessWidget {
  final String title, value;
  const _Info(this.title, this.value);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title, style: const TextStyle(color: Colors.white54)),
      subtitle: Text(value, style: const TextStyle(color: Colors.white)),
    );
  }
}
