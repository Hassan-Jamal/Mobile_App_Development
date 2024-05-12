import 'package:flutter/material.dart';

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

class PaymentMethodsPage extends StatefulWidget {
  final List<Subject> cart;

  const PaymentMethodsPage({Key? key, required this.cart}) : super(key: key);

  @override
  _PaymentMethodsPageState createState() => _PaymentMethodsPageState();
}

class _PaymentMethodsPageState extends State<PaymentMethodsPage> {
  late PayPalConfiguration _config;

  @override
  void initState() {
    super.initState();
    _initializePayPal();
  }

  void _initializePayPal() async {
    final String clientId = ''; // Your PayPal client ID
    final String secret = ''; // Your PayPal secret
    final bool isProduction = false; // Set to true for production

    

    final PayPalSDK sdk = PayPalSDK(configuration: _config);

    // Initialize PayPal
    await sdk.initialize();

    // No need to configure SDK again
    // sdk.configure(sdk);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Methods'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Selected Items for Checkout:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Display selected items
            ListView.builder(
              shrinkWrap: true,
              itemCount: widget.cart.length,
              itemBuilder: (context, index) {
                final item = widget.cart[index];
                return ListTile(
                  title: Text(item.name),
                  subtitle: Text('\$${item.price.toStringAsFixed(2)}'),
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _startPayment();
              },
              child: const Text('Proceed to Payment'),
            ),
          ],
        ),
      ),
    );
  }

  void _startPayment() async {
    final PayPalPaymentDetails payment = PayPalPaymentDetails(
      amount: widget.cart.fold(0, (total, item) => total + item.price),
      currencyCode: 'USD',
      shortDescription: 'Payment for academic subjects',
      intent: 'sale',
    );

    final PayPalSDK sdk = PayPalSDK(configuration: _config);
    final result = await sdk.startPayment(payment);
    if (result == 'success') {
      _showSuccessDialog();
    } else {
      _showErrorDialog();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Payment Successful'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Thank you for your payment.'),
              const SizedBox(height: 8),
              const Text('Your PayPal account details:'),
              const Text('Email: your_email@example.com'),
              const SizedBox(height: 8),
              const Text('Please send a screenshot to your email address.'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Payment Error'),
          content: const Text('There was an error processing your payment.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

class PayPalPaymentDetails {
  final double amount;
  final String currencyCode;
  final String shortDescription;
  final String intent;

  PayPalPaymentDetails({
    required this.amount,
    required this.currencyCode,
    required this.shortDescription,
    required this.intent,
  });
}

class PayPalSDK {
  final PayPalConfiguration configuration;

  PayPalSDK({required this.configuration});

  Future<String> startPayment(PayPalPaymentDetails payment) async {
    // Implement the payment logic here
    // For example, you can interact with PayPal APIs to start the payment process
    // and return the payment result ('success' or 'failure') accordingly
    return 'success'; // Placeholder for the payment result
  }

  Future<void> initialize() async {
    // Implement the initialization logic here
    // For example, you can initialize the PayPal SDK with the provided configuration
    // This method should initialize any necessary resources or configurations for PayPal payments
  }
}

class PayPalConfiguration {
  final String clientId;
  final String secret;
  final bool isProductionEnvironment;

  PayPalConfiguration({
    required this.clientId,
    required this.secret,
    required this.isProductionEnvironment,
  });
}