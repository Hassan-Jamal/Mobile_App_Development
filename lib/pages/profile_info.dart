import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

class QuoteProvider {
  Future<String> fetchQuote() async {
    final response = await http.get(Uri.parse('https://api.quotable.io/random'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['content'];
    } else {
      throw Exception('Failed to load quote');
    }
  }
}

class ProfileInfo extends StatefulWidget {
  final String profileName;
  final String gmailUsername;

  const ProfileInfo({
    required this.profileName,
    required this.gmailUsername,
    Key? key,
  }) : super(key: key);

  @override
  _ProfileInfoState createState() => _ProfileInfoState();
}

class _ProfileInfoState extends State<ProfileInfo> {
  late String _quote = '';
  final QuoteProvider _quoteProvider = QuoteProvider();
  late User? _user;
  late Timer _quoteTimer;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
    _quoteTimer = Timer.periodic(const Duration(seconds: 20), (timer) {
      fetchQuote();
    });
    fetchQuote();
  }

  @override
  void dispose() {
    _quoteTimer.cancel(); // Cancel the timer to avoid memory leaks
    super.dispose();
  }

  Future<void> fetchQuote() async {
    try {
      final quote = await _quoteProvider.fetchQuote();
      setState(() {
        _quote = quote;
      });
    } catch (e) {
      print('Error fetching quote: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Profile Information",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 16),
            if (_user != null) ...[
              Text(
                "Username: ${_user!.displayName ?? ''}",
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Gmail Address: ${_user!.email ?? ''}",
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ],
            const SizedBox(height: 16),
            Text(
              "Dynamic Quote: $_quote",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
