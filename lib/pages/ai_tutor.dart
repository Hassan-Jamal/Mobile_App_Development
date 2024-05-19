import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AITutorPage extends StatefulWidget {
  @override
  _AITutorPageState createState() => _AITutorPageState();
}

class _AITutorPageState extends State<AITutorPage> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, String>> _chat = [];

  Future<void> _getResponse(String query) async {
    final String apiKey = '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';
    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': 'text-davinci-003',
        'prompt': query,
        'max_tokens': 150,
        'temperature': 0.7,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      print('Response Data: $responseData');

      String responseText = 'No response';
      if (responseData['choices'] != null && responseData['choices'].isNotEmpty) {
        responseText = responseData['choices'][0]['text'].trim();
      }

      setState(() {
        _chat.add({
          'question': query,
          'answer': responseText
        });
      });
    } else {
      setState(() {
        _chat.add({
          'question': query,
          'answer': 'Error: ${response.reasonPhrase}'
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AI Tutor'),
        backgroundColor: Colors.cyan,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _chat.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    "Q: ${_chat[index]['question']}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("A: ${_chat[index]['answer']}"),
                  tileColor: index % 2 == 0 ? Colors.blue.shade100 : Colors.green.shade100,
                  contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Ask a question...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    _getResponse(_controller.text);
                    _controller.clear();
                  },
                  child: Text('Get Answer'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: AITutorPage(),
  ));
}
