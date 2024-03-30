import 'package:flutter/material.dart';

class DiscussionForumPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Discussion Forum"),
      ),
      body: Center(
        child: Text(
          "Discussion Forum Page",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
