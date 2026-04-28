import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LessonsScreen extends StatefulWidget {
  const LessonsScreen({super.key});
  @override
  State<LessonsScreen> createState() => _LessonsScreenState();
}

class _LessonsScreenState extends State<LessonsScreen> {
  List<Map<String, dynamic>> units = [];
  final nameCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    super.dispose();
  }

  Future<void> load() async {
    final p = await SharedPreferences.getInstance();
    final raw = p.getString('lesson_units');
    if (raw == null) return;
    final data = jsonDecode(raw) as List;
    setState(
      () => units = data
          .map(
            (u) => {
              'name': u['name'],
              'notes': List<Map<String, dynamic>>.from(u['notes']),
            },
          )
          .toList(),
    );
  }

  Future<void> save() async {
    final p = await SharedPreferences.getInstance();
    p.setString('lesson_units', jsonEncode(units));
  }

  void addUnit() {
    nameCtrl.clear();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Unit'),
        content: TextField(controller: nameCtrl),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final n = nameCtrl.text.trim();
              if (n.isEmpty) return;
              setState(() => units.add({'name': n, 'notes': []}));
              save();
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void deleteUnit(int i) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete?'),
        content: Text("Delete '${units[i]['name']}'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => units.removeAt(i));
              save();
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('My Lessons')),
    floatingActionButton: FloatingActionButton(
      onPressed: addUnit,
      child: const Icon(Icons.add),
    ),
    body: units.isEmpty
        ? const Center(child: Text('No units yet'))
        : ListView.builder(
            itemCount: units.length,
            itemBuilder: (_, i) {
              final u = units[i];
              final count = (u['notes'] as List).length;
              return ListTile(
                title: Text(u['name']),
                subtitle: Text('$count notes'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => deleteUnit(i),
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => UnitNotesScreen(
                      unitName: u['name'],
                      notes: List.from(u['notes']),
                      onSave: (n) {
                        setState(() => units[i]['notes'] = n);
                        save();
                      },
                    ),
                  ),
                ),
              );
            },
          ),
  );
}

// ───────────────────────────────

class UnitNotesScreen extends StatefulWidget {
  final String unitName;
  final List<Map<String, dynamic>> notes;
  final Function(List<Map<String, dynamic>>) onSave;

  const UnitNotesScreen({
    super.key,
    required this.unitName,
    required this.notes,
    required this.onSave,
  });

  @override
  State<UnitNotesScreen> createState() => _UnitNotesScreenState();
}

class _UnitNotesScreenState extends State<UnitNotesScreen> {
  late List<Map<String, dynamic>> notes;
  final tCtrl = TextEditingController();
  final cCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    notes = List.from(widget.notes);
  }

  @override
  void dispose() {
    tCtrl.dispose();
    cCtrl.dispose();
    super.dispose();
  }

  void noteSheet({int? i}) {
    if (i != null) {
      tCtrl.text = notes[i]['title'];
      cCtrl.text = notes[i]['content'];
    } else {
      tCtrl.clear();
      cCtrl.clear();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: tCtrl,
              decoration: const InputDecoration(hintText: 'Title'),
            ),
            TextField(
              controller: cCtrl,
              maxLines: 5,
              decoration: const InputDecoration(hintText: 'Content'),
            ),
            ElevatedButton(
              onPressed: () {
                final t = tCtrl.text.trim(), c = cCtrl.text.trim();
                if (t.isEmpty || c.isEmpty) return;
                setState(() {
                  if (i != null)
                    notes[i] = {'title': t, 'content': c};
                  else
                    notes.insert(0, {'title': t, 'content': c});
                });
                widget.onSave(notes);
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void delete(int i) {
    setState(() => notes.removeAt(i));
    widget.onSave(notes);
  }

  void read(Map n) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              n['title'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Expanded(child: SingleChildScrollView(child: Text(n['content']))),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(widget.unitName)),
    floatingActionButton: FloatingActionButton(
      onPressed: () => noteSheet(),
      child: const Icon(Icons.add),
    ),
    body: notes.isEmpty
        ? const Center(child: Text('No notes yet'))
        : ListView.builder(
            itemCount: notes.length,
            itemBuilder: (_, i) {
              final n = notes[i];
              return ListTile(
                title: Text(n['title']),
                subtitle: Text(
                  n['content'],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () => read(n),
                trailing: PopupMenuButton(
                  onSelected: (v) {
                    if (v == 'e') noteSheet(i: i);
                    if (v == 'd') delete(i);
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'e', child: Text('Edit')),
                    PopupMenuItem(value: 'd', child: Text('Delete')),
                  ],
                ),
              );
            },
          ),
  );
}
