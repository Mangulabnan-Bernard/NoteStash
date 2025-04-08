import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/adapters.dart';
import 'home_screen.dart';

void main() async {
  // Initialize Hive
  await Hive.initFlutter();
  await Hive.openBox('appdata'); // Open the box for settings and data

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Box box;
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    box = Hive.box('appdata');
    isDarkMode = box.get('isDarkMode') ?? false; // Retrieve Dark Mode preference
  }

  // Function to toggle Dark Mode
  void toggleTheme(bool value) {
    setState(() {
      isDarkMode = value;
      box.put('isDarkMode', value); // Save Dark Mode preference
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      theme: CupertinoThemeData(
        brightness: isDarkMode ? Brightness.dark : Brightness.light, // Apply Dark Mode
      ),
      home: HomeScreen(
        toggleTheme: toggleTheme, // Pass toggleTheme to HomeScreen
        isDarkMode: isDarkMode,  // Pass isDarkMode to HomeScreen
      ),
    );
  }
}
