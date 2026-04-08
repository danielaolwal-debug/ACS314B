import 'package:flutter/material.dart';
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

  // 🔹 Toggle task
  void _toggleTask(int i) {
    setState(() => _tasks[i]['done'] = !_tasks[i]['done']);
  }

  // 🔹 Progress
  double get progress {
    int done = _tasks.where((t) => t['done']).length;
    return _tasks.isEmpty ? 0 : done / _tasks.length;
  }

  // 🔹 Dashboard UI
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

          const SizedBox(height: 15),

          LinearProgressIndicator(value: progress),

          const SizedBox(height: 20),

          Expanded(
            child: ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (_, i) {
                final task = _tasks[i];

                return Card(
                  child: ListTile(
                    title: Text(task['title']),
                    subtitle: Text(task['subject']),
                    trailing: Checkbox(
                      value: task['done'],
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
    final pages = [_dashboard(), const Profile()];

    return Scaffold(
      body: IndexedStack(index: _index, children: pages),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
