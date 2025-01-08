import 'dart:convert';
import 'src/form/model/add_form_data_model.dart';
import 'src/form/ui/page/form_page.dart';
import 'utils/theme.dart';
import 'utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // for rootBundle


// Main entry point of the app
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load the form data from assets
  FormDataModel formDataModel = await loadFormDataFromAssets();
  logg.i(formDataModel.toJson()); //this prints correctly but empty screen is snown

  runApp(
    MaterialApp(
      theme: appPrimaryTheme,
      home: DynamicFormPage(formDataModel: formDataModel),
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
