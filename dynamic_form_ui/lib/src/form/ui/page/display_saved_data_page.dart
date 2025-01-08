import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DisplayResponsesPage extends StatelessWidget {
  final List<String> responses = [];

  DisplayResponsesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( leading: IconButton(
        onPressed: () {Get.back();},
    icon: const Icon(Icons.arrow_back_sharp)),title: Text('Form Responses')),
      body: FutureBuilder<void>(
        future: _loadResponses(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (responses.isEmpty) {
            return Center(child: Text('No responses saved.'));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: responses.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(responses[index]),
                );
              },
            ),
          );
        },
      ),
    );
  }

  // Load saved responses from shared preferences
  Future<void> _loadResponses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    responses.clear();

    // Loop through all the keys and fetch the stored responses
    prefs.getKeys().forEach((key) {
      String? response = prefs.getString(key);
      if (response != null && response.isNotEmpty) {
        responses.add('$key: $response');
      }
    });
  }
}
