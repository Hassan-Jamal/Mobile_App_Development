import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firstproject/pages/discussion_forum_page.dart';
import 'package:firstproject/pages/home_page.dart';
import 'package:firstproject/pages/manage_profile.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  late String _imagePath;
  String _profileName = "";
  String _gmailUsername = "";
  final String _cacheKey = "profile_picture";

  @override
  void initState() {
    super.initState();
    _loadUserInformation();
  }

  Future<void> _loadUserInformation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _imagePath = prefs.getString(_cacheKey) ?? "";
    });
    // Load other user information here
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _profileName = user.displayName ?? "";
      _gmailUsername = user.email ?? "";

      if (_imagePath != "assets/images/camera.png") {
        prefs.setString(_cacheKey, _imagePath); // Save the image path to SharedPreferences
      }
    } else {
      _profileName = "Guest";
      _gmailUsername = "guest@gmail.com";
    }
  }

  Future<void> _getImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      setState(() {
        _imagePath = pickedFile.path;
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(_cacheKey, _imagePath); // Save the image path to SharedPreferences

      // Upload image to Firebase Storage
      String userId = FirebaseAuth.instance.currentUser!.uid;
      String imagePath = 'profile_pictures/$userId/${DateTime.now().millisecondsSinceEpoch}.jpg';
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref(imagePath);
      await ref.putFile(imageFile);

      // Get the download URL and save it to Firestore
      String downloadURL = await ref.getDownloadURL();
      FirebaseFirestore.instance.collection('users').doc(userId).update({
        'profile_picture': downloadURL,
      });
    }
  }

  Future<void> _removeImage() async {
    // Delete image from Firebase Storage
    String userId = FirebaseAuth.instance.currentUser!.uid;
    String imagePath = 'profile_pictures/$userId/${DateTime.now().millisecondsSinceEpoch}.jpg';
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref(imagePath);
    await ref.delete();

    // Remove profile picture URL from Firestore
    FirebaseFirestore.instance.collection('users').doc(userId).update({
      'profile_picture': null,
    });

    // Remove profile picture path from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(_cacheKey);

    setState(() {
      _imagePath = ""; // Clear the image path
    });
  }

  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      print('Sign out failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
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
                accountName: Text(
                  _profileName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                accountEmail: Text(
                  _gmailUsername,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                currentAccountPicture: GestureDetector(
                  onTap: _getImage,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: _imagePath.isNotEmpty && _imagePath != "assets/images/camera.png"
                        ? FileImage(File(_imagePath))
                        : AssetImage("assets/images/camera.png") as ImageProvider<Object>,
                    radius: 40,
                  ),
                ),
                decoration: const BoxDecoration(
                  color: Colors.deepPurple,
                ),
              ),
            ),
            // Other list tile items
            ListTile(
              leading: Icon(Icons.home, color: Colors.white),
              title: Text(
                'Home',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.person, color: Colors.white),
              title: Text(
                'Profile',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ManageProfile()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.white),
              title: Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ),
              onTap: _signOut,
            ),
            Divider(color: Colors.white),
            ListTile(
              leading: Icon(Icons.settings, color: Colors.white),
              title: Text(
                'Settings',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ListTile(
              leading: Icon(Icons.feedback, color: Colors.white),
              title: Text(
                'Send Feedback',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => DiscussionForumPage()),
                );
              },
            ),
          
          ],
        ),
      ),
    );
  }
}
