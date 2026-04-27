import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Map<String, dynamic>> _units = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadUnits();
  }

  Future<void> _loadUnits() async {
    final prefs = await SharedPreferences.getInstance();
    final String? raw = prefs.getString('lesson_units');
    if (raw != null) {
      final List decoded = jsonDecode(raw);
      setState(() {
        _units = decoded
            .map<Map<String, dynamic>>(
              (u) => {
                'name': u['name'],
                'notes': List<Map<String, dynamic>>.from(
                  (u['notes'] as List).map(
                    (n) => {'title': n['title'], 'content': n['content']},
                  ),
                ),
              },
            )
            .toList();
      });
    }
    setState(() => _loading = false);
  }

  int get _totalNotes =>
      _units.fold(0, (sum, u) => sum + (u['notes'] as List).length);

  final List<Color> _colors = [
    Colors.green,
    Colors.blue,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.red,
  ];

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Colors.green)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          "Quiz",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
        centerTitle: true,
        elevation: 0,
      ),
      body: _units.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.quiz_outlined, size: 72, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text(
                    "No lessons yet",
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      "Go to Lessons, add units and notes — then come back to test yourself!",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[400], fontSize: 13),
                    ),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Mixed quiz card ───────────────────────────
                  if (_totalNotes >= 1) ...[
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF2E7D32), Color(0xFF66BB6A)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.auto_awesome,
                            color: Colors.white,
                            size: 36,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Mixed Quiz",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "10–15 varied questions from all lessons",
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.85),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ActiveQuizScreen(
                                  unitName: "Mixed Quiz",
                                  allUnits: _units,
                                  color: Colors.green,
                                  isMixed: true,
                                ),
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                            ),
                            child: const Text(
                              "Start",
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 12),
                      child: Text(
                        "Quiz by Unit",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],

                  // ── Per-unit cards ────────────────────────────
                  ..._units.asMap().entries.map((entry) {
                    final i = entry.key;
                    final unit = entry.value;
                    final color = _colors[i % _colors.length];
                    final noteCount = (unit['notes'] as List).length;
                    final canQuiz = noteCount >= 1;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              height: 54,
                              width: 54,
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(
                                Icons.menu_book,
                                color: color,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    unit['name'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    canQuiz
                                        ? "$noteCount note${noteCount == 1 ? '' : 's'} · 10–15 questions generated"
                                        : "Add at least 1 note to quiz",
                                    style: TextStyle(
                                      color: canQuiz
                                          ? Colors.grey[500]
                                          : Colors.orange,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              onPressed: canQuiz
                                  ? () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => ActiveQuizScreen(
                                          unitName: unit['name'],
                                          allUnits: [unit],
                                          color: color,
                                          isMixed: false,
                                        ),
                                      ),
                                    )
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: color,
                                disabledBackgroundColor: Colors.grey[200],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                              ),
                              child: const Text(
                                "Start",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  ACTIVE QUIZ SCREEN
// ══════════════════════════════════════════════════════════════
class ActiveQuizScreen extends StatefulWidget {
  final String unitName;
  final List<Map<String, dynamic>> allUnits;
  final Color color;
  final bool isMixed;

  const ActiveQuizScreen({
    super.key,
    required this.unitName,
    required this.allUnits,
    required this.color,
    required this.isMixed,
  });

  @override
  State<ActiveQuizScreen> createState() => _ActiveQuizScreenState();
}

class _ActiveQuizScreenState extends State<ActiveQuizScreen> {
  late List<Map<String, dynamic>> _questions;
  int _current = 0;
  int _score = 0;
  int? _selected;
  bool _answered = false;

  @override
  void initState() {
    super.initState();
    _questions = _buildQuestions();
  }

  // ── Flatten all notes ────────────────────────────────────────
  List<Map<String, dynamic>> _allNotes() {
    final all = <Map<String, dynamic>>[];
    for (final unit in widget.allUnits) {
      for (final note in (unit['notes'] as List)) {
        all.add({
          'unitName': unit['name'] as String,
          'title': note['title'] as String,
          'content': note['content'] as String,
        });
      }
    }
    return all;
  }

  // ── Extract sentences from a note's content ──────────────────
  List<String> _sentences(String content) {
    final parts = content
        .split(RegExp(r'(?<=[.!?])\s+|\n+'))
        .map((s) => s.trim())
        .where((s) => s.length > 15)
        .toList();
    if (parts.isEmpty) return [content.trim()];
    return parts;
  }

  String _truncate(String text, int max) {
    text = text.trim();
    return text.length > max ? '${text.substring(0, max)}...' : text;
  }

  // ── The key fix: generate MULTIPLE question types per note ───
  // This means even 2 notes can produce 10+ varied questions
  List<Map<String, dynamic>> _buildQuestions() {
    final rand = Random();
    final allNotes = _allNotes()..shuffle(rand);

    if (allNotes.isEmpty) return [];

    // Pool of all first sentences for wrong answers
    final allFirstSentences = allNotes
        .map((n) => _truncate(_sentences(n['content'] as String).first, 100))
        .toList();

    // We'll collect ALL possible questions then pick 10-15
    final pool = <Map<String, dynamic>>[];

    // ── Question templates by TYPE ───────────────────────────
    // Type 1: "What do your notes say about X?" → answer = first sentence
    // Type 2: "Which title matches this description?" → answer = note title
    // Type 3: "Which unit covers X?" → answer = unit name
    // Type 4: True/False style → answer = correct sentence vs distractor
    // Type 5: Second sentence question (if note has 2+ sentences)

    for (final note in allNotes) {
      final title = note['title'] as String;
      final content = note['content'] as String;
      final unitName = note['unitName'] as String;
      final sentences = _sentences(content);
      final firstSentence = _truncate(sentences.first, 100);

      // Wrong answer pool: first sentences from OTHER notes
      final otherSentences =
          allNotes
              .where((n) => n['title'] != title)
              .map(
                (n) => _truncate(_sentences(n['content'] as String).first, 100),
              )
              .toList()
            ..shuffle(rand);

      // Fallback wrong answers
      final fallbacks = [
        'This is not covered in the $unitName notes',
        'Refers to a different concept entirely',
        'This applies to a separate unit',
        'Not recorded in your study notes',
        'This topic belongs to another subject area',
      ];

      List<String> _buildWrongOptions(String correct) {
        final wrong = <String>[];
        final used = <String>{correct};
        for (final s in otherSentences) {
          if (wrong.length >= 3) break;
          if (!used.contains(s)) {
            wrong.add(s);
            used.add(s);
          }
        }
        for (final f in fallbacks) {
          if (wrong.length >= 3) break;
          if (!used.contains(f)) {
            wrong.add(f);
            used.add(f);
          }
        }
        return wrong;
      }

      List<String> _shuffle(List<String> correct, List<String> wrong) {
        final opts = [correct.first, ...wrong.take(3)]..shuffle(rand);
        return opts;
      }

      // ── TYPE 1: What do notes say about [title]? ────────────
      {
        final wrong = _buildWrongOptions(firstSentence);
        final opts = _shuffle([firstSentence], wrong);
        pool.add({
          'question': 'What do your notes say about "$title"?',
          'options': opts,
          'answer': opts.indexOf(firstSentence),
          'unitName': unitName,
        });
      }

      // ── TYPE 2: According to notes, what is [title]? ────────
      {
        final wrong = _buildWrongOptions(firstSentence);
        final opts = _shuffle([firstSentence], wrong);
        pool.add({
          'question': 'According to your $unitName notes, what is "$title"?',
          'options': opts,
          'answer': opts.indexOf(firstSentence),
          'unitName': unitName,
        });
      }

      // ── TYPE 3: Which best describes [title]? ───────────────
      {
        final wrong = _buildWrongOptions(firstSentence);
        final opts = _shuffle([firstSentence], wrong);
        pool.add({
          'question': 'Which of the following best describes "$title"?',
          'options': opts,
          'answer': opts.indexOf(firstSentence),
          'unitName': unitName,
        });
      }

      // ── TYPE 4: Which title matches this description? ────────
      // Correct = note title, wrong = other note titles
      if (allNotes.length >= 2) {
        final otherTitles =
            allNotes
                .where((n) => n['title'] != title)
                .map((n) => n['title'] as String)
                .toList()
              ..shuffle(rand);

        final wrongTitles = otherTitles.take(3).toList();
        while (wrongTitles.length < 3) {
          wrongTitles.add('None of the above');
        }

        final opts = [title, ...wrongTitles]..shuffle(rand);
        pool.add({
          'question':
              'This description — "${_truncate(firstSentence, 70)}" — belongs to which note?',
          'options': opts,
          'answer': opts.indexOf(title),
          'unitName': unitName,
        });
      }

      // ── TYPE 5: Second sentence question (if available) ──────
      if (sentences.length >= 2) {
        final secondSentence = _truncate(sentences[1], 100);
        if (secondSentence != firstSentence) {
          final wrong = _buildWrongOptions(secondSentence);
          final opts = _shuffle([secondSentence], wrong);
          pool.add({
            'question':
                'From your notes on "$title", which statement is also true?',
            'options': opts,
            'answer': opts.indexOf(secondSentence),
            'unitName': unitName,
          });
        }
      }

      // ── TYPE 6: Select the correct description ───────────────
      {
        final wrong = _buildWrongOptions(firstSentence);
        final opts = _shuffle([firstSentence], wrong);
        pool.add({
          'question': 'Select the correct description of "$title":',
          'options': opts,
          'answer': opts.indexOf(firstSentence),
          'unitName': unitName,
        });
      }
    }

    // Shuffle pool and pick 10–15 questions
    pool.shuffle(rand);
    final targetCount = pool.length.clamp(1, 15);
    // Try to get at least 10 if pool is big enough
    final finalCount = pool.length >= 10
        ? 10 + rand.nextInt((pool.length - 10).clamp(1, 6))
        : targetCount;

    return pool.take(finalCount).toList();
  }

  void _select(int i) {
    if (_answered) return;
    setState(() {
      _selected = i;
      _answered = true;
      if (i == _questions[_current]['answer']) _score++;
    });
  }

  void _next() {
    if (_current < _questions.length - 1) {
      setState(() {
        _current++;
        _selected = null;
        _answered = false;
      });
    } else {
      _showResult();
    }
  }

  void _showResult() {
    final total = _questions.length;
    final pct = ((_score / total) * 100).toInt();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Icon(
              pct >= 70 ? Icons.emoji_events : Icons.refresh,
              size: 64,
              color: pct >= 70 ? Colors.amber : Colors.orange,
            ),
            const SizedBox(height: 16),
            Text(
              pct >= 70 ? "Great Job! 🎉" : "Keep Studying! 💪",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "You scored $_score / $total ($pct%)",
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      Navigator.pop(context);
                    },
                    child: const Text("Done"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.color,
                    ),
                    onPressed: () {
                      Navigator.pop(ctx);
                      setState(() {
                        _questions = _buildQuestions();
                        _current = 0;
                        _score = 0;
                        _selected = null;
                        _answered = false;
                      });
                    },
                    child: const Text(
                      "Retry",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.unitName),
          backgroundColor: widget.color,
        ),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              "Not enough notes to generate a quiz.\nAdd at least 1 note in Lessons first.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      );
    }

    final q = _questions[_current];
    final options = q['options'] as List<String>;
    final correctIdx = q['answer'] as int;
    final color = widget.color;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          widget.unitName,
          style: const TextStyle(fontWeight: FontWeight.bold),
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: color,
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Progress ──────────────────────────────────────
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Question ${_current + 1} of ${_questions.length}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    if (widget.isMixed)
                      Text(
                        "Unit: ${q['unitName']}",
                        style: TextStyle(
                          fontSize: 11,
                          color: color,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "Score: $_score",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: color,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: (_current + 1) / _questions.length,
                backgroundColor: Colors.grey[200],
                color: color,
                minHeight: 7,
              ),
            ),
            const SizedBox(height: 24),

            // ── Question card ─────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: color.withOpacity(0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: color.withOpacity(0.2)),
              ),
              child: Text(
                q['question'] as String,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ── Options ───────────────────────────────────────
            ...List.generate(options.length, (i) {
              Color? bg;
              Color borderColor = Colors.grey[200]!;
              if (_answered) {
                if (i == correctIdx) {
                  bg = Colors.green[50];
                  borderColor = Colors.green;
                } else if (i == _selected && i != correctIdx) {
                  bg = Colors.red[50];
                  borderColor = Colors.red;
                }
              } else if (_selected == i) {
                bg = color.withOpacity(0.08);
                borderColor = color;
              }

              return GestureDetector(
                onTap: () => _select(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: bg ?? Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: borderColor,
                      width: _selected == i ? 2 : 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 28,
                        width: 28,
                        decoration: BoxDecoration(
                          color: _answered && i == correctIdx
                              ? Colors.green
                              : (_answered && i == _selected && i != correctIdx
                                    ? Colors.red
                                    : (_selected == i
                                          ? color
                                          : Colors.grey[100]!)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            ['A', 'B', 'C', 'D'][i],
                            style: TextStyle(
                              color:
                                  (_selected == i ||
                                      (_answered && i == correctIdx))
                                  ? Colors.white
                                  : Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          options[i],
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.4,
                            fontWeight: _selected == i
                                ? FontWeight.w600
                                : FontWeight.normal,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      if (_answered && i == correctIdx)
                        const Padding(
                          padding: EdgeInsets.only(left: 8, top: 4),
                          child: Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 20,
                          ),
                        ),
                      if (_answered && i == _selected && i != correctIdx)
                        const Padding(
                          padding: EdgeInsets.only(left: 8, top: 4),
                          child: Icon(
                            Icons.cancel,
                            color: Colors.red,
                            size: 20,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }),

            const SizedBox(height: 8),

            if (_answered)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _next,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    _current < _questions.length - 1
                        ? "Next Question →"
                        : "See Results",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
