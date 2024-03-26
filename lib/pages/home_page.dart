import 'package:firstproject/models/catalog.dart';
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
                      header: Container(child: Text(item.name),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color:  Colors.deepPurple,
                      ),
                      ),
                      child: Image.network(item.image),
                      footer:  Container(child: Text(item.price.toString()),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color:  Colors.deepPurple,
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
