import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

class TodoScreen extends StatefulWidget {
  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  late Box box;
  List<dynamic> todolist = [];
  bool showGreen = false; // Filter flag for green status
  bool showRed = false;   // Filter flag for red status

  @override
  void initState() {
    super.initState();
    box = Hive.box('appdata');
    todolist = box.get('todo') ?? [];
  }

  void _addTask(String task) {
    setState(() {
      todolist.add({"task": task, "status": false});
      box.put('todo', todolist);
    });
  }

  void _deleteTask(int index) {
    setState(() {
      todolist.removeAt(index);
      box.put('todo', todolist);
    });
  }

  void _toggleStatus(int index) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text('Update'),
          content: Text('Update the status?'),
          actions: [
            CupertinoButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            CupertinoButton(
              child: Text('Save'),
              onPressed: () {
                setState(() {
                  todolist[index]['status'] = !todolist[index]['status'];
                  box.put('todo', todolist);
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _toggleFilter(bool isGreen) {
    setState(() {
      showGreen = isGreen;
      showRed = !isGreen;  // Toggle the other filter when one is activated
    });
  }

  @override
  Widget build(BuildContext context) {
    // Filtered list based on the selected status filters
    List filteredList = todolist.where((task) {
      if (showGreen && showRed) return true; // Show all if both filters are selected
      if (showGreen) return task['status'] == true; // Show only green tasks (completed)
      if (showRed) return task['status'] == false; // Show only red tasks (incomplete)
      return true; // Show all tasks if no filter is applied
    }).toList();

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: Text(
          'To-Do',
          style: TextStyle(color: CupertinoColors.systemOrange, fontSize: 18),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(CupertinoIcons.slider_horizontal_3),
          onPressed: () {
            showCupertinoDialog(
              context: context,
              builder: (context) {
                return CupertinoAlertDialog(
                  title: Text('Filter Tasks'),
                  actions: [
                    CupertinoButton(
                      child: Text(showRed ? 'Green Status' : 'Red Status'),
                      onPressed: () {
                        _toggleFilter(showRed);  // Toggle between red and green
                        Navigator.pop(context);
                      },
                    ),
                    CupertinoButton(
                      child: Text('Show All'),
                      onPressed: () {
                        setState(() {
                          showGreen = false;
                          showRed = false;
                        });
                        Navigator.pop(context);
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: filteredList.isEmpty
                  ? Center(
                child: Text(
                  'No To-Do available. Tap "+" to add one!',
                  style: TextStyle(
                    fontSize: 16,
                    color: CupertinoColors.inactiveGray,
                  ),
                ),
              )
                  : ListView.builder(
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: Key(filteredList[index]['task'] + index.toString()),
                    direction: DismissDirection.endToStart,
                    confirmDismiss: (direction) async {
                      bool confirm = false;
                      await showCupertinoDialog(
                        context: context,
                        builder: (context) {
                          return CupertinoAlertDialog(
                            title: Text('Remove Task'),
                            content: Text('Do you want to remove this task?'),
                            actions: [
                              CupertinoButton(
                                child: Text('No'),
                                onPressed: () {
                                  Navigator.pop(context);
                                  confirm = false;
                                },
                              ),
                              CupertinoButton(
                                child: Text('Yes', style: TextStyle(color: CupertinoColors.destructiveRed)),
                                onPressed: () {
                                  confirm = true;
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        },
                      );
                      return confirm;
                    },
                    onDismissed: (direction) => _deleteTask(index),
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      color: CupertinoColors.destructiveRed.withOpacity(0.8),
                      child: Icon(CupertinoIcons.delete_solid, color: CupertinoColors.white),
                    ),
                    child: GestureDetector(
                      onLongPress: () {
                        final TextEditingController editController = TextEditingController(text: filteredList[index]['task']);
                        showCupertinoDialog(
                          context: context,
                          builder: (context) {
                            return CupertinoAlertDialog(
                              title: Text('Edit Task'),
                              content: Column(
                                children: [
                                  SizedBox(height: 10),
                                  CupertinoTextField(
                                    controller: editController,
                                    placeholder: 'Edit your task',
                                  ),
                                ],
                              ),
                              actions: [
                                CupertinoButton(
                                  child: Text('Cancel'),
                                  onPressed: () => Navigator.pop(context),
                                ),
                                CupertinoButton(
                                  child: Text('Save'),
                                  onPressed: () {
                                    setState(() {
                                      filteredList[index]['task'] = editController.text;
                                      box.put('todo', todolist);
                                    });
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      onTap: () => _toggleStatus(index),
                      child: Container(
                        margin: EdgeInsets.all(8),
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: CupertinoColors.systemFill.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                filteredList[index]['task'],
                                style: TextStyle(
                                  decoration: filteredList[index]['status'] ? TextDecoration.lineThrough : null,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _toggleStatus(index),
                              child: filteredList[index]['status']
                                  ? Icon(CupertinoIcons.checkmark_circle_fill, size: 20, color: CupertinoColors.systemGreen)
                                  : Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [CupertinoColors.systemRed.withOpacity(0.9), CupertinoColors.systemRed.withOpacity(0.6)],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                  boxShadow: [BoxShadow(color: CupertinoColors.black.withOpacity(0.2), blurRadius: 2, offset: Offset(1, 1))],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: CupertinoButton(
                  padding: EdgeInsets.all(12),
                  borderRadius: BorderRadius.circular(50),
                  color: CupertinoColors.systemBlue,
                  child: Icon(CupertinoIcons.add, size: 30, color: CupertinoColors.white),
                  onPressed: () {
                    showCupertinoDialog(
                      context: context,
                      builder: (context) => AddTaskDialog(addTask: _addTask),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

  class AddTaskDialog extends StatelessWidget {
  final Function(String) addTask;
  final TextEditingController _controller = TextEditingController();

  AddTaskDialog({required this.addTask});

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text('Add Task'),
      content: CupertinoTextField(
        controller: _controller,
        placeholder: 'Enter your task',
      ),
      actions: [
        CupertinoButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
        CupertinoButton(
          child: Text('Save'),
          onPressed: () {
            if (_controller.text.isNotEmpty) {
              addTask(_controller.text);
              Navigator.pop(context);
            }
          },
        ),
      ],
    );
  }
}
