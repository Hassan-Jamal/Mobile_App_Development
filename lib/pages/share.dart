import 'package:flutter/material.dart';
import 'package:share/share.dart';

class SharePage extends StatelessWidget {
  void shareContent(String content, {String? subject}) {
    Share.share(content, subject: subject);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Share'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                shareContent('Check out this awesome app! Shared via WhatsApp');
              },
              child: Text('Share via WhatsApp'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                shareContent('Check out this awesome app! Shared via email',
                    subject: 'Check out this app');
              },
              child: Text('Share via Email'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                shareContent(
                    'Check out this awesome app! Shared via other apps');
              },
              child: Text('Share via Other Apps'),
            ),
          ],
        ),
      ),
    );
  }
}
