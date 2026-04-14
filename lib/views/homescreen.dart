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
    {
      'title': 'Read Chapter 2',
      'subject': 'History',
      'done': false,
      'color': Colors.purple,
    },
    {
      'title': 'Practice Flutter',
      'subject': 'Programming',
      'done': false,
      'color': Colors.blue,
    },
    {
      'title': 'Solve Math Exercises',
      'subject': 'Mathematics',
      'done': false,
      'color': Colors.orange,
    },
    {
      'title': 'Biology Notes Review',
      'subject': 'Biology',
      'done': false,
      'color': Colors.green,
    },
  ];

  void _toggleTask(int i) {
    setState(() => _tasks[i]['done'] = !_tasks[i]['done']);
  }

  double get progress {
    int done = _tasks.where((t) => t['done']).length;
    return _tasks.isEmpty ? 0 : done / _tasks.length;
  }

  Widget _dashboard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2E7D32), Color(0xFF66BB6A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Good day, Student! 👋",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Let's keep learning!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${(_tasks.where((t) => t['done']).length)} of ${_tasks.length} tasks done",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      "${(progress * 100).toInt()}%",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: Colors.white30,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ✅ Quick stats
          Row(
            children: [
              _statCard("24", "Lessons", Icons.book, Colors.blue),
              const SizedBox(width: 12),
              _statCard("18", "Quizzes", Icons.quiz, Colors.orange),
              const SizedBox(width: 12),
              _statCard("82%", "Avg Score", Icons.star, Colors.purple),
            ],
          ),

          const SizedBox(height: 24),

          const Text(
            "Today's Tasks",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          // ✅ Task list
          ..._tasks.asMap().entries.map((entry) {
            int i = entry.key;
            final task = entry.value;
            final color = task['color'] as Color;
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.book, color: color),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task['title'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            decoration: task['done']
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                            color: task['done'] ? Colors.grey : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          task['subject'],
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Checkbox(
                    value: task['done'],
                    activeColor: color,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    onChanged: (_) => _toggleTask(i),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _statCard(String value, String label, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: color,
              ),
            ),
            Text(
              label,
              style: TextStyle(color: Colors.grey[500], fontSize: 11),
            ),
          ],
        ),
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
      body: SafeArea(
        child: IndexedStack(index: _index, children: pages),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey[400],
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 8,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: "Profile",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard_rounded),
            label: "Leaders",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.play_lesson_rounded),
            label: "Lessons",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_rounded),
            label: "Results",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.quiz_rounded),
            label: "Quiz",
          ),
        ],
      ),
    );
  }
}
