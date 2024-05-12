import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

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
  const AcademicPage({Key? key}) : super(key: key);

  @override
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
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      subject.name,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
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
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Positioned(
            bottom: 200.0, // Move the button upwards
            right: 16.0, // Position the button to the extreme right
            child: FloatingActionButton.extended(
              onPressed: _showAddSubjectDialog,
              label: const Text('Add Subject'),
              icon: const Icon(Icons.add),
              backgroundColor: Colors.deepPurple,
            ),
          ),
          SizedBox(height: 14),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PaymentPage(cart: cart)),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              elevation: 10,
              shadowColor: Colors.deepPurpleAccent.withOpacity(0.5),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.deepPurpleAccent, Colors.purple],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(50),
              ),
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Go to Checkout',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddSubjectDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Subject'),
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

class PaymentPage extends StatelessWidget {
  final List<Subject> cart;

  const PaymentPage({Key? key, required this.cart}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Page'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildPaymentMethodButton(
                name: 'PayPal',
                url: 'https://www.paypal.com/login',
                icon: Icons.payment,
                color: Colors.blue,
              ),
              _buildPaymentMethodButton(
                name: 'Stripe',
                url: 'https://dashboard.stripe.com/login',
                icon: Icons.credit_card,
                color: Colors.green,
              ),
              _buildPaymentMethodButton(
                name: 'Google Pay',
                url: 'https://pay.google.com/',
                icon: Icons.attach_money,
                color: Colors.orange,
              ),
              _buildPaymentMethodButton(
                name: 'Apple Pay',
                url: 'https://www.apple.com/apple-pay/',
                icon: Icons.phone_iphone,
                color: Colors.grey,
              ),
              _buildPaymentMethodButton(
                name: 'Amazon Pay',
                url: 'https://pay.amazon.com/',
                icon: Icons.shopping_cart,
                color: Colors.yellow,
              ),
              _buildPaymentMethodButton(
                name: 'Venmo',
                url: 'https://venmo.com/account/sign-in',
                icon: Icons.monetization_on,
                color: Colors.blueAccent,
              ),
              _buildPaymentMethodButton(
                name: 'Square',
                url: 'https://squareup.com/login',
                icon: Icons.square_foot,
                color: Colors.purple,
              ),
              _buildPaymentMethodButton(
                name: 'Zelle',
                url: 'https://www.zellepay.com/',
                icon: Icons.account_balance,
                color: Colors.teal,
              ),
              _buildPaymentMethodButton(
                name: 'Cash App',
                url: 'https://cash.app/login',
                icon: Icons.attach_money,
                color: Colors.green,
              ),
              _buildPaymentMethodButton(
                name: 'Payoneer',
                url: 'https://myaccount.payoneer.com/Login/Login.aspx',
                icon: Icons.account_circle,
                color: Colors.blueGrey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethodButton({
    required String name,
    required String url,
    required IconData icon,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ElevatedButton.icon(
        onPressed: () {
          _launchPaymentMethodLoginPage(url);
        },
        icon: Icon(icon),
        label: Text(name),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          textStyle: TextStyle(fontSize: 20.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
      ),
    );
  }

  Future<void> _launchPaymentMethodLoginPage(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

void main() {
  runApp(MaterialApp(
    home: PaymentPage(cart: []),
  ));
}
