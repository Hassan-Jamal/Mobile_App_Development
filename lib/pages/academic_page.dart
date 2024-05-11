// ignore: file_names
// ignore: file_names
// ignore: file_names
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Subject {
  final String name;
  final String description;
  final double price;

  Subject({
    required this.name,
    required this.description,
    required this.price,
  });
}
class AcademicPage extends StatefulWidget {
  const AcademicPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AcademicPageState createState() => _AcademicPageState();
}

class _AcademicPageState extends State<AcademicPage> {
  List<Subject> subjects = [];
  List<Subject> cart = [];
  TextEditingController subjectNameController = TextEditingController();
  TextEditingController subjectDescriptionController = TextEditingController();
  TextEditingController subjectPriceController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadSubjects();
  }

  void loadSubjects() async {
    // Load course data from a JSON file
    String jsonData = await rootBundle.loadString('assets/files/courses.json');
    List<dynamic> courses = json.decode(jsonData);

    setState(() {
      subjects = courses.map((course) {
        return Subject(
          name: course['name'],
          description: course['description'],
          price: course['price'].toDouble(),
        );
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Academic Page'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {});
              },
              decoration: const InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: subjects.length,
              itemBuilder: (context, index) {
                final subject = subjects[index];
                if (searchController.text.isNotEmpty &&
                    !subject.name.toLowerCase().contains(
                          searchController.text.toLowerCase(),
                        )) {
                  return const SizedBox.shrink();
                }
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      subject.name,
                      style:
                          const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text(
                          subject.description,
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '\$${subject.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    trailing: GestureDetector(
                      onTap: () {
                        setState(() {
                          cart.add(subject);
                        });
                      },
                      child: const Icon(Icons.add_shopping_cart),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.length,
              itemBuilder: (context, index) {
                final item = cart[index];
                return ListTile(
                  title: Text(item.name),
                  subtitle: Text('\$${item.price.toStringAsFixed(2)}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_shopping_cart),
                    onPressed: () {
                      setState(() {
                        cart.removeAt(index);
                      });
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
  padding: const EdgeInsets.all(8.0),
  child: Align(
    alignment: Alignment.bottomLeft,
    child: Text(
      'Total: \$${calculateTotalPrice().toStringAsFixed(2)}',
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
  ),
),

        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showAddSubjectDialog();
        },
        label: const Text('Add Subject'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }

  void _showAddSubjectDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Demanded Subject'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: subjectNameController,
                  decoration: const InputDecoration(labelText: 'Subject Name'),
                ),
                TextField(
                  controller: subjectDescriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                TextField(
                  controller: subjectPriceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Price'),
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
            ElevatedButton(
              onPressed: () {
                _addSubject();
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _addSubject() {
    String name = subjectNameController.text;
    String description = subjectDescriptionController.text;
    double? price;
    if (subjectPriceController.text.isNotEmpty) {
      price = double.tryParse(subjectPriceController.text);
    }

    if (name.isNotEmpty && description.isNotEmpty && price != null) {
      setState(() {
        subjects.add(Subject(
          name: name,
          description: description,
          price: price!,
        ));
      });
    }
  }

  double calculateTotalPrice() {
    return cart.fold(0, (total, item) => total + item.price);
  }
}
