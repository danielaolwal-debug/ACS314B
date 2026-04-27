import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LessonsScreen extends StatefulWidget {
  const LessonsScreen({super.key});

  @override
  State<LessonsScreen> createState() => _LessonsScreenState();
}

class _LessonsScreenState extends State<LessonsScreen> {
  List<Map<String, dynamic>> _units = [];

  final TextEditingController _unitNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUnits();
  }

  // ── Persist units + notes ────────────────────────────────────
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
  }

  Future<void> _saveUnits() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lesson_units', jsonEncode(_units));
  }

  // ── Add a new unit ───────────────────────────────────────────
  void _showAddUnitDialog() {
    _unitNameController.clear();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          "Add Unit",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: _unitNameController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: "e.g. ASC 314 - Data Structures",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () {
              final name = _unitNameController.text.trim();
              if (name.isNotEmpty) {
                setState(() {
                  _units.add({'name': name, 'notes': []});
                });
                _saveUnits();
                Navigator.pop(ctx);
              }
            },
            child: const Text("Add", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ── Delete a unit ────────────────────────────────────────────
  void _deleteUnit(int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Delete Unit?"),
        content: Text(
          "This will delete '${_units[index]['name']}' and all its notes.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              setState(() => _units.removeAt(index));
              _saveUnits();
              Navigator.pop(ctx);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          "My Lessons",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
        centerTitle: true,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddUnitDialog,
        backgroundColor: Colors.green,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          "Add Unit",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: _units.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.menu_book_rounded,
                    size: 72,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "No units yet",
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Tap '+ Add Unit' to create your first study unit",
                    style: TextStyle(color: Colors.grey[400], fontSize: 13),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: 100,
              ),
              itemCount: _units.length,
              itemBuilder: (ctx, i) {
                final unit = _units[i];
                final noteCount = (unit['notes'] as List).length;
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
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
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    leading: Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.menu_book,
                        color: Colors.green,
                        size: 26,
                      ),
                    ),
                    title: Text(
                      unit['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    subtitle: Text(
                      "$noteCount note${noteCount == 1 ? '' : 's'}",
                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                          ),
                          onPressed: () => _deleteUnit(i),
                        ),
                        const Icon(Icons.chevron_right, color: Colors.grey),
                      ],
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => UnitNotesScreen(
                          unitIndex: i,
                          unitName: unit['name'],
                          notes: List<Map<String, dynamic>>.from(unit['notes']),
                          onSave: (updatedNotes) {
                            setState(() {
                              _units[i]['notes'] = updatedNotes;
                            });
                            _saveUnits();
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  @override
  void dispose() {
    _unitNameController.dispose();
    super.dispose();
  }
}

// ══════════════════════════════════════════════════════════════
//  UNIT NOTES SCREEN — view & add notes for a specific unit
// ══════════════════════════════════════════════════════════════
class UnitNotesScreen extends StatefulWidget {
  final int unitIndex;
  final String unitName;
  final List<Map<String, dynamic>> notes;
  final Function(List<Map<String, dynamic>>) onSave;

  const UnitNotesScreen({
    super.key,
    required this.unitIndex,
    required this.unitName,
    required this.notes,
    required this.onSave,
  });

  @override
  State<UnitNotesScreen> createState() => _UnitNotesScreenState();
}

class _UnitNotesScreenState extends State<UnitNotesScreen> {
  late List<Map<String, dynamic>> _notes;

  final TextEditingController _titleCtrl = TextEditingController();
  final TextEditingController _contentCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _notes = List.from(widget.notes);
  }

  void _showAddNoteDialog({int? editIndex}) {
    if (editIndex != null) {
      _titleCtrl.text = _notes[editIndex]['title'];
      _contentCtrl.text = _notes[editIndex]['content'];
    } else {
      _titleCtrl.clear();
      _contentCtrl.clear();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              editIndex != null ? "Edit Note" : "Add Note",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _titleCtrl,
              decoration: InputDecoration(
                hintText: "Note title (e.g. Chapter 1 Summary)",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _contentCtrl,
              maxLines: 6,
              decoration: InputDecoration(
                hintText: "Write your notes here...",
                alignLabelWithHint: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  final title = _titleCtrl.text.trim();
                  final content = _contentCtrl.text.trim();
                  if (title.isNotEmpty && content.isNotEmpty) {
                    setState(() {
                      if (editIndex != null) {
                        _notes[editIndex] = {
                          'title': title,
                          'content': content,
                        };
                      } else {
                        _notes.insert(0, {'title': title, 'content': content});
                      }
                    });
                    widget.onSave(_notes);
                    Navigator.pop(ctx);
                  }
                },
                child: Text(
                  editIndex != null ? "Save Changes" : "Save Note",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteNote(int i) {
    setState(() => _notes.removeAt(i));
    widget.onSave(_notes);
  }

  // ── Full note reader ─────────────────────────────────────────
  void _readNote(Map<String, dynamic> note) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        maxChildSize: 0.95,
        builder: (_, scroll) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                note['title'],
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(height: 24),
              Expanded(
                child: SingleChildScrollView(
                  controller: scroll,
                  child: Text(
                    note['content'],
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.6,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          widget.unitName,
          style: const TextStyle(fontWeight: FontWeight.bold),
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: Colors.green,
        centerTitle: true,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddNoteDialog(),
        backgroundColor: Colors.green,
        icon: const Icon(Icons.note_add, color: Colors.white),
        label: const Text(
          "Add Note",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: _notes.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.note_outlined, size: 64, color: Colors.grey[300]),
                  const SizedBox(height: 12),
                  Text(
                    "No notes yet",
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Tap '+ Add Note' to start taking notes",
                    style: TextStyle(color: Colors.grey[400], fontSize: 13),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: 100,
              ),
              itemCount: _notes.length,
              itemBuilder: (ctx, i) {
                final note = _notes[i];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    leading: Container(
                      height: 44,
                      width: 44,
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.sticky_note_2,
                        color: Colors.green,
                      ),
                    ),
                    title: Text(
                      note['title'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    subtitle: Text(
                      note['content'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (val) {
                        if (val == 'edit') _showAddNoteDialog(editIndex: i);
                        if (val == 'delete') _deleteNote(i);
                      },
                      itemBuilder: (_) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit, size: 18),
                              SizedBox(width: 8),
                              Text("Edit"),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, size: 18, color: Colors.red),
                              SizedBox(width: 8),
                              Text(
                                "Delete",
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    onTap: () => _readNote(note),
                  ),
                );
              },
            ),
    );
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _contentCtrl.dispose();
    super.dispose();
  }
}
