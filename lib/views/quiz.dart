import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _current = 0;
  int _score = 0;
  int? _selected;

  final List<Map<String, dynamic>> questions = [
    {
      'question': 'What is 2 + 2?',
      'options': ['3', '4', '5', '6'],
      'answer': 1,
    },
    {
      'question': 'What planet is closest to the sun?',
      'options': ['Venus', 'Earth', 'Mercury', 'Mars'],
      'answer': 2,
    },
    {
      'question': 'What is the capital of France?',
      'options': ['Berlin', 'Madrid', 'Rome', 'Paris'],
      'answer': 3,
    },
    {
      'question': 'How many sides does a triangle have?',
      'options': ['2', '3', '4', '5'],
      'answer': 1,
    },
    {
      'question': 'What is H2O?',
      'options': ['Oxygen', 'Hydrogen', 'Water', 'Salt'],
      'answer': 2,
    },
  ];

  void _next() {
    if (_selected == null) return;
    if (_selected == questions[_current]['answer']) _score++;
    if (_current < questions.length - 1) {
      setState(() {
        _current++;
        _selected = null;
      });
    } else {
      Get.offNamed(
        '/result',
        arguments: {'score': _score, 'total': questions.length},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final subject = Get.arguments as Map<String, dynamic>? ?? {};
    final color = (subject['color'] as Color?) ?? Colors.green;
    final q = questions[_current];

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          "Quiz",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: color,
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress bar
            Row(
              children: [
                Text(
                  "Question ${_current + 1}/${questions.length}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const Spacer(),
                Text(
                  "Score: $_score",
                  style: TextStyle(fontWeight: FontWeight.bold, color: color),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: (_current + 1) / questions.length,
              backgroundColor: Colors.grey[200],
              color: color,
              minHeight: 6,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 30),

            // Question card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: color.withOpacity(0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: color.withOpacity(0.2)),
              ),
              child: Text(
                q['question'] as String,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Options
            ...List.generate(
              (q['options'] as List).length,
              (i) => GestureDetector(
                onTap: () => setState(() => _selected = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _selected == i
                        ? color.withOpacity(0.1)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _selected == i ? color : Colors.grey[200]!,
                      width: _selected == i ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 28,
                        width: 28,
                        decoration: BoxDecoration(
                          color: _selected == i ? color : Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            ['A', 'B', 'C', 'D'][i],
                            style: TextStyle(
                              color: _selected == i
                                  ? Colors.white
                                  : Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        (q['options'] as List)[i] as String,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: _selected == i
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: _selected == i ? color : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const Spacer(),

            // Next button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selected != null ? _next : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  disabledBackgroundColor: Colors.grey[300],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  _current < questions.length - 1 ? "Next Question" : "Submit",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
