import 'package:flutter/material.dart';

class LessonsScreen extends StatefulWidget {
  final String subject;

  const LessonsScreen({super.key, required this.subject});

  @override
  State<LessonsScreen> createState() => _LessonsScreenState();
}

class _LessonsScreenState extends State<LessonsScreen> {
  int? selected;

  //  Properly typed list
  final List<Map<String, dynamic>> lessons = [
    {'title': 'Intro', 'time': '10 min', 'locked': false, 'done': true},
    {'title': 'Core 1', 'time': '20 min', 'locked': false, 'done': true},
    {'title': 'Core 2', 'time': '25 min', 'locked': false, 'done': false},
    {'title': 'Applications', 'time': '30 min', 'locked': false, 'done': false},
    {'title': 'Mistakes', 'time': '15 min', 'locked': true, 'done': false},
  ];

  //  Progress calculation
  double get progress {
    int done = lessons.where((l) => l['done'] == true).length;
    return lessons.isEmpty ? 0 : done / lessons.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1F0F),

      appBar: AppBar(
        title: Text(widget.subject),
        backgroundColor: const Color(0xFF0D1F0F),
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      body: Column(
        children: [
          // 🔹 Progress bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white12,
              valueColor: const AlwaysStoppedAnimation(Colors.green),
            ),
          ),

          //  Lessons list
          Expanded(
            child: ListView.builder(
              itemCount: lessons.length,
              itemBuilder: (context, i) {
                final lesson = lessons[i];

                //
                final String title = lesson['title'] as String;
                final String time = lesson['time'] as String;
                final bool locked = lesson['locked'] as bool;
                final bool done = lesson['done'] as bool;

                return ListTile(
                  title: Text(
                    title,
                    style: TextStyle(
                      color: locked ? Colors.white30 : Colors.white,
                    ),
                  ),
                  subtitle: Text(
                    time,
                    style: const TextStyle(color: Colors.white54),
                  ),

                  // 🔹 Left icon
                  leading: done
                      ? const Icon(Icons.check, color: Colors.green)
                      : locked
                      ? const Icon(Icons.lock, color: Colors.white30)
                      : Text(
                          '${i + 1}',
                          style: const TextStyle(color: Colors.white),
                        ),

                  // 🔹 Right icon
                  trailing: !locked
                      ? const Icon(Icons.play_circle, color: Colors.green)
                      : null,

                  // 🔹 Tap action
                  onTap: () {
                    if (locked) return;

                    setState(() => selected = i);

                    showModalBottomSheet(
                      context: context,
                      backgroundColor: const Color(0xFF1A3A1A),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      builder: (_) => Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Duration: $time",
                              style: const TextStyle(color: Colors.white70),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Start Lesson"),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
