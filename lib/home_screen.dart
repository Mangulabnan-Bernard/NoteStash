import 'package:flutter/cupertino.dart';
import 'notes_screen.dart';
import 'todo_screen.dart';
import 'settings/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  final Function(bool) toggleTheme; // Function to toggle Dark Mode
  final bool isDarkMode;           // Current Dark Mode state

  const HomeScreen({
    required this.toggleTheme,
    required this.isDarkMode,
    Key? key,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    NotesScreen(), // Notes Tab
    TodoScreen(),  // To-Do Tab
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.square_list),
            label: 'Notes',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.checkmark_square),
            label: 'To-Do',
          ),
        ],
      ),
      tabBuilder: (context, index) {
        return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: Text(_currentIndex == 0 ? 'Notes' : 'To-Do',  // Use style for text color
            ),
            trailing: GestureDetector(
              onTap: () {
                showCupertinoModalPopup(
                  context: context,
                  builder: (context) => SettingsScreen(
                    toggleTheme: widget.toggleTheme, // Pass toggleTheme to SettingsScreen
                    isDarkMode: widget.isDarkMode,  // Pass isDarkMode to SettingsScreen
                  ),
                );
              },
              child: Icon(
                CupertinoIcons.settings,
                color: widget.isDarkMode
                    ? CupertinoColors.white // Light color for dark mode
                    : CupertinoColors.black, // Dark color for light mode
              ),
            ),
          ),
          child: _tabs[index],
        );
      },
    );
  }
}