import 'package:flutter/material.dart';
import 'package:firstproject/utilis/routes.dart';
import 'package:url_launcher/url_launcher.dart';

class DiscussionForumPage extends StatefulWidget {
  @override
  _DiscussionForumPageState createState() => _DiscussionForumPageState();
}

class _DiscussionForumPageState extends State<DiscussionForumPage> {
  TextEditingController _searchController = TextEditingController();
  bool _showNotifications = false;
  bool _filterOption1 = false;
  bool _filterOption2 = false;

  void _toggleFilterOption1() {
    setState(() {
      _filterOption1 = !_filterOption1;
    });
  }

  void _toggleFilterOption2() {
    setState(() {
      _filterOption2 = !_filterOption2;
    });
  }

  void _applyFilters() {
    // Implement logic to apply the selected filter options
    print('Filter alphabetic order: $_filterOption1');
    print('Filter numbering order : $_filterOption2');
    // You can use the values of _filterOption1 and _filterOption2 to filter discussions
  }

  Future<void> _sendMessage(BuildContext context) async {
    final Uri _emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'addawarga@gmail.com',
      queryParameters: {
        'subject': 'Discussion Forum Message',
        'body': 'Enter your message here...',
      },
    );
    final String url = _emailLaunchUri.toString();
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
          title: Text('Filter Discussions'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Select filter options:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                CheckboxListTile(
                  title: Text('Filter option 1'),
                  value: _filterOption1,
                  onChanged: (bool? value) {
                    setState(() {
                      _filterOption1 = value ?? false;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text('Filter option 2'),
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
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _applyFilters();
                Navigator.of(context).pop();
              },
              child: Text('Apply'),
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
        builder: (context) => NewDiscussionPage(),
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
        title: Text(
          "Discussion Forum",
          style:
              TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
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
            icon: Icon(Icons.filter_alt),
            onPressed: () => _filterDiscussion(context),
          ),
          IconButton(
            icon: _showNotifications
                ? Icon(Icons.notifications_active)
                : Icon(Icons.notifications),
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
            SizedBox(height: 20),
            Text(
              "Welcome to the Discussion Forum",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _startNewDiscussion(context),
              child: Text("Start New Discussion"),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _sendMessage(context),
              child: Text("Send Message"),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.orange,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NewDiscussionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "New Discussion",
          style:
              TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Title:",
              style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
            SizedBox(height: 8.0),
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
                    EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              "Content:",
              style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
            SizedBox(height: 8.0),
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
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Add functionality to submit the new discussion
                },
                child: Text("Submit"),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
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
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
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
