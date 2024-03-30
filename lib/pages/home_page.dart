/*import 'package:firstproject/models/catalog.dart';
import 'package:firstproject/widgets/drawer.dart';
import 'package:firstproject/widgets/item_widget.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String profileName;
  late String gmailUsername;

  @override
  void initState() {
    super.initState();
    loadData();
    // Set default values for profileName and gmailUsername
    profileName = "Guest";
    gmailUsername = "guest@gmail.com";
  }

  loadData() async {
    await Future.delayed(Duration(seconds: 2));
    final catalogJson =
        await rootBundle.loadString("assets/files/catalog.json");
    final decodedData = jsonDecode(catalogJson);
    var productsData = decodedData["products"];
    CatalogModel.items = List.from(productsData)
        .map<Item>((item) => Item.fromMap(item))
        .toList();

    setState(() {
      // empty block, just re-renders the widget with new data
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Catalog App"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: (CatalogModel.items != null && CatalogModel.items.isNotEmpty)
            ? GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16),
                itemBuilder: ((context, index) {
                  final item = CatalogModel.items[index];
                  return Card(
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: GridTile(
                      header: Container(
                        child: Text(item.name),
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple,
                        ),
                      ),
                      child: Image.network(item.image),
                      footer: Container(
                        child: Text(item.price.toString()),
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                }),
                itemCount: CatalogModel.items.length)
            //  ListView.builder(
            //     itemCount: CatalogModel.items.length,
            //     itemBuilder: (context, index) {
            //       return ItemWidget(
            //         item: CatalogModel.items[index],
            //       );
            //     },
            //   )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
      drawer: MyDrawer(
        profileName: profileName ?? "Guest", // Provide default value if null
        gmailUsername:
            gmailUsername ?? "guest@gmail.com", // Provide default value if null
      ),
    );
  }
}
*/
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firstproject/widgets/drawer.dart';
import 'package:firstproject/pages/academicPage.dart';
import 'package:firstproject/pages/profile_info.dart';
import 'package:firstproject/pages/discussion_forum_page.dart';
import 'package:firstproject/pages/manage_profile.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String profileName;
  late String gmailUsername;

  @override
  void initState() {
    super.initState();
    profileName = "Guest";
    gmailUsername = "guest@gmail.com";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("E-Learning Platform"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileInfo(profileName: profileName, gmailUsername: gmailUsername),
            SizedBox(height: 16),
            _buildModuleCard(
              title: 'Google Classroom',
              icon: Icons.class_,
              onTap: () {
                _launchURL('https://classroom.google.com/');
              },
            ),
            SizedBox(height: 16),
            _buildModuleCard(
              title: 'Academic',
              icon: Icons.school,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AcademicPage()),
                );
              },
            ),
            SizedBox(height: 16),
            _buildModuleCard(
              title: 'Discussion Forum',
              icon: Icons.chat,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DiscussionForumPage()),
                );
              },
            ),
            SizedBox(height: 16),
            _buildModuleCard(
              title: 'Manage Profile',
              icon: Icons.person,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ManageProfile()),
                );
              },
            ),
            SizedBox(height: 16),
            _buildModuleCard(
              title: 'Share App',
              icon: Icons.share,
              onTap: () {
                _shareApp();
              },
            ),
          ],
        ),
      ),
      drawer: MyDrawer(
        profileName: profileName ?? "Guest",
        gmailUsername: gmailUsername ?? "guest@gmail.com",
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

  void _shareApp() {
    // Implement share app functionality here
    // Example:
    // Share.share('Check out this awesome e-learning app!');
  }

  Widget _buildModuleCard({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.only(bottom: 16),
      color: Colors.deepPurple, // Use deepPurple color
      child: ListTile(
        leading: Icon(icon, color: Colors.white), // Set icon color to white
        title: Text(
          title,
          style: TextStyle(color: Colors.white), // Set text color to white
        ),
        onTap: onTap,
      ),
    );
  }
}


