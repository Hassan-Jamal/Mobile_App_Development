import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class LiveSession {
  final String title;
  final String sessionType; // 'live' or 'recorded'
  final String sessionId;
  final String teacher;
  final String platform;

  LiveSession({
    required this.title,
    required this.sessionType,
    required this.sessionId,
    required this.teacher,
    required this.platform,
  });
}
class LiveClassesPage extends StatefulWidget {
  @override
  _LiveClassesPageState createState() => _LiveClassesPageState();
}

class _LiveClassesPageState extends State<LiveClassesPage> {
  bool showRequestedSessionCard = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: Text('Live Classes'),
        actions: [
          IconButton(
            onPressed: () {
              // Add your action for the first button here
            },
            icon: Icon(Icons.notifications), // Add your icon for the first button here
          ),
          IconButton(
            onPressed: () {
              // Add your action for the second button here
            },
            icon: Icon(Icons.search), // Add your icon for the second button here
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
                _startLiveSession('sessionId', 'Zoom'); // Replace 'sessionId' with the actual session ID and 'Zoom' with the chosen platform
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
            ...snapshot.data!.docs.map((doc) {
              LiveSession session = LiveSession(
                title: doc['title'],
                sessionType: doc['sessionType'],
                sessionId: doc.id,
                teacher: doc['teacher'],
                platform: doc['platform'],
              );
              return ListTile(
                title: Text(session.title),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(session.sessionType == 'live' ? 'Live Session' : 'Recorded Session'),
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
            // Add more details such as teacher name and platform here
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
                    // Set showRequestedSessionCard to false
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
            // Add more details such as teacher name and platform here
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

  void _joinLiveSession(BuildContext context, LiveSession session) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Update the Firestore document to indicate that a user has joined the live session
    firestore.collection('live_sessions').doc(session.sessionId).update({
      'participants': FieldValue.arrayUnion(['currentUserUid']), // Add the UID of the current user
    }).then((_) {
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
                  // Close the dialog
                  Navigator.of(context).pop();
                  // Implement your logic to join the live session here
                },
                child: Text('Join'),
              ),
              TextButton(
                onPressed: () {
                  // Close the dialog
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
              ),
            ],
          );
        },
      );
    }).catchError((error) {
      // Handle errors
      print('Error joining live session: $error');
      _showErrorDialog(context, 'Error joining live session: $error');
    });
  }

  void _viewRecordedSession(BuildContext context, LiveSession session) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Update the Firestore document to log that the user has viewed the recorded session
    firestore.collection('live_sessions').doc(session.sessionId).update({
      'views': FieldValue.increment(1), // Increment the views count
    }).then((_) {
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
                  // Close the dialog
                  Navigator.of(context).pop();
                  // Implement your logic to view the recorded session here
                },
                child: Text('View'),
              ),
              TextButton(
                onPressed: () {
                  // Close the dialog
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
              ),
            ],
          );
        },
      );
    }).catchError((error) {
      // Handle errors
      print('Error viewing recorded session: $error');
      _showErrorDialog(context, 'Error viewing recorded session: $error');
    });
  }

  void _startLiveSession(String sessionId, String platform) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Implement logic to start the live session on the chosen platform
    if (platform == 'Zoom') {
      // Logic to start the session on Zoom
      print('Starting live session on Zoom');
    } else if (platform == 'Google Meet') {
      // Logic to start the session on Google Meet
      print('Starting live session on Google Meet');
    } else if (platform == 'Microsoft Teams') {
      // Logic to start the session on Microsoft Teams
      print('Starting live session on Microsoft Teams');
    } else {
      print('Platform not supported');
      return;
    }

    // Update the Firestore document to indicate that the live session has started
    firestore.collection('live_sessions').doc(sessionId).update({
      'started': true, // Add a field to indicate that the session has started
      'start_time': FieldValue.serverTimestamp(), // Add the start time of the session
    }).then((_) {
      print('Live session started');
    }).catchError((error) {
      // Handle errors
      print('Error starting live session: $error');
    });
  }
}
