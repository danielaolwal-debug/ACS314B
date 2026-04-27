import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'lessons.dart';
import 'quiz.dart';
import 'profile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();

  List<Map<String, dynamic>> _tasks = [];

  // ── Color palette for tasks ─────────────────────────────────
  final List<Color> _taskColors = [
    Colors.green,
    Colors.blue,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.red,
  ];
  int _colorIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  // ── Persist tasks ───────────────────────────────────────────
  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? raw = prefs.getString('tasks');
    if (raw != null) {
      final List decoded = jsonDecode(raw);
      setState(() {
        _tasks = decoded.map<Map<String, dynamic>>((t) {
          return {
            'title': t['title'],
            'subject': t['subject'],
            'done': t['done'],
            'colorIndex': t['colorIndex'] ?? 0,
          };
        }).toList();
      });
    }
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(
      _tasks.map((t) {
        return {
          'title': t['title'],
          'subject': t['subject'],
          'done': t['done'],
          'colorIndex': t['colorIndex'],
        };
      }).toList(),
    );
    await prefs.setString('tasks', encoded);
  }

  void _addTask() {
    if (_titleController.text.trim().isNotEmpty &&
        _subjectController.text.trim().isNotEmpty) {
      setState(() {
        _tasks.insert(0, {
          'title': _titleController.text.trim(),
          'subject': _subjectController.text.trim(),
          'done': false,
          'colorIndex': _colorIndex % _taskColors.length,
        });
        _colorIndex++;
        _titleController.clear();
        _subjectController.clear();
      });
      _saveTasks();
    }
  }

  void _toggleTask(int i) {
    setState(() => _tasks[i]['done'] = !_tasks[i]['done']);
    _saveTasks();
  }

  // ── Only completed tasks can be removed by the user ────────
  void _removeTask(int i) {
    if (_tasks[i]['done'] == true) {
      setState(() => _tasks.removeAt(i));
      _saveTasks();
    } else {
      Get.snackbar(
        "Can't Remove",
        "Complete the task first before removing it",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  double get progress {
    int done = _tasks.where((t) => t['done']).length;
    return _tasks.isEmpty ? 0 : done / _tasks.length;
  }

  // ── Add Task Section ────────────────────────────────────────
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
          // ── Header ────────────────────────────────────────────
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
                  "Good day! 👋",
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
                      "${_tasks.where((t) => t['done']).length} of ${_tasks.length} tasks done",
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

          // ── Add Task ──────────────────────────────────────────
          _addTaskSection(),

          // ── Task List ─────────────────────────────────────────
          const Text(
            "Today's Tasks",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          if (_tasks.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Column(
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 56,
                      color: Colors.grey[300],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "No tasks yet — add one above!",
                      style: TextStyle(color: Colors.grey[400], fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),

          ..._tasks.asMap().entries.map((entry) {
            int i = entry.key;
            final task = entry.value;
            final color =
                _taskColors[(task['colorIndex'] as int) % _taskColors.length];
            return Dismissible(
              key: Key('${task['title']}_$i'),
              direction: task['done'] == true
                  ? DismissDirection.endToStart
                  : DismissDirection.none,
              onDismissed: (_) => _removeTask(i),
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.red[100],
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.delete, color: Colors.red),
              ),
              child: Container(
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
                          if (task['done'] == true)
                            const Text(
                              "Swipe left to remove",
                              style: TextStyle(color: Colors.red, fontSize: 10),
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
              ),
            );
          }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _dashboard(),
      const LessonsScreen(),
      const QuizScreen(),
      const Profile(),
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
