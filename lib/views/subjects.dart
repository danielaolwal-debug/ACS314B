import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubjectsScreen extends StatelessWidget {
  const SubjectsScreen({super.key});

  final List<Map<String, dynamic>> subjects = const [
    {
      'name': 'Mathematics',
      'icon': Icons.calculate,
      'color': Colors.blue,
      'lessons': 12,
    },
    {
      'name': 'Science',
      'icon': Icons.science,
      'color': Colors.green,
      'lessons': 10,
    },
    {
      'name': 'English',
      'icon': Icons.menu_book,
      'color': Colors.orange,
      'lessons': 8,
    },
    {
      'name': 'History',
      'icon': Icons.history_edu,
      'color': Colors.purple,
      'lessons': 9,
    },
    {
      'name': 'Geography',
      'icon': Icons.public,
      'color': Colors.teal,
      'lessons': 7,
    },
    {
      'name': 'Computer',
      'icon': Icons.computer,
      'color': Colors.red,
      'lessons': 11,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          "Subjects",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: subjects.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.1,
          ),
          itemBuilder: (context, i) {
            final subject = subjects[i];
            final color = subject['color'] as Color;
            return GestureDetector(
              onTap: () => Get.toNamed('/lessons', arguments: subject),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        subject['icon'] as IconData,
                        color: color,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      subject['name'] as String,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${subject['lessons']} lessons",
                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
