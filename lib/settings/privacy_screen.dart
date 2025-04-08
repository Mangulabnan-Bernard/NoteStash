import 'package:flutter/cupertino.dart';

class PrivacyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Privacy Policy'),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Privacy Policy for NoteStash',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                'Effective Date: April 7, 2025\n'
                    'Last Updated: April 7, 2025',
                style: TextStyle(fontSize: 14, color: CupertinoColors.secondaryLabel),
              ),
              SizedBox(height: 16),
              _buildSection(
                context,
                '1. Information We Collect',
                'NoteStash is a local-only application that does not collect, store, or transmit any personal data to external servers or third parties.\n\n'
                    '- No Personal Data Collected: NoteStash operates entirely on your device. All notes, tasks, and other data are stored locally using Hive, a local database. No information is sent to or accessed by us.\n\n'
                    '- Device Storage Access: The app may request access to your device\'s storage to save notes and tasks locally. This data remains private and is not shared with us or any third parties.',
              ),
              _buildSection(
                context,
                '2. How We Use Your Information',
                'Since NoteStash does not collect any personal data, there is no usage of such information. The app is intended for personal use, and all data is stored securely on your device.',
              ),
              _buildSection(
                context,
                '3. Data Security',
                'We take the security of your data seriously. Since all data is stored locally on your device:\n\n'
                    '- Your notes and tasks are not accessible by anyone other than you.\n'
                    '- We do not have access to your device or its contents.\n\n'
                    'However, please ensure that you secure your device with a password, PIN, or biometric authentication to protect your data from unauthorized access.',
              ),
              _buildSection(
                context,
                '4. Third-Party Services',
                'NoteStash does not integrate with any third-party services or APIs. It is a standalone application that functions entirely offline.',
              ),
              _buildSection(
                context,
                '5. Children’s Privacy',
                'NoteStash is not intended for use by children under the age of 13. We do not knowingly collect personal information from children. If you believe that a child has provided us with personal information, please contact us so we can address the issue.',
              ),
              _buildSection(
                context,
                '6. Changes to This Privacy Policy',
                'We may update this Privacy Policy from time to time to reflect changes in our practices or for other operational, legal, or regulatory reasons. If we make significant changes, we will notify you through the app or other means. Your continued use of the app after such updates constitutes your acceptance of the revised Privacy Policy.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
          content,
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 16),
      ],
    );
  }
}