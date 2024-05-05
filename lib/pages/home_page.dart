import 'package:firebase_auth/firebase_auth.dart';
import 'package:firstproject/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firstproject/pages/academicPage.dart';
import 'package:firstproject/pages/discussion_forum_page.dart';
import 'package:firstproject/pages/manage_profile.dart';
import 'package:firstproject/pages/profile_info.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  Future<void> signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacementNamed(context, '/login'); // Navigate back to login page
    } catch (e) {
      print('Sign out failed: $e');
    }
  }

  Widget _title() {
    return const Text('Firebase Auth');
  }

  Widget _userEmail(User? user) {
    return Text(user?.email ?? 'User email');
  }

  Widget _signOutButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => signOut(context),
      child: const Text('Sign Out'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("E-Learning Platform"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileInfo(profileName: "Guest", gmailUsername: "guest@gmail.com"),
            SizedBox(height: 16),
            _buildModuleCard(
              title: 'Google Classroom',
              icon: Icons.class_,
              onTap: () {
                _launchURL('https://classroom.google.com/');
              },
            ),
            SizedBox(height: 16),
            _buildModuleCard(
              title: 'Academic',
              icon: Icons.school,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AcademicPage()),
                );
              },
            ),
            SizedBox(height: 16),
            _buildModuleCard(
              title: 'Discussion Forum',
              icon: Icons.chat,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DiscussionForumPage()),
                );
              },
            ),
            SizedBox(height: 16),
            _buildModuleCard(
              title: 'Manage Profile',
              icon: Icons.person,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ManageProfile()),
                );
              },
            ),
            SizedBox(height: 16),
            _buildModuleCard(
              title: 'Share App',
              icon: Icons.share,
              onTap: () {
                _shareApp();
              },
            ),
          ],
        ),
      ),
      drawer: MyDrawer(
        profileName: "Guest",
        gmailUsername: "guest@gmail.com",
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

void _shareApp() {
  try {
    Share.share('Check out this awesome e-learning app!');
  } catch (e) {
    print('Error sharing app: $e');
    // Handle the error accordingly, such as showing a dialog to the user
  }
}

  Widget _buildModuleCard({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.only(bottom: 16),
      color: Colors.deepPurple, // Use deepPurple color
      child: ListTile(
        leading: Icon(icon, color: Colors.white), // Set icon color to white
        title: Text(
          title,
          style: TextStyle(color: Colors.white), // Set text color to white
        ),
        onTap: onTap,
      ),
    );
  }
}

