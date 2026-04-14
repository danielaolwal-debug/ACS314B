import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/lessons.dart';
import 'package:flutter_application_1/views/quiz.dart';
import 'profile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  // ✅ Controllers for ADD TASK
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();

  final List<Map<String, dynamic>> _tasks = [
    {
      'title': 'Read ASC 314 Chapter 1',
      'subject': 'Computer Science',
      'done': false,
      'color': Colors.green,
    },
    {
      'title': 'Practice Flutter Routing',
      'subject': 'Mobile Development',
      'done': true,
      'color': Colors.blue,
    },
    {
      'title': 'Solve Math Assignment',
      'subject': 'Mathematics',
      'done': false,
      'color': Colors.orange,
    },
  ];

  // ✅ ADD TASK FUNCTION
  void _addTask() {
    if (_titleController.text.trim().isNotEmpty &&
        _subjectController.text.trim().isNotEmpty) {
      setState(() {
        _tasks.insert(0, {
          'title': _titleController.text.trim(),
          'subject': _subjectController.text.trim(),
          'done': false,
          'color': Colors.purple,
        });
        _titleController.clear();
        _subjectController.clear();
      });
    }
  }

  void _toggleTask(int i) {
    setState(() => _tasks[i]['done'] = !_tasks[i]['done']);
  }

  double get progress {
    int done = _tasks.where((t) => t['done']).length;
    return _tasks.isEmpty ? 0 : done / _tasks.length;
  }

  // ✅ ADD TASK SECTION (NEW!)
  Widget _addTaskSection() {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.withOpacity(0.1), Colors.transparent],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add, color: Colors.white),
              ),
              const SizedBox(width: 12),
              const Text(
                "Add Study Task",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              hintText: "Task (e.g. Read ASC 314)",
              prefixIcon: const Icon(Icons.task),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _subjectController,
            decoration: InputDecoration(
              hintText: "Subject",
              prefixIcon: const Icon(Icons.book),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              onPressed: _addTask,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text(
                "Add Task",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dashboard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ Header (YOUR ORIGINAL)
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
                  "Good day, Daniela! 👋",
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

          // ✅ NEW ADD TASK SECTION
          _addTaskSection(),

          // ✅ Quick stats (YOUR ORIGINAL)
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

          // ✅ Task list (YOUR ORIGINAL)
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
                    color: Colors.black.withOpacity(0.04),
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
                      color: color.withOpacity(0.1),
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
    // ✅ YOUR PERFECT 4-TAB ORDER
    final pages = [
      _dashboard(), // 🏠 Home
      const LessonsScreen(), // 📚 Lessons
      const QuizScreen(), // 🧠 Quiz
      const Profile(), // 👤 Profile
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
            icon: Icon(Icons.menu_book_rounded),
            label: "Lessons",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.quiz_rounded),
            label: "Quiz",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: "Profile",
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subjectController.dispose();
    super.dispose();
  }
}
