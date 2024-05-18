import 'package:firstproject/pages/live_classes.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firstproject/pages/personalized_recommendations_page.dart'; // Import the personalized recommendations page
import 'package:firstproject/widgets/drawer.dart';
import 'package:firstproject/pages/academic_page.dart';
import 'package:firstproject/pages/discussion_forum_page.dart';
import 'package:firstproject/pages/manage_profile.dart';
import 'package:firstproject/pages/profile_info.dart';
import 'package:firstproject/pages/free_resources.dart';
import 'package:share/share.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("E-Learning Platform"),
        backgroundColor: Colors.deepPurple, // Set app bar color
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ProfileInfo(), // Updated to match the new constructor
            const SizedBox(height: 16),
            _buildModuleCard(
              title: 'Google Classroom',
              icon: Icons.class_,
              onTap: () {
                _launchURL('https://classroom.google.com/');
              },
              color: Colors.blue, // Set card color
              gradient: LinearGradient(
                colors: [Colors.blue.shade400, Colors.blue.shade700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
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
              color: Colors.green, // Set card color
              gradient: LinearGradient(
                colors: [Colors.green.shade400, Colors.green.shade700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
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
              color: Colors.orange, // Set card color
              gradient: LinearGradient(
                colors: [Colors.orange.shade400, Colors.orange.shade700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
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
              color: Colors.red, // Set card color
              gradient: LinearGradient(
                colors: [Colors.red.shade400, Colors.red.shade700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
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
              color: Colors.teal, // Set card color
              gradient: LinearGradient(
                colors: [Colors.teal.shade400, Colors.teal.shade700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            const SizedBox(height: 16),
            _buildModuleCard(
              title: 'Personalized Recommendations', // Add the personalized recommendations module
              icon: Icons.lightbulb, // You can change the icon to fit your design
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PersonalizedRecommendationsPage()),
                );
              },
              color: Colors.deepOrange, // Set card color
              gradient: LinearGradient(
                colors: [Colors.deepOrange.shade400, Colors.deepOrange.shade700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            const SizedBox(height: 16),
            _buildModuleCard(
              title: 'Live Classes', // Add the live classes module
              icon: Icons.live_tv, // You can change the icon to fit your design
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LiveClassesPage()),
                );
              },
              color: Colors.yellow, // Set card color
              gradient: LinearGradient(
                colors: [Colors.yellow.shade400, Colors.yellow.shade700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            const SizedBox(height: 16),
            _buildModuleCard(
              title: 'Share App',
              icon: Icons.share,
              onTap: () {
                _shareApp();
              },
              color: Colors.purple, // Set card color
              gradient: LinearGradient(
                colors: [Colors.purple.shade400, Colors.purple.shade700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ],
        ),
      ),
      drawer: MyDrawer(), // No need to provide profileName, gmailUsername, or userEmail here
    );
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacementNamed(context, '/login'); 
    } catch (e) {
      print('Sign out failed: $e');
    }
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
    required Color color,
    required Gradient gradient,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Card(
        elevation: 0,
        margin: const EdgeInsets.only(bottom: 16),
        color: Colors.transparent,
        child: ListTile(
          leading: Icon(icon, color: Colors.white),
          title: Text(
            title,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
