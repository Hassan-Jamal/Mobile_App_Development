import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final imageurl =
        "data:image/jpeg;base64,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";
    return Drawer(
      child: Container(
        color: Colors.deepPurple,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              padding: EdgeInsets.zero,
               child: UserAccountsDrawerHeader(
                margin: EdgeInsets.zero,
                accountName: Text("Hassan jamal"),
                accountEmail: Text("hassanjamal6545@gmail.com"),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage(imageurl),
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                CupertinoIcons.home,
                color: Colors.white,
              ),
              title: Text(
                "Home",
                textScaleFactor: 1.2,
                style: TextStyle(color: Colors.white),
              ),
            ),
            ListTile(
              leading: Icon(
                CupertinoIcons.profile_circled,
                color: Colors.white,
              ),
              title: Text(
                "Profile",
                textScaleFactor: 1.2,
                style: TextStyle(color: Colors.white),
              ),
            ),
            ListTile(
              leading: Icon(
                CupertinoIcons.mail,
                color: Colors.white,
              ),
              title: Text(
                "Mail",
                textScaleFactor: 1.2,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
