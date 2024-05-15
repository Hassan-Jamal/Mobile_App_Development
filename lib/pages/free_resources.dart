import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FreeResourcesPage extends StatefulWidget {
  @override
  _FreeResourcesPageState createState() => _FreeResourcesPageState();
}

class _FreeResourcesPageState extends State<FreeResourcesPage> {
  late List<Course> courses = [];
  late List<Course> filteredCourses = [];

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchCourses();
  }

  Future<void> fetchCourses() async {
    try {
      String data = await DefaultAssetBundle.of(context).loadString('assets/files/resources.json');
      final List<dynamic> jsonData = json.decode(data);
      setState(() {
        courses = jsonData.map((courseData) => Course.fromJson(courseData)).toList();
        filteredCourses = List.from(courses);
      });
    } catch (e) {
      print('Error loading courses: $e');
    }
  }

  void _filterCourses(String query) {
    setState(() {
      filteredCourses = courses.where((course) {
        final titleLower = course.title.toLowerCase();
        final descriptionLower = course.description.toLowerCase();
        final searchLower = query.toLowerCase();
        return titleLower.contains(searchLower) || descriptionLower.contains(searchLower);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Free Resources'),
        backgroundColor: Colors.orange, // Change app bar color
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: _filterCourses,
              decoration: InputDecoration(
                hintText: 'Search courses...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: filteredCourses.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: filteredCourses.length,
                    itemBuilder: (context, index) {
                      final course = filteredCourses[index];
                      return GestureDetector(
                        onTap: () {
                          _launchURL(course.playlistUrl);
                        },
                        child: Card(
                          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
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
                                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        course.description,
                                        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
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
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.white, backgroundColor: Colors.orange, // Text color
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
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
        ],
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

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      title: json['title'],
      description: json['description'],
      playlistUrl: json['playlistUrl'],
      imagePath: json['imagePath'],
    );
  }
}
