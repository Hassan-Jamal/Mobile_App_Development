import 'package:firebase_auth/firebase_auth.dart';
import 'package:firstproject/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firstproject/pages/academic_page.dart';
import 'package:firstproject/pages/discussion_forum_page.dart';
import 'package:firstproject/pages/manage_profile.dart';
import 'package:firstproject/pages/profile_info.dart';
import 'package:firstproject/pages/free_resources.dart'; 

class HomePage extends StatelessWidget {
  const HomePage({Key? key});

  Future<void> signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacementNamed(context, '/login'); 
    } catch (e) {
      print('Sign out failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("E-Learning Platform"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileInfo(profileName: "Guest", gmailUsername: "guest@gmail.com"),
            const SizedBox(height: 16),
            _buildModuleCard(
              title: 'Google Classroom',
              icon: Icons.class_,
              onTap: () {
                _launchURL('https://classroom.google.com/');
              },
            ),
            const SizedBox(height: 16),
            _buildModuleCard(
              title: 'Academic',
              icon: Icons.school,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AcademicPage()),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildModuleCard(
              title: 'Free Resources',
              icon: Icons.school,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FreeResourcesPage()), 
                );
              },
            ),
            const SizedBox(height: 16),
            _buildModuleCard(
              title: 'Discussion Forum',
              icon: Icons.chat,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DiscussionForumPage()),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildModuleCard(
              title: 'Manage Profile',
              icon: Icons.person,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ManageProfile()),
                );
              },
            ),
            const SizedBox(height: 16),
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
      drawer: MyDrawer(), // No need to provide profileName, gmailUsername, or userEmail here
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
      Share.share('https://elearning-showcase-jy7nf0s.gamma.site/');
    } catch (e) {
      print('Error sharing app: $e');
    }
  }

  Widget _buildModuleCard({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      color: Colors.deepPurple, 
      child: ListTile(
        leading: Icon(icon, color: Colors.white), 
        title: Text(
          title,
          style: const TextStyle(color: Colors.white), 
        ),
        onTap: onTap,
      ),
    );
  }
}
