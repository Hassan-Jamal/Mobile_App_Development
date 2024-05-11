import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DiscussionForumPage extends StatefulWidget {
  const DiscussionForumPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DiscussionForumPageState createState() => _DiscussionForumPageState();
}

class _DiscussionForumPageState extends State<DiscussionForumPage> {
  bool _showNotifications = false;
  bool _filterOption1 = false;
  bool _filterOption2 = false;

  // ignore: unused_element
  void _toggleFilterOption1() {
    setState(() {
      _filterOption1 = !_filterOption1;
    });
  }


  void _applyFilters() {
    // Implement logic to apply the selected filter options
    if (kDebugMode) {
      print('Filter alphabetic order: $_filterOption1');
    }
    if (kDebugMode) {
      print('Filter numbering order : $_filterOption2');
    }
    // You can use the values of _filterOption1 and _filterOption2 to filter discussions
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
    // ignore: deprecated_member_use
    if (await canLaunch(url)) {
      // ignore: deprecated_member_use
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

    // Show a snackbar with the updated notification status
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

  void _startNewDiscussion(BuildContext context) {
    // Navigate to a new page where users can create a new discussion
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const NewDiscussionPage(),
      ),
    );
  }

  void _performSearch(BuildContext context, String query) {
    // Implement search functionality here
    // For now, just show a snackbar
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Searching for: $query")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Discussion Forum",
          style:
              TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: SearchBarDelegate(
                  onSearch: (query) => _performSearch(context, query),
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
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _startNewDiscussion(context),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
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
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
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

class NewDiscussionPage extends StatelessWidget {
  const NewDiscussionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "New Discussion",
          style:
              TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold),
        ),
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
                  // Add functionality to submit the new discussion
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
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
