import 'package:flutter/material.dart';
import 'package:share/share.dart';

class SharePage extends StatelessWidget {
  const SharePage({super.key});

  void shareContent(String content, {String? subject}) {
    Share.share(content, subject: subject);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Share'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                shareContent('Check out this awesome app! Shared via WhatsApp');
              },
              child: const Text('Share via WhatsApp'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                shareContent('Check out this awesome app! Shared via email',
                    subject: 'Check out this app');
              },
              child: const Text('Share via Email'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                shareContent(
                    'Check out this awesome app! Shared via other apps');
              },
              child: const Text('Share via Other Apps'),
            ),
          ],
        ),
      ),
    );
  }
}
