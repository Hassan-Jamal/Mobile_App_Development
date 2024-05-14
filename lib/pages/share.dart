import 'package:flutter/material.dart';
import 'package:share/share.dart';

class SharePage extends StatelessWidget {
  const SharePage({Key? key});

  void shareContent(String deepLink, {String? subject}) {
    Share.share(deepLink, subject: subject);
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
                shareContent(
                  'https://elearning-showcase-jy7nf0s.gamma.site/',
                );
              },
              child: const Text('Share via WhatsApp'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                shareContent(
                  'https://elearning-showcase-jy7nf0s.gamma.site/',
                );
              },
              child: const Text('Share via Email'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                shareContent(
                  'https://elearning-showcase-jy7nf0s.gamma.site/',
                );
              },
              child: const Text('Share via Other Apps'),
            ),
          ],
        ),
      ),
    );
  }
}
