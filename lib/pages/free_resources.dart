import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FreeResourcesPage extends StatelessWidget {
  final List<Course> courses = [
    Course(
      title: 'Introduction to Programming',
      description: 'Learn the basics of programming.',
      playlistUrl: 'https://www.youtube.com/watch?v=PFP8GnJcJHA',
      imagePath: 'assets/images/card_pic.png',
    ),
    Course(
      title: 'Web Development Fundamentals',
      description: 'Explore the fundamentals of web development.',
      playlistUrl: 'https://www.youtube.com/playlist?list=PL4cUxeGkcC9g9gP2onazU5-2M-AzA8eBw',
      imagePath: 'assets/images/discuss_image.png',
    ),
    Course(
      title: 'Machine Learning Essentials',
      description: 'Get started with machine learning.',
      playlistUrl: 'https://www.youtube.com/playlist?list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi',
      imagePath: 'assets/images/login_image.png',
    ),
    Course(
      title: 'Introduction to Python Programming',
      description: 'Get started with machine learning.',
      playlistUrl: 'https://www.youtube.com/playlist?list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi',
      imagePath: 'assets/images/login_image.png',
    ),
    Course(
      title: 'JavaScript Fundamentals',
      description: 'Get started with machine learning.',
      playlistUrl: 'https://www.youtube.com/playlist?list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi',
      imagePath: 'assets/images/login_image.png',
    ),
    Course(
      title: 'Machine Learning Essentials',
      description: 'Get started with JavaScript Fundamentals.',
      playlistUrl: 'https://www.youtube.com/playlist?list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi',
      imagePath: 'assets/images/login_image.png',
    ),
    Course(
      title: 'Machine Learning Essentials',
      description: 'Get started with machine learning.',
      playlistUrl: 'https://www.youtube.com/playlist?list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi',
      imagePath: 'assets/images/login_image.png',
    ),
    Course(
      title: 'Machine Learning Essentials',
      description: 'Get started with machine learning.',
      playlistUrl: 'https://www.youtube.com/playlist?list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi',
      imagePath: 'assets/images/login_image.png',
    ),
    Course(
      title: 'Machine Learning Essentials',
      description: 'Get started with machine learning.',
      playlistUrl: 'https://www.youtube.com/playlist?list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi',
      imagePath: 'assets/images/login_image.png',
    ),
    Course(
      title: 'Machine Learning Essentials',
      description: 'Get started with machine learning.',
      playlistUrl: 'https://www.youtube.com/playlist?list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi',
      imagePath: 'assets/images/login_image.png',
    ),
    Course(
      title: 'Machine Learning Essentials',
      description: 'Get started with machine learning.',
      playlistUrl: 'https://www.youtube.com/playlist?list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi',
      imagePath: 'assets/images/login_image.png',
    ),
    Course(
      title: 'Machine Learning Essentials',
      description: 'Get started with machine learning.',
      playlistUrl: 'https://www.youtube.com/playlist?list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi',
      imagePath: 'assets/images/login_image.png',
    ),
    Course(
      title: 'Machine Learning Essentials',
      description: 'Get started with machine learning.',
      playlistUrl: 'https://www.youtube.com/playlist?list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi',
      imagePath: 'assets/images/login_image.png',
    ),
    Course(
      title: 'Machine Learning Essentials',
      description: 'Get started with machine learning.',
      playlistUrl: 'https://www.youtube.com/playlist?list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi',
      imagePath: 'assets/images/login_image.png',
    ),
    Course(
      title: 'Machine Learning Essentials',
      description: 'Get started with machine learning.',
      playlistUrl: 'https://www.youtube.com/playlist?list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi',
      imagePath: 'assets/images/login_image.png',
    ),
    Course(
      title: 'Machine Learning Essentials',
      description: 'Get started with machine learning.',
      playlistUrl: 'https://www.youtube.com/playlist?list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi',
      imagePath: 'assets/images/login_image.png',
    ),
    Course(
      title: 'Machine Learning Essentials',
      description: 'Get started with machine learning.',
      playlistUrl: 'https://www.youtube.com/playlist?list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi',
      imagePath: 'assets/images/login_image.png',
    ),
    Course(
      title: 'Machine Learning Essentials',
      description: 'Get started with machine learning.',
      playlistUrl: 'https://www.youtube.com/playlist?list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi',
      imagePath: 'assets/images/login_image.png',
    ),
    Course(
      title: 'Machine Learning Essentials',
      description: 'Get started with machine learning.',
      playlistUrl: 'https://www.youtube.com/playlist?list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi',
      imagePath: 'assets/images/login_image.png',
    ),
    Course(
      title: 'Machine Learning Essentials',
      description: 'Get started with machine learning.',
      playlistUrl: 'https://www.youtube.com/playlist?list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi',
      imagePath: 'assets/images/login_image.png',
    ),
    Course(
      title: 'Machine Learning Essentials',
      description: 'Get started with machine learning.',
      playlistUrl: 'https://www.youtube.com/playlist?list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi',
      imagePath: 'assets/images/login_image.png',
    ),
    Course(
      title: 'Machine Learning Essentials',
      description: 'Get started with machine learning.',
      playlistUrl: 'https://www.youtube.com/playlist?list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi',
      imagePath: 'assets/images/login_image.png',
    ),
    Course(
      title: 'Machine Learning Essentials',
      description: 'Get started with machine learning.',
      playlistUrl: 'https://www.youtube.com/playlist?list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi',
      imagePath: 'assets/images/login_image.png',
    ),
    Course(
      title: 'Machine Learning Essentials',
      description: 'Get started with machine learning.',
      playlistUrl: 'https://www.youtube.com/playlist?list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi',
      imagePath: 'assets/images/login_image.png',
    ),
    Course(
      title: 'Machine Learning Essentials',
      description: 'Get started with machine learning.',
      playlistUrl: 'https://www.youtube.com/playlist?list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi',
      imagePath: 'assets/images/login_image.png',
    ),
    Course(
      title: 'Machine Learning Essentials',
      description: 'Get started with machine learning.',
      playlistUrl: 'https://www.youtube.com/playlist?list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi',
      imagePath: 'assets/images/login_image.png',
    ),
    Course(
      title: 'Machine Learning Essentials',
      description: 'Get started with machine learning.',
      playlistUrl: 'https://www.youtube.com/playlist?list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi',
      imagePath: 'assets/images/login_image.png',
    ),
    Course(
      title: 'Machine Learning Essentials',
      description: 'Get started with machine learning.',
      playlistUrl: 'https://www.youtube.com/playlist?list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi',
      imagePath: 'assets/images/login_image.png',
    ),
    Course(
      title: 'Machine Learning Essentials',
      description: 'Get started with machine learning.',
      playlistUrl: 'https://www.youtube.com/playlist?list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi',
      imagePath: 'assets/images/login_image.png',
    ),

    Course(
      title: 'Machine Learning Essentials',
      description: 'Get started with machine learning.',
      playlistUrl: 'https://www.youtube.com/playlist?list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi',
      imagePath: 'assets/images/login_image.png',
    ),
    Course(
      title: 'Machine Learning Essentials',
      description: 'Get started with machine learning.',
      playlistUrl: 'https://www.youtube.com/playlist?list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi',
      imagePath: 'assets/images/login_image.png',
    ),
    Course(
      title: 'Machine Learning Essentials',
      description: 'Get started with machine learning.',
      playlistUrl: 'https://www.youtube.com/playlist?list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi',
      imagePath: 'assets/images/login_image.png',
    ),
    Course(
      title: 'Machine Learning Essentials',
      description: 'Get started with machine learning.',
      playlistUrl: 'https://www.youtube.com/playlist?list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi',
      imagePath: 'assets/images/login_image.png',
    ),
    Course(
      title: 'Machine Learning Essentials',
      description: 'Get started with machine learning.',
      playlistUrl: 'https://www.youtube.com/playlist?list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi',
      imagePath: 'assets/images/login_image.png',
    ),
    Course(
      title: 'Machine Learning Essentials',
      description: 'Get started with machine learning.',
      playlistUrl: 'https://www.youtube.com/playlist?list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi',
      imagePath: 'assets/images/login_image.png',
    ),
    Course(
      title: 'Machine Learning Essentials',
      description: 'Get started with machine learning.',
      playlistUrl: 'https://www.youtube.com/playlist?list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi',
      imagePath: 'assets/images/login_image.png',
    ),
    Course(
      title: 'Machine Learning Essentials',
      description: 'Get started with machine learning.',
      playlistUrl: 'https://www.youtube.com/playlist?list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi',
      imagePath: 'assets/images/login_image.png',
    ),
    Course(
      title: 'Machine Learning Essentials',
      description: 'Get started with machine learning.',
      playlistUrl: 'https://www.youtube.com/playlist?list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi',
      imagePath: 'assets/images/login_image.png',
    ),
    Course(
      title: 'Machine Learning Essentials',
      description: 'Get started with machine learning.',
      playlistUrl: 'https://www.youtube.com/playlist?list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi',
      imagePath: 'assets/images/login_image.png',
    ),
    Course(
      title: 'Machine Learning Essentials',
      description: 'Get started with machine learning.',
      playlistUrl: 'https://www.youtube.com/playlist?list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi',
      imagePath: 'assets/images/login_image.png',
    ),Course(
      title: 'Machine Learning Essentials',
      description: 'Get started with machine learning.',
      playlistUrl: 'https://www.youtube.com/playlist?list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi',
      imagePath: 'assets/images/login_image.png',
    ),
    Course(
      title: 'Machine Learning Essentials',
      description: 'Get started with machine learning.',
      playlistUrl: 'https://www.youtube.com/playlist?list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi',
      imagePath: 'assets/images/login_image.png',
    ),
    Course(
      title: 'Machine Learning Essentials',
      description: 'Get started with machine learning.',
      playlistUrl: 'https://www.youtube.com/playlist?list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi',
      imagePath: 'assets/images/login_image.png',
    ),
    Course(
      title: 'Machine Learning Essentials',
      description: 'Get started with machine learning.',
      playlistUrl: 'https://www.youtube.com/playlist?list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi',
      imagePath: 'assets/images/login_image.png',
    ),
    Course(
      title: 'Machine Learning Essentials',
      description: 'Get started with machine learning.',
      playlistUrl: 'https://www.youtube.com/playlist?list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi',
      imagePath: 'assets/images/login_image.png',
    ),Course(
      title: 'Machine Learning Essentials',
      description: 'Get started with machine learning.',
      playlistUrl: 'https://www.youtube.com/playlist?list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi',
      imagePath: 'assets/images/login_image.png',
    ),
    Course(
      title: 'Machine Learning Essentials',
      description: 'Get started with machine learning.',
      playlistUrl: 'https://www.youtube.com/playlist?list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi',
      imagePath: 'assets/images/login_image.png',
    ),
    Course(
      title: 'Machine Learning Essentials',
      description: 'Get started with machine learning.',
      playlistUrl: 'https://www.youtube.com/playlist?list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi',
      imagePath: 'assets/images/login_image.png',
    ),Course(
      title: 'Machine Learning Essentials',
      description: 'Get started with machine learning.',
      playlistUrl: 'https://www.youtube.com/playlist?list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi',
      imagePath: 'assets/images/login_image.png',
    ),
    Course(
      title: 'Machine Learning Essentials',
      description: 'Get started with machine learning.',
      playlistUrl: 'https://www.youtube.com/playlist?list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi',
      imagePath: 'assets/images/login_image.png',
    ),
    Course(
      title: 'Machine Learning Essentials',
      description: 'Get started with machine learning.',
      playlistUrl: 'https://www.youtube.com/playlist?list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi',
      imagePath: 'assets/images/login_image.png',
    ),
    Course(
      title: 'Machine Learning Essentials',
      description: 'Get started with machine learning.',
      playlistUrl: 'https://www.youtube.com/playlist?list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi',
      imagePath: 'assets/images/login_image.png',
    ),
    Course(
      title: 'Machine Learning Essentials',
      description: 'Get started with machine learning.',
      playlistUrl: 'https://www.youtube.com/playlist?list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi',
      imagePath: 'assets/images/login_image.png',
    ),Course(
      title: 'Machine Learning Essentials',
      description: 'Get started with machine learning.',
      playlistUrl: 'https://www.youtube.com/playlist?list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi',
      imagePath: 'assets/images/login_image.png',
    ),

    Course(
      title: 'Machine Learning Essentials',
      description: 'Get started with machine learning.',
      playlistUrl: 'https://www.youtube.com/playlist?list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi',
      imagePath: 'assets/images/login_image.png',
    ),
    Course(
      title: 'Machine Learning Essentials',
      description: 'Get started with machine learning.',
      playlistUrl: 'https://www.youtube.com/playlist?list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi',
      imagePath: 'assets/images/login_image.png',
    ),
    Course(
      title: 'Machine Learning Essentials',
      description: 'Get started with machine learning.',
      playlistUrl: 'https://www.youtube.com/playlist?list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi',
      imagePath: 'assets/images/login_image.png',
    ),
    Course(
      title: 'Machine Learning Essentials',
      description: 'Get started with machine learning.',
      playlistUrl: 'https://www.youtube.com/playlist?list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi',
      imagePath: 'assets/images/login_image.png',
    ),
    Course(
      title: 'Machine Learning Essentials',
      description: 'Get started with machine learning.',
      playlistUrl: 'https://www.youtube.com/playlist?list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi',
      imagePath: 'assets/images/login_image.png',
    ),
    Course(
      title: 'Machine Learning Essentials',
      description: 'Get started with machine learning.',
      playlistUrl: 'https://www.youtube.com/playlist?list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi',
      imagePath: 'assets/images/login_image.png',
    ),
    Course(
      title: 'Machine Learning Essentials',
      description: 'Get started with machine learning.',
      playlistUrl: 'https://www.youtube.com/playlist?list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi',
      imagePath: 'assets/images/login_image.png',
    ),
    Course(
      title: 'Machine Learning Essentials',
      description: 'Get started with machine learning.',
      playlistUrl: 'https://www.youtube.com/playlist?list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi',
      imagePath: 'assets/images/login_image.png',
    ),
    Course(
      title: 'Machine Learning Essentials',
      description: 'Get started with machine learning.',
      playlistUrl: 'https://www.youtube.com/playlist?list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi',
      imagePath: 'assets/images/login_image.png',
    ),
    Course(
      title: 'Machine Learning Essentials',
      description: 'Get started with machine learning.',
      playlistUrl: 'https://www.youtube.com/playlist?list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi',
      imagePath: 'assets/images/login_image.png',
    ),Course(
      title: 'Machine Learning Essentials',
      description: 'Get started with machine learning.',
      playlistUrl: 'https://www.youtube.com/playlist?list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi',
      imagePath: 'assets/images/login_image.png',
    ),

    // Add more initial courses here...
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Free Resources'),
      ),
      body: ListView.builder(
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final course = courses[index];
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
                    Image.asset(
                      course.imagePath,
                      width: 100, // Adjust width as needed
                      height: 100, // Adjust height as needed
                      fit: BoxFit.cover,
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            course.title,
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            course.description,
                            style: TextStyle(fontSize: 16),
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
