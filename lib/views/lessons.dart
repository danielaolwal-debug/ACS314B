import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LessonsScreen extends StatelessWidget {
  const LessonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final subject = Get.arguments as Map<String, dynamic>? ?? {};
    final subjectName = subject['name'] ?? 'Lessons';
    final color = (subject['color'] as Color?) ?? Colors.green;

    final List<Map<String, dynamic>> lessons = List.generate(
      8,
      (i) => {
        'title': 'Lesson ${i + 1}',
        'desc': 'Introduction to topic ${i + 1} in $subjectName',
        'duration': '${10 + i * 5} min',
        'done': i < 3,
      },
    );

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          subjectName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: color,
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: lessons.length,
        itemBuilder: (context, i) {
          final lesson = lessons[i];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: lesson['done'] as bool
                      ? color.withValues(alpha: 0.15)
                      : Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  lesson['done'] as bool
                      ? Icons.check_circle
                      : Icons.play_circle_outline,
                  color: lesson['done'] as bool ? color : Colors.grey,
                  size: 28,
                ),
              ),
              title: Text(
                lesson['title'] as String,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    lesson['desc'] as String,
                    style: TextStyle(color: Colors.grey[500], fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.timer, size: 12, color: Colors.grey[400]),
                      const SizedBox(width: 4),
                      Text(
                        lesson['duration'] as String,
                        style: TextStyle(color: Colors.grey[400], fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
              trailing: ElevatedButton(
                onPressed: () => Get.toNamed('/quiz', arguments: subject),
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Start",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
