import 'dart:convert';
import 'package:dynamic_form_ui/src/form/ui/page/display_saved_data_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // for rootBundle
import 'package:get/get.dart';

import 'src/form/model/add_form_data_model.dart';
import 'src/form/ui/page/form_page.dart';
import 'utils/theme.dart';
import 'utils/utils.dart';

// Main entry point of the app
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FormDataModel formDataModel = await loadFormDataFromAssets();
  logg.i(formDataModel.toJson()); // This prints correctly, ensuring data is loaded

  runApp(
    GetMaterialApp(
      theme: appPrimaryTheme,
      home: HomePage(formDataModel: formDataModel),  // HomePage is our new screen
    ),
  );
}

// Load JSON from assets and parse it into FormDataModel
Future<FormDataModel> loadFormDataFromAssets() async {
  // Load the JSON string from assets
  String jsonString = await rootBundle.loadString('assets/json/hnicustomersmet.json');  

  // Parse the JSON string into a Map
  Map<String, dynamic> jsonMap = jsonDecode(jsonString);

  // Convert the Map into FormDataModel using fromJson() constructor
  return FormDataModel.fromJson(jsonMap);
}

// Home page with options to add or display data
class HomePage extends StatelessWidget {
  final FormDataModel formDataModel;

  HomePage({Key? key, required this.formDataModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                // Navigate to DynamicFormPage
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DynamicFormPage(formDataModel: formDataModel)),
                );
              },
              child: const Text('Add Data'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                // Check if data exists in SharedPreferences
                // SharedPreferences prefs = await SharedPreferences.getInstance();
                // bool hasData = prefs.getBool('hasData') ?? false;

                // if (hasData) {
                  // If data exists, navigate to Display Data Screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DisplayResponsesPage()),  // Assuming this screen exists
                  );
                // } else {
                //   // If no data, show an alert or route to Add Form Screen
                //   ScaffoldMessenger.of(context).showSnackBar(
                //     const SnackBar(content: Text('No data found! Please add data first.')),
                //   );
                // }
              },
              child: const Text('Display Data'),
            ),
          ],
        ),
      ),
    );
  }
}
