import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class PersonalizedRecommendationsPage extends StatefulWidget {
  const PersonalizedRecommendationsPage({Key? key}) : super(key: key);

  @override
  _PersonalizedRecommendationsPageState createState() =>
      _PersonalizedRecommendationsPageState();
}

class _PersonalizedRecommendationsPageState
    extends State<PersonalizedRecommendationsPage> {
  late List<Course> recommendedCourses = [];

  @override
  void initState() {
    super.initState();
    // Load personalized recommendations when the page initializes
    loadRecommendations();
  }

  Future<void> loadRecommendations() async {
    try {
      // Retrieve user data from Firestore
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        // Extract user interests, past courses, etc. from userData
        // Use machine learning algorithms to generate recommendations
        List<Course> recommendations = generateRecommendations(userData);

        setState(() {
          recommendedCourses = recommendations;
        });
      }
    } catch (e) {
      print('Error loading recommendations: $e');
    }
  }

  List<Course> generateRecommendations(DocumentSnapshot userData) {
    // Implement machine learning algorithms to generate personalized recommendations
    // This function should return a list of recommended courses based on user data
    // For demonstration purposes, we'll return a hardcoded list of sample courses
    return [
      Course(
        title: 'Introduction to Machine Learning',
        description: 'Learn the basics of machine learning algorithms',
        imagePath: 'assets/images/machine_learning.jpg',
        playlistUrl: 'https://www.udemy.com/course/machinelearning/',
      ),
      Course(
        title: 'Web Development Bootcamp',
        description: 'Master web development with HTML, CSS, and JavaScript',
        imagePath: 'assets/images/web_development.jpg',
        playlistUrl: 'https://www.udemy.com/course/the-web-developer-bootcamp/',
      ),
      // Add more recommended courses here
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personalized Recommendations'),
        backgroundColor: Colors.deepOrange, // Set app bar color
      ),
      body: Center(
        child: recommendedCourses.isEmpty
            ? CircularProgressIndicator() // Show loading indicator while recommendations are loading
            : ListView.builder(
                itemCount: recommendedCourses.length,
                itemBuilder: (context, index) {
                  final course = recommendedCourses[index];
                  return GestureDetector(
                    onTap: () {
                      _launchURL(course.playlistUrl);
                    },
                    child: Card(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      elevation: 4,
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.asset(
                                course.imagePath,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    course.title,
                                    style: TextStyle(
                                        fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    course.description,
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey[700]),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 8),
                                  ElevatedButton(
                                    onPressed: () {
                                      _launchURL(course.playlistUrl);
                                    },
                                    child: Text(
                                      'Access Course',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.deepOrange,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
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
}

class Course {
  final String title;
  final String description;
  final String playlistUrl;
  final String imagePath;

  Course({
    required this.title,
    required this.description,
    required this.playlistUrl,
    required this.imagePath,
  });
}
