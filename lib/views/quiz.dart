import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ── Quiz selection screen ─────────────────────────────────────
class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});
  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Map<String, dynamic>> _units = [];
  bool _loading = true;

  // Colors assigned to each unit card
  final _colors = [
    Colors.green,
    Colors.blue,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.red,
  ];

  @override
  void initState() {
    super.initState();
    _loadUnits(); // read saved units from storage
  }

  // ── Load units from SharedPreferences ────────────────────
  Future<void> _loadUnits() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('lesson_units');
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

  // Total notes across all units (used to enable Mixed Quiz)
  int get _total => _units.fold(0, (s, u) => s + (u['notes'] as List).length);

  // ── Navigate into the active quiz screen ──────────────────
  void _start(
    String name,
    List<Map<String, dynamic>> units,
    Color color,
    bool mixed,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ActiveQuizScreen(
          unitName: name,
          allUnits: units,
          color: color,
          isMixed: mixed,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Show spinner while loading units from storage
    if (_loading)
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Colors.green)),
      );

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Quiz',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: _units.isEmpty
          // Empty state — user hasn't added any lessons yet
          ? const Center(
              child: Text(
                'No lessons yet.\nGo to Lessons, add notes, then come back!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 15),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // ── Mixed Quiz card (shown when notes exist) ───
                if (_total >= 1) ...[
                  Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF2E7D32), Color(0xFF66BB6A)],
                      ),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.auto_awesome,
                          color: Colors.white,
                          size: 36,
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Mixed Quiz',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '10–15 questions from all lessons',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Start the mixed quiz with all units
                        ElevatedButton(
                          onPressed: () =>
                              _start('Mixed Quiz', _units, Colors.green, true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                          ),
                          child: const Text(
                            'Start',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Text(
                    'Quiz by Unit',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                ],

                // ── One card per unit ──────────────────────────
                ..._units.asMap().entries.map((e) {
                  final i = e.key;
                  final unit = e.value;
                  final color = _colors[i % _colors.length];
                  final count = (unit['notes'] as List).length;
                  final ok = count >= 1; // can only quiz if notes exist

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          // Colored icon
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(Icons.menu_book, color: color),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  unit['name'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                // Different hint based on whether notes exist
                                Text(
                                  ok
                                      ? '$count note${count == 1 ? '' : 's'} · quiz ready'
                                      : 'Add at least 1 note to quiz',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: ok ? Colors.grey : Colors.orange,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Start button — disabled if no notes
                          ElevatedButton(
                            onPressed: ok
                                ? () =>
                                      _start(unit['name'], [unit], color, false)
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: color,
                              disabledBackgroundColor: Colors.grey[200],
                            ),
                            child: const Text(
                              'Start',
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
    );
  }
}

// ════════════════════════════════════════════════════════════
//  ACTIVE QUIZ SCREEN
// ════════════════════════════════════════════════════════════
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
  int _current = 0; // index of current question
  int _score = 0; // number of correct answers
  int? _selected; // index of option the user tapped
  bool _answered = false; // whether an answer has been given

  @override
  void initState() {
    super.initState();
    _questions = _build(); // generate questions when screen opens
  }

  // ── Flatten all notes from all units into one list ────────
  List<Map<String, dynamic>> _allNotes() {
    final all = <Map<String, dynamic>>[];
    for (final unit in widget.allUnits) {
      for (final note in (unit['notes'] as List)) {
        all.add({
          'unitName': unit['name'],
          'title': note['title'],
          'content': note['content'],
        });
      }
    }
    return all;
  }

  // ── Split a note's content into sentences ─────────────────
  List<String> _sentences(String content) {
    final parts = content
        .split(RegExp(r'(?<=[.!?])\s+|\n+'))
        .map((s) => s.trim())
        .where((s) => s.length > 15) // ignore very short fragments
        .toList();
    return parts.isEmpty ? [content.trim()] : parts;
  }

  // ── Trim long text to max characters ─────────────────────
  String _trunc(String t, int max) =>
      t.length > max ? '${t.substring(0, max)}...' : t.trim();

  // ── Build the list of quiz questions ─────────────────────
  List<Map<String, dynamic>> _build() {
    final rand = Random();
    final notes = _allNotes()..shuffle(rand);
    if (notes.isEmpty) return [];

    final pool = <Map<String, dynamic>>[];

    for (final note in notes) {
      final title = note['title'] as String;
      final content = note['content'] as String;
      final unit = note['unitName'] as String;
      final sents = _sentences(content);
      final first = _trunc(sents.first, 100);

      // Wrong answers = first sentences from other notes
      final others =
          notes
              .where((n) => n['title'] != title)
              .map((n) => _trunc(_sentences(n['content']).first, 100))
              .toList()
            ..shuffle(rand);

      // Fallback wrong answers if not enough other notes
      final fallbacks = [
        'Not covered in $unit notes',
        'Refers to a different concept',
        'This applies to a separate unit',
        'Not in your study notes',
      ];

      // Build 3 unique wrong options for a question
      List<String> wrongs(String correct) {
        final w = <String>[], used = {correct};
        for (final s in [...others, ...fallbacks]) {
          if (w.length >= 3) break;
          if (!used.contains(s)) {
            w.add(s);
            used.add(s);
          }
        }
        return w;
      }

      // Combine correct + 3 wrong, then shuffle
      List<String> opts(String correct) =>
          [correct, ...wrongs(correct)]..shuffle(rand);

      // ── Generate 6 question types per note ────────────────
      // Type 1: What do notes say about [title]?
      var o = opts(first);
      pool.add({
        'question': 'What do your notes say about "$title"?',
        'options': o,
        'answer': o.indexOf(first),
        'unitName': unit,
      });

      // Type 2: According to [unit], what is [title]?
      o = opts(first);
      pool.add({
        'question': 'According to $unit notes, what is "$title"?',
        'options': o,
        'answer': o.indexOf(first),
        'unitName': unit,
      });

      // Type 3: Which best describes [title]?
      o = opts(first);
      pool.add({
        'question': 'Which best describes "$title"?',
        'options': o,
        'answer': o.indexOf(first),
        'unitName': unit,
      });

      // Type 4: Which note title matches this description?
      if (notes.length >= 2) {
        final otherTitles = notes
            .where((n) => n['title'] != title)
            .map((n) => n['title'] as String)
            .take(3)
            .toList();
        while (otherTitles.length < 3) otherTitles.add('None of the above');
        final to = [title, ...otherTitles]..shuffle(rand);
        pool.add({
          'question': '"${_trunc(first, 70)}" — which note is this from?',
          'options': to,
          'answer': to.indexOf(title),
          'unitName': unit,
        });
      }

      // Type 5: Second sentence question (if note has more content)
      if (sents.length >= 2) {
        final second = _trunc(sents[1], 100);
        if (second != first) {
          o = opts(second);
          pool.add({
            'question': 'From notes on "$title", which is also true?',
            'options': o,
            'answer': o.indexOf(second),
            'unitName': unit,
          });
        }
      }

      // Type 6: Select the correct description
      o = opts(first);
      pool.add({
        'question': 'Select the correct description of "$title":',
        'options': o,
        'answer': o.indexOf(first),
        'unitName': unit,
      });
    }

    // Shuffle all generated questions, then pick 10–15
    pool.shuffle(rand);
    final count = pool.length >= 10
        ? 10 + rand.nextInt((pool.length - 10).clamp(1, 6))
        : pool.length.clamp(1, 15);
    return pool.take(count).toList();
  }

  // ── Handle option tap ─────────────────────────────────────
  void _select(int i) {
    if (_answered) return; // ignore taps after answering
    setState(() {
      _selected = i;
      _answered = true;
      // Increment score if correct
      if (i == _questions[_current]['answer']) _score++;
    });
  }

  // ── Move to next question or show results ─────────────────
  void _next() {
    if (_current < _questions.length - 1) {
      setState(() {
        _current++;
        _selected = null;
        _answered = false;
      });
    } else {
      _result();
    }
  }

  // ── Show score dialog at the end ──────────────────────────
  void _result() {
    final pct = ((_score / _questions.length) * 100).toInt();
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap a button
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Trophy if ≥70%, otherwise refresh icon
            Icon(
              pct >= 70 ? Icons.emoji_events : Icons.refresh,
              size: 64,
              color: pct >= 70 ? Colors.amber : Colors.orange,
            ),
            const SizedBox(height: 12),
            Text(
              pct >= 70 ? 'Great Job! 🎉' : 'Keep Studying! 💪',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Score: $_score/${_questions.length} ($pct%)',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                // Done button — closes quiz
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      Navigator.pop(context);
                    },
                    child: const Text('Done'),
                  ),
                ),
                const SizedBox(width: 12),
                // Retry button — regenerates questions
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.color,
                    ),
                    onPressed: () {
                      Navigator.pop(ctx);
                      setState(() {
                        _questions = _build();
                        _current = 0;
                        _score = 0;
                        _selected = null;
                        _answered = false;
                      });
                    },
                    child: const Text(
                      'Retry',
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

  // ── Quiz UI ───────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    // No questions generated — not enough notes
    if (_questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.unitName),
          backgroundColor: widget.color,
        ),
        body: const Center(
          child: Text(
            'Add at least 1 note in Lessons to start a quiz.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final q = _questions[_current];
    final options = q['options'] as List<String>;
    final correct = q['answer'] as int;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          widget.unitName,
          style: const TextStyle(fontWeight: FontWeight.bold),
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: widget.color,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Progress row ───────────────────────────────────
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Question ${_current + 1} of ${_questions.length}',
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    // Show unit name in mixed quiz mode
                    if (widget.isMixed)
                      Text(
                        'Unit: ${q['unitName']}',
                        style: TextStyle(color: widget.color, fontSize: 11),
                      ),
                  ],
                ),
                const Spacer(),
                // Score badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: widget.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Score: $_score',
                    style: TextStyle(
                      color: widget.color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Progress bar fills as questions are answered
            LinearProgressIndicator(
              value: (_current + 1) / _questions.length,
              backgroundColor: Colors.grey[200],
              color: widget.color,
              minHeight: 7,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 20),

            // ── Question card ──────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: widget.color.withOpacity(0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: widget.color.withOpacity(0.2)),
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
            const SizedBox(height: 16),

            // ── Answer options A B C D ─────────────────────────
            ...List.generate(options.length, (i) {
              // Determine background and border colour based on state
              Color? bg;
              Color border = Colors.grey[200]!;
              if (_answered) {
                if (i == correct) {
                  bg = Colors.green[50];
                  border = Colors.green;
                } else if (i == _selected) {
                  bg = Colors.red[50];
                  border = Colors.red;
                }
              } else if (_selected == i) {
                bg = widget.color.withOpacity(0.08);
                border = widget.color;
              }

              return GestureDetector(
                onTap: () => _select(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: bg ?? Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: border,
                      width: _selected == i ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      // A/B/C/D label box
                      Container(
                        height: 28,
                        width: 28,
                        decoration: BoxDecoration(
                          color: _answered && i == correct
                              ? Colors.green
                              : _answered && i == _selected
                              ? Colors.red
                              : _selected == i
                              ? widget.color
                              : Colors.grey[100]!,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            ['A', 'B', 'C', 'D'][i],
                            style: TextStyle(
                              color:
                                  (_selected == i ||
                                      (_answered && i == correct))
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
                            fontWeight: _selected == i
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                      // Tick for correct, cross for wrong
                      if (_answered && i == correct)
                        const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 20,
                        ),
                      if (_answered && i == _selected && i != correct)
                        const Icon(Icons.cancel, color: Colors.red, size: 20),
                    ],
                  ),
                ),
              );
            }),

            const SizedBox(height: 8),
            // Next/Results button appears only after answering
            if (_answered)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _next,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.color,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    _current < _questions.length - 1
                        ? 'Next Question →'
                        : 'See Results',
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
