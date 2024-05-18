import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class LiveSession {
  final String title;
  final String sessionType; // 'live' or 'recorded'
  final String sessionId;
  final String teacher;
  final String platform;
  final String url; // URL to join or view the session

  LiveSession({
    required this.title,
    required this.sessionType,
    required this.sessionId,
    required this.teacher,
    required this.platform,
    required this.url,
  });
}

class LiveClassesPage extends StatefulWidget {
  @override
  _LiveClassesPageState createState() => _LiveClassesPageState();
}

class _LiveClassesPageState extends State<LiveClassesPage> {
  bool showRequestedSessionCard = true;
  String searchQuery = '';
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: Text('Live Classes'),
        actions: [
          IconButton(
            onPressed: () {
              // Handle notifications
            },
            icon: Icon(Icons.notifications),
          ),
          IconButton(
            onPressed: () {
              // Handle search functionality
              _showSearchDialog(context);
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Available Sessions',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: _buildSessionList(context),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _requestLiveSession(context);
              },
              child: Text('Request Live Session'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _startLiveSession('sessionId', 'Zoom');
              },
              child: Text('Start Live Session'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionList(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('live_sessions').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No live sessions available'));
        }
        return ListView(
          children: [
            if (showRequestedSessionCard) _buildRequestedSessionCard(),
            ...snapshot.data!.docs
                .where((doc) => doc['title']
                    .toString()
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()))
                .map((doc) {
              LiveSession session = LiveSession(
                title: doc['title'],
                sessionType: doc['sessionType'],
                sessionId: doc.id,
                teacher: doc['teacher'],
                platform: doc['platform'],
                url: doc['url'],
              );
              return ListTile(
                title: Text(session.title),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(session.sessionType == 'live'
                        ? 'Live Session'
                        : 'Recorded Session'),
                    Text('Teacher: ${session.teacher}'),
                  ],
                ),
                onTap: () {
                  session.sessionType == 'live'
                      ? _joinLiveSession(context, session)
                      : _viewRecordedSession(context, session);
                },
              );
            }).toList(),
          ],
        );
      },
    );
  }

  Widget _buildRequestedSessionCard() {
    // You can retrieve the requested session details from Firebase or use predefined values
    String name = 'John Doe';
    String email = 'john@example.com';
    String sessionTopic = 'Introduction to Flutter';
    String preferredDateTime = 'May 25, 2024, 10:00 AM';

    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Requested Live Session Details',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Name: $name'),
            Text('Email: $email'),
            Text('Session Topic: $sessionTopic'),
            Text('Preferred Date and Time: $preferredDateTime'),
          ],
        ),
      ),
    );
  }

  void _requestLiveSession(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController sessionTopicController = TextEditingController();
    TextEditingController dateTimeController = TextEditingController();

    BuildContext parentContext = context;

    showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return AlertDialog(
              title: Text('Request Live Session'),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(labelText: 'Your Name'),
                    ),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(labelText: 'Email'),
                    ),
                    TextField(
                      controller: sessionTopicController,
                      decoration: InputDecoration(labelText: 'Session Topic'),
                    ),
                    TextField(
                      controller: dateTimeController,
                      decoration: InputDecoration(labelText: 'Preferred Date and Time'),
                    ),
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    String name = nameController.text;
                    String email = emailController.text;
                    String sessionTopic = sessionTopicController.text;
                    String dateTime = dateTimeController.text;
                    _submitRequest(name, email, sessionTopic, dateTime, parentContext);
                    setState(() {
                      showRequestedSessionCard = false;
                    });
                  },
                  child: Text('Submit'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _submitRequest(String name, String email, String sessionTopic, String preferredDateTime, BuildContext context) {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      firestore.collection('live_session_requests').add({
        'name': name,
        'email': email,
        'sessionTopic': sessionTopic,
        'preferredDateTime': preferredDateTime,
        'timestamp': FieldValue.serverTimestamp(),
      }).then((_) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Success'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Live session request submitted successfully!'),
                  SizedBox(height: 20),
                  _buildSessionCard(name, email, sessionTopic, preferredDateTime),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }).catchError((error) {
        print('Error submitting live session request: $error');
        _showErrorDialog(context, 'Error submitting live session request: $error');
      });
    } catch (e) {
      print('Error submitting live session request: $e');
      _showErrorDialog(context, 'Error submitting live session request: $e');
    }
  }

  Widget _buildSessionCard(String name, String email, String sessionTopic, String preferredDateTime) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Requested Live Session Details',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Name: $name'),
            Text('Email: $email'),
            Text('Session Topic: $sessionTopic'),
            Text('Preferred Date and Time: $preferredDateTime'),
          ],
        ),
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _joinLiveSession(BuildContext context, LiveSession session) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      // Update the Firestore document to indicate that a user has joined the live session
      await firestore.collection('live_sessions').doc(session.sessionId).update({
        'participants': FieldValue.arrayUnion(['currentUserUid']), // Add the UID of the current user
      });

      // Show a confirmation dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Join Live Session'),
            content: Text('You are joining the live session "${session.title}"'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // Launch the URL to join the live session
                  _launchURL(session.url);
                },
                child: Text('Join'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
              ),
            ],
          );
        },
      );
    } catch (error) {
      print('Error joining live session: $error');
      _showErrorDialog(context, 'Error joining live session: $error');
    }
  }

  void _viewRecordedSession(BuildContext context, LiveSession session) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      // Update the Firestore document to log that the user has viewed the recorded session
      await firestore.collection('live_sessions').doc(session.sessionId).update({
        'views': FieldValue.increment(1), // Increment the views count
      });

      // Show a confirmation dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('View Recorded Session'),
            content: Text('You are viewing the recorded session "${session.title}"'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // Launch the URL to view the recorded session
                  _launchURL(session.url);
                },
                child: Text('View'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
              ),
            ],
          );
        },
      );
    } catch (error) {
      print('Error viewing recorded session: $error');
      _showErrorDialog(context, 'Error viewing recorded session: $error');
    }
  }

  void _startLiveSession(String sessionId, String platform) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      // Implement logic to start the live session on the chosen platform
      String url;
      if (platform == 'Zoom') {
        url = 'https://zoom.us/start/sessionId';
      } else if (platform == 'Google Meet') {
        url = 'https://meet.google.com/start/sessionId';
      } else if (platform == 'Microsoft Teams') {
        url = 'https://teams.microsoft.com/start/sessionId';
      } else {
        throw Exception('Platform not supported');
      }

      // Update the Firestore document to indicate that the live session has started
      await firestore.collection('live_sessions').doc(sessionId).update({
        'started': true, // Add a field to indicate that the session has started
        'start_time': FieldValue.serverTimestamp(), // Add the start time of the session
      });

      // Launch the URL to start the live session
      _launchURL(url);
    } catch (error) {
      print('Error starting live session: $error');
      _showErrorDialog(context, 'Error starting live session: $error');
    }
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Search Sessions'),
          content: TextField(
            controller: searchController,
            decoration: InputDecoration(labelText: 'Enter session title'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  searchQuery = searchController.text;
                });
                Navigator.of(context).pop();
              },
              child: Text('Search'),
            ),
            TextButton(
              onPressed: () {
                searchController.clear();
                setState(() {
                  searchQuery = '';
                });
                Navigator.of(context).pop();
              },
              child: Text('Clear'),
            ),
          ],
        );
      },
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
