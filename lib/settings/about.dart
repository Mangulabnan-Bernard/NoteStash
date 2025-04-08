import 'package:flutter/cupertino.dart';

class AboutPage extends StatefulWidget {
  final bool isDarkMode; // Accept dark mode state

  AboutPage({required this.isDarkMode});

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final List<Map<String, dynamic>> members = [
    {"name": "Bernard Mangulabnan", "role": "Lead Developer/Ui Designer", "icon": CupertinoIcons.star, "color": CupertinoColors.systemBlue},
    {"name": "Mervin Magat", "role": "Co-Developer/Designer", "icon": CupertinoIcons.paintbrush, "color": CupertinoColors.systemGreen},
    {"name": "Steven Lising", "role": "Backend Developer", "icon": CupertinoIcons.gear, "color": CupertinoColors.systemOrange},
    {"name": "Paul Vismonte", "role": "Tester/Testing", "icon": CupertinoIcons.checkmark_seal, "color": CupertinoColors.systemPurple},
    {"name": "Renz Samson", "role": "Content Writer/Accessibility Tester", "icon": CupertinoIcons.doc_text, "color": CupertinoColors.systemRed},
    {"name": "Ivan Lopez", "role": "Content Writer/Tester", "icon": CupertinoIcons.archivebox_fill, "color": CupertinoColors.systemPink},
    {"name": "Ives Lopez", "role": "Content Writer/Tester", "icon": CupertinoIcons.archivebox, "color": CupertinoColors.systemTeal},

  ];
  @override
  Widget build(BuildContext context) {
    return CupertinoTheme(
      data: CupertinoThemeData(
        brightness: widget.isDarkMode ? Brightness.dark : Brightness.light, // Apply dark mode
      ),
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text('We are the Developers'),
          backgroundColor: widget.isDarkMode ? CupertinoColors.black : CupertinoColors.systemBlue,
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'Meet the Team',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: widget.isDarkMode ? CupertinoColors.white : CupertinoColors.black,
                  ),
                ),
              ),
              Expanded(
                child: CupertinoListSection.insetGrouped(
                  children: members.map((member) {
                    return CupertinoListTile(
                      leading: Icon(member['icon'], color: member['color']),
                      title: Text(
                        member['name'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: widget.isDarkMode ? CupertinoColors.white : CupertinoColors.black,
                        ),
                      ),
                      subtitle: Text(
                        member['role'],
                        style: TextStyle(
                          color: widget.isDarkMode ? CupertinoColors.white : CupertinoColors.systemGrey,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
