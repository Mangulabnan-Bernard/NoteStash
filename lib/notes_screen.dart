import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'note_detail_screen.dart';

class NotesScreen extends StatefulWidget {
  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  late Box box;
  List<dynamic> notes = [];
  bool isAscending = true;
  bool isGridView = false;

  @override
  void initState() {
    super.initState();
    box = Hive.box('appdata');
    notes = box.get('notes') ?? [];
  }

  void _addNote(Map<String, dynamic> noteData) {
    setState(() {
      notes.add({
        "content": noteData["content"],
        "created": DateTime.now().toIso8601String(),
        "textColor": noteData["textColor"],
        "fontSize": noteData["fontSize"],
        "textAlign": noteData["textAlign"],
      });
      box.put('notes', notes);
    });
  }

  void _deleteNote(int index) {
    setState(() {
      notes.removeAt(index);
      box.put('notes', notes);
    });
  }

  void _updateNote(int index, Map<String, dynamic> noteData) {
    setState(() {
      notes[index] = {
        ...notes[index],
        "content": noteData["content"],
        "textColor": noteData["textColor"],
        "fontSize": noteData["fontSize"],
        "textAlign": noteData["textAlign"],
      };
      box.put('notes', notes);
    });
  }

  void _sortNotes() {
    setState(() {
      notes.sort((a, b) {
        DateTime dateA = DateTime.parse(a['created'] ?? DateTime.now().toIso8601String());
        DateTime dateB = DateTime.parse(b['created'] ?? DateTime.now().toIso8601String());
        return isAscending ? dateA.compareTo(dateB) : dateB.compareTo(dateA);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _sortNotes();
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: Text(
          'NoteStash',
          style: TextStyle(color: CupertinoColors.systemOrange, fontSize: 18),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(
            CupertinoIcons.slider_horizontal_3,
            color: CupertinoTheme.of(context).brightness == Brightness.dark
                ? CupertinoColors.white
                : CupertinoColors.black,
          ),
          onPressed: () {
            showCupertinoModalPopup(
              context: context,
              builder: (context) => CupertinoActionSheet(
                title: Text('Options'),
                actions: [
                  CupertinoActionSheetAction(
                    child: Text('${isAscending ? "Sort Ascending" : "Sort Descending"}'),
                    onPressed: () {
                      setState(() {
                        isAscending = !isAscending;
                      });
                      Navigator.pop(context);
                    },
                  ),
                  CupertinoActionSheetAction(
                    child: Text(isGridView ? 'Switch to List View' : 'Switch to Grid View'),
                    onPressed: () {
                      setState(() {
                        isGridView = !isGridView;
                      });
                      Navigator.pop(context);
                    },
                  ),
                ],
                cancelButton: CupertinoActionSheetAction(
                  child: Text('Cancel'),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            );
          },
        ),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: notes.isEmpty
                      ? Center(
                    child: Text(
                      'No notes available. Tap "+" to add one!',
                      style: TextStyle(fontSize: 16, color: CupertinoColors.inactiveGray),
                    ),
                  )
                      : isGridView
                      ? GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 4.0,
                      mainAxisSpacing: 4.0,
                    ),
                    itemCount: notes.length,
                    itemBuilder: (context, index) => _buildNoteItem(index, true),
                  )
                      : ListView.builder(
                    itemCount: notes.length,
                    itemBuilder: (context, index) => _buildNoteItem(index, false),
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: CupertinoButton(
                padding: EdgeInsets.all(12),
                borderRadius: BorderRadius.circular(50),
                color: CupertinoColors.activeBlue,
                child: Icon(CupertinoIcons.add, size: 30, color: CupertinoColors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => NoteDetailScreen(
                        note: '',
                        onSave: (newNote) {
                          if (newNote["content"].isNotEmpty) {
                            _addNote(newNote);
                          }
                        },
                        textColor: CupertinoColors.black,
                        fontSize: 18.0,
                        textAlign: TextAlign.left,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoteItem(int index, bool isGrid) {
    String createdDate = notes[index]['created'] ?? '';
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => NoteDetailScreen(
              note: notes[index]['content'],
              createdDate: createdDate,
              onSave: (updatedNote) => _updateNote(index, updatedNote),
              textColor: Color(notes[index]['textColor'] ?? CupertinoColors.black.value),
              fontSize: notes[index]['fontSize']?.toDouble() ?? 18.0,
              textAlign: TextAlign.values[notes[index]['textAlign'] ?? 0],
            ),
          ),
        );
      },
      onLongPress: () {
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: Text('Delete!'),
            content: Text('Are you sure?'),
            actions: [
              CupertinoButton(
                child: Text('Yes', style: TextStyle(color: CupertinoColors.systemRed)),
                onPressed: () {
                  _deleteNote(index);
                  Navigator.pop(context);
                },
              ),
              CupertinoButton(
                child: Text('No', style: TextStyle(color: CupertinoColors.systemBlue)),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.all(4),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: CupertinoColors.systemFill.withOpacity(0.3),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notes[index]['content'] ?? 'No content',
              maxLines: isGrid ? 3 : 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 4),
            Text(
              'Created: ${createdDate.isNotEmpty ? DateFormat.yMd().add_jm().format(DateTime.parse(createdDate)) : 'Unknown'}',
              style: TextStyle(fontSize: 10, color: CupertinoColors.inactiveGray),
            ),
          ],
        ),
      ),
    );
  }
}