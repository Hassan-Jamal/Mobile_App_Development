import 'package:firstproject/models/catalog.dart';
import 'package:firstproject/widgets/drawer.dart';
import 'package:firstproject/widgets/item_widget.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  loadData() async {
    await Future.delayed(Duration(seconds: 2));
    final catalogJson =
        await rootBundle.loadString("assets/files/catalog.json");
    //print(catalogJson);
    final decodedData = jsonDecode(
        catalogJson); //string/othertype to json conversion and jsonEncode for json/othertype to String
    //print(decodedData);
    var productsData = decodedData["products"];
    //print(productsData);
    CatalogModel.items = List.from(productsData)
        .map<Item>((item) => Item.fromMap(item))
        .toList();

    setState(() {
      // empty block, just re-renders the widget with new data
    });
  }

  @override
  Widget build(BuildContext context) {
    //final dummyList = List.generate(50, (index) => CatalogModel.items[0]);
    int days = 30;
    String name = "Hassan Jamal";
    return Scaffold(
      appBar: AppBar(
        title: Text("Catalog App"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: (CatalogModel.items != null && CatalogModel.items.isNotEmpty)
            ? ListView.builder(
                itemCount: CatalogModel.items.length,
                itemBuilder: (context, index) {
                  return ItemWidget(
                    item: CatalogModel.items[index],
                  );
                },
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
      drawer: MyDrawer(),
    );
  }
}
