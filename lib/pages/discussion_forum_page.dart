import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DiscussionForumPage extends StatefulWidget {
  const DiscussionForumPage({Key? key}) : super(key: key);

  @override
  _DiscussionForumPageState createState() => _DiscussionForumPageState();
}

class _DiscussionForumPageState extends State<DiscussionForumPage> {
  bool _showNotifications = false;
  bool _filterOption1 = false;
  bool _filterOption2 = false;

  // List to store messages
  List<Message> _messages = [];

  void _applyFilters() {
    // Reference to the Firestore collection
    CollectionReference discussionsRef =
        FirebaseFirestore.instance.collection('discussions');

    // Clear any existing filters
    Query discussionsQuery = discussionsRef;

    // Apply filters based on selected options
    if (_filterOption1 && !_filterOption2) {
      // Apply filter option 1
      // For example, filter discussions alphabetically
      discussionsQuery = discussionsQuery.orderBy('title');
    } else if (!_filterOption1 && _filterOption2) {
      // Apply filter option 2
      // For example, filter discussions by date
      discussionsQuery = discussionsQuery.orderBy('timestamp');
    } else if (_filterOption1 && _filterOption2) {
      // Apply both filters
      // For example, filter discussions alphabetically and by date
      discussionsQuery =
          discussionsQuery.orderBy('title').orderBy('timestamp');
    }

    // Execute the query
    discussionsQuery.get().then((querySnapshot) {
      // Process the results
      querySnapshot.docs.forEach((doc) {
        // Handle each discussion document
        // For example, update UI to display discussions
      });
    }).catchError((error) {
      // Handle any errors
      print("Failed to fetch discussions: $error");
    });
  }

  Future<void> _sendMessage(BuildContext context) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'addawarga@gmail.com',
      queryParameters: {
        'subject': 'Discussion Forum Message',
        'body': 'Enter your message here...',
      },
    );
    final String url = emailLaunchUri.toString();
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _filterDiscussion(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Filter Discussions'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Select filter options:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                CheckboxListTile(
                  title: const Text('Filter option 1'),
                  value: _filterOption1,
                  onChanged: (bool? value) {
                    setState(() {
                      _filterOption1 = value ?? false;
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text('Filter option 2'),
                  value: _filterOption2,
                  onChanged: (bool? value) {
                    setState(() {
                      _filterOption2 = value ?? false;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _applyFilters();
                Navigator.of(context).pop();
              },
              child: const Text('Apply'),
            ),
          ],
        );
      },
    );
  }

  void _toggleNotifications(BuildContext context) {
    setState(() {
      _showNotifications = !_showNotifications;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_showNotifications
            ? 'Notifications enabled'
            : 'Notifications disabled'),
      ),
    );

    // Implement notification functionality
    // Here, you can add the logic to enable/disable notifications or perform any other action related to notifications
  }

  void _startNewDiscussion(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const NewDiscussionPage(),
      ),
    );

    if (result != null && result is Map<String, dynamic>) {
      final title = result['title'];
      final content = result['content'];
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('discussions').add({
          'title': title,
          'content': content,
          'creator': user.uid,
          'timestamp': DateTime.now(),
        });
      }
    }

    // Fetch messages after adding the new discussion
    _fetchMessages();
  }

 void _fetchMessages() {
  FirebaseFirestore.instance
      .collection('discussions')
      .orderBy('timestamp', descending: true)
      .limit(20) // Limit the number of messages to fetch
      .snapshots()
      .listen((QuerySnapshot snapshot) {
    // Clear existing messages list before updating with new messages
    setState(() {
      _messages.clear();
    });

    snapshot.docs.forEach((DocumentSnapshot doc) {
      // Extract message data from document
      final title = doc['title'];
      final content = doc['content'];
      final creator = doc['creator'];
      
      // Convert Firestore Timestamp to Dart DateTime
      final timestamp = (doc['timestamp'] as Timestamp).toDate();

      // Create a Message object from the data
      final message = Message(
        title: title,
        content: content,
        creator: creator,
        timestamp: timestamp,
      );

      // Add the message to the list of messages
      setState(() {
        _messages.add(message);
      });
    });
  });
}


  void _performSearch(BuildContext context, String query) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Searching for: $query")));
    // You can perform Firestore queries to search for discussions here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Discussion Forum",
        
        ),
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: SearchBarDelegate(
                  onSearch: (query) =>
                      _performSearch(context, query),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: () => _filterDiscussion(context),
          ),
          IconButton(
            icon: _showNotifications
                ? const Icon(Icons.notifications_active)
                : const Icon(Icons.notifications),
            onPressed: () => _toggleNotifications(context),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/discuss_image.png',
              fit: BoxFit.cover,
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 20),
            const Text(
              "Welcome to the Discussion Forum",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold
                  ),
            ),
            //backgroundColor: Colors.red,
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _startNewDiscussion(context),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(
                    horizontal: 40, vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
              child: const Text("Start New Discussion"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _sendMessage(context),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(
                    horizontal: 40, vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
              child: const Text("Send Message"),
            ),
          ],
        ),
      ),
    );
  }
}

// Define a class to represent individual messages
class Message {
  final String title;
  final String content;
  final String creator;
  final DateTime timestamp;

  Message({
    required this.title,
    required this.content,
    required this.creator,
    required this.timestamp,
  });
}

class NewDiscussionPage extends StatelessWidget {
  const NewDiscussionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "New Discussion",
          
        ),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Title:",
              style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
            const SizedBox(height: 8.0),
            TextFormField(
              decoration: InputDecoration(
                hintText: "Enter discussion title",
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              "Content:",
              style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: TextFormField(
                maxLines: null,
                expands: true,
                decoration: InputDecoration(
                  hintText: "Enter discussion content",
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, {
                    'title': 'Discussion Title', // Replace with actual title
                    'content': 'Discussion Content', // Replace with actual content
                  });
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                ),
                child: const Text("Submit"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchBarDelegate extends SearchDelegate<String?> {
  final Function(String query) onSearch;

  SearchBarDelegate({required this.onSearch});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    onSearch(query);
    return Center(
      child: Text("Search results for '$query'"),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Center(
      child: Text("Suggestions for '$query'"),
    );
  }
}
