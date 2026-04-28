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
  int _index = 0; // tracks which bottom nav tab is active

  final _titleCtrl = TextEditingController();
  final _subjectCtrl = TextEditingController();

  List<Map<String, dynamic>> _tasks = [];

  // Color cycle for task cards
  final _colors = [
    Colors.green,
    Colors.blue,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.red,
  ];
  int _colorIdx = 0;

  @override
  void initState() {
    super.initState();
    _loadTasks(); // load saved tasks when screen opens
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _subjectCtrl.dispose();
    super.dispose();
  }

  // ── Load tasks from local storage ────────────────────────
  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('tasks');
    if (raw != null) {
      final List decoded = jsonDecode(raw);
      setState(() {
        _tasks = decoded
            .map<Map<String, dynamic>>(
              (t) => {
                'title': t['title'],
                'subject': t['subject'],
                'done': t['done'],
                'colorIndex': t['colorIndex'] ?? 0,
              },
            )
            .toList();
      });
    }
  }

  // ── Save tasks to local storage ───────────────────────────
  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('tasks', jsonEncode(_tasks));
  }

  // ── Add a new task to the top of the list ────────────────
  void _add() {
    if (_titleCtrl.text.trim().isEmpty || _subjectCtrl.text.trim().isEmpty)
      return;
    setState(() {
      _tasks.insert(0, {
        'title': _titleCtrl.text.trim(),
        'subject': _subjectCtrl.text.trim(),
        'done': false,
        'colorIndex': _colorIdx++ % _colors.length, // cycle through colors
      });
      _titleCtrl.clear();
      _subjectCtrl.clear();
    });
    _save();
  }

  // ── Toggle task done/undone ───────────────────────────────
  void _toggle(int i) {
    setState(() => _tasks[i]['done'] = !_tasks[i]['done']);
    _save();
  }

  // ── Remove task — only if already completed ───────────────
  void _remove(int i) {
    if (_tasks[i]['done'] != true) {
      Get.snackbar(
        'Can\'t Remove',
        'Complete the task first',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }
    setState(() => _tasks.removeAt(i));
    _save();
  }

  // Percentage of tasks completed (used by progress bar)
  double get _progress => _tasks.isEmpty
      ? 0
      : _tasks.where((t) => t['done']).length / _tasks.length;

  // ── Dashboard tab UI ──────────────────────────────────────
  Widget _dashboard() => SingleChildScrollView(
    padding: const EdgeInsets.all(20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Header banner with progress ──────────────────────
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF2E7D32), Color(0xFF66BB6A)],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Good day! ', style: TextStyle(color: Colors.white70)),
              const Text(
                'Let\'s keep learning!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              // Shows how many tasks are done out of total
              Text(
                '${_tasks.where((t) => t['done']).length}/${_tasks.length} tasks · ${(_progress * 100).toInt()}%',
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 6),
              // Progress bar fills based on completed tasks
              LinearProgressIndicator(
                value: _progress,
                backgroundColor: Colors.white30,
                color: Colors.white,
                minHeight: 8,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // ── Add task section ─────────────────────────────────
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.green.withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add Study Task',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),
              // Task title input
              TextField(
                controller: _titleCtrl,
                decoration: _inputDecor('Task (e.g. Read ASC 314)', Icons.task),
              ),
              const SizedBox(height: 10),
              // Subject input
              TextField(
                controller: _subjectCtrl,
                decoration: _inputDecor('Subject', Icons.book),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _add,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text(
                    'Add Task',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // ── Task list heading ─────────────────────────────────
        const Text(
          "Today's Tasks",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),

        // Empty state shown when no tasks exist
        if (_tasks.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Text(
                'No tasks yet — add one above!',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),

        // ── Task list items ───────────────────────────────────
        ..._tasks.asMap().entries.map((e) {
          final i = e.key;
          final task = e.value;
          final color = _colors[(task['colorIndex'] as int) % _colors.length];

          return Dismissible(
            key: Key('${task['title']}_$i'),
            // Only completed tasks can be swiped away
            direction: task['done'] == true
                ? DismissDirection.endToStart
                : DismissDirection.none,
            onDismissed: (_) => _remove(i),
            // Red delete background revealed on swipe
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
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Colored icon on the left
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
                        // Strike-through text when done
                        Text(
                          task['title'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            decoration: task['done']
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                            color: task['done'] ? Colors.grey : Colors.black,
                          ),
                        ),
                        Text(
                          task['subject'],
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
                          ),
                        ),
                        // Hint shown only on completed tasks
                        if (task['done'] == true)
                          const Text(
                            'Swipe left to remove',
                            style: TextStyle(color: Colors.red, fontSize: 10),
                          ),
                      ],
                    ),
                  ),
                  // Checkbox to mark done/undone
                  Checkbox(
                    value: task['done'],
                    activeColor: color,
                    onChanged: (_) => _toggle(i),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    ),
  );

  // ── Input field decoration helper ─────────────────────────
  InputDecoration _inputDecor(String hint, IconData icon) => InputDecoration(
    hintText: hint,
    prefixIcon: Icon(icon),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    filled: true,
    fillColor: Colors.white,
  );

  // ── Main build ────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    // 4 pages mapped to bottom nav tabs
    final pages = [
      _dashboard(),
      const LessonsScreen(),
      const QuizScreen(),
      const Profile(),
    ];

    return Scaffold(
      // IndexedStack keeps all pages alive — only shows the active one
      body: SafeArea(
        child: IndexedStack(index: _index, children: pages),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i), // switch active tab
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_rounded),
            label: 'Lessons',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.quiz_rounded),
            label: 'Quiz',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
