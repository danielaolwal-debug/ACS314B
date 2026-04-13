import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/leaderboard.dart';
import 'package:flutter_application_1/views/lessons.dart';
import 'package:flutter_application_1/views/quiz.dart';
import 'package:flutter_application_1/views/results.dart';
import 'profile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  final List<Map<String, dynamic>> _tasks = [
    {'title': 'Read Chapter 2', 'subject': 'History', 'done': false},
    {'title': 'Practice Flutter', 'subject': 'Programming', 'done': false},
    {'title': 'Solve Math Exercises', 'subject': 'Mathematics', 'done': false},
    {'title': 'Biology Notes Review', 'subject': 'Biology', 'done': false},
  ];

  void _toggleTask(int i) {
    setState(() => _tasks[i]['done'] = !_tasks[i]['done']);
  }

  double get progress {
    int done = _tasks.where((t) => t['done']).length;
    return _tasks.isEmpty ? 0 : done / _tasks.length;
  }

  Widget _dashboard() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Study Planner",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            "${_tasks.where((t) => t['done']).length} of ${_tasks.length} tasks completed",
            style: TextStyle(color: Colors.grey[600], fontSize: 13),
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: Colors.grey[200],
            color: Colors.green,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (_, i) {
                final task = _tasks[i];
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.book, color: Colors.green),
                    ),
                    title: Text(
                      task['title'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: task['done']
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        color: task['done'] ? Colors.grey : Colors.black,
                      ),
                    ),
                    subtitle: Text(task['subject']),
                    trailing: Checkbox(
                      value: task['done'],
                      activeColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      onChanged: (_) => _toggleTask(i),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _dashboard(),
      const Profile(),
      const LeaderboardScreen(),
      const LessonsScreen(),
      const ResultScreen(),
      const QuizScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard),
            label: "Leaders",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.play_lesson),
            label: "Lessons",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.report), label: "Results"),
          BottomNavigationBarItem(icon: Icon(Icons.quiz), label: "Quiz"),
        ],
      ),
    );
  }
}
