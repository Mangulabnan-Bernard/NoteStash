import 'package:flutter/cupertino.dart';
import 'package:NoteStash/settings/about.dart';
import 'privacy_screen.dart';

class SettingsScreen extends StatelessWidget {
  final Function(bool) toggleTheme;
  final bool isDarkMode;

  const SettingsScreen({
    required this.toggleTheme,
    required this.isDarkMode,
    Key? key,
  }) : super(key: key);

  Color getBackgroundColor() =>
      isDarkMode ? CupertinoColors.darkBackgroundGray : CupertinoColors.systemGroupedBackground;

  Color getTextColor() =>
      isDarkMode ? CupertinoColors.white : CupertinoColors.black;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: getBackgroundColor(),
      navigationBar: CupertinoNavigationBar(
        middle: Text('Settings'),
        backgroundColor: getBackgroundColor(),
      ),
      child: SafeArea(
        child: ListView(
          children: [
            // Grouped Section: Dark Mode, About, Privacy
            CupertinoListSection.insetGrouped(
              backgroundColor: getBackgroundColor(),
              children: [
                CupertinoListTile(
                  title: Text('Dark Mode', style: TextStyle(color: getTextColor())),
                  leading: Icon(CupertinoIcons.moon),
                  trailing: CupertinoSwitch(
                    value: isDarkMode,
                    onChanged: (value) => toggleTheme(value),
                  ),
                ),
                CupertinoListTile(
                  title: Text('About', style: TextStyle(color: getTextColor())),
                  leading: Icon(CupertinoIcons.info),
                  onTap: () => Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => AboutPage(isDarkMode: isDarkMode),
                    ),
                  ),
                ),
                CupertinoListTile(
                  title: Text('Privacy', style: TextStyle(color: getTextColor())),
                  leading: Icon(CupertinoIcons.lock),
                  onTap: () => Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => PrivacyScreen(),
                    ),
                  ),
                ),
              ],
            ),

            // Version Section
            CupertinoListSection.insetGrouped(
              backgroundColor: getBackgroundColor(),
              children: [
                CupertinoListTile(
                  title: Text('Version', style: TextStyle(color: getTextColor())),
                  leading: Icon(CupertinoIcons.number),
                  trailing: Text(
                    '1.0.0+4',
                    style: TextStyle(
                      color: CupertinoColors.inactiveGray,
                      fontSize: 16,
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
}
