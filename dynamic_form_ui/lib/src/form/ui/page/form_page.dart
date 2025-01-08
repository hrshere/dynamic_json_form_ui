import 'dart:io';

import '../../../../utils/utils.dart';
import '../../controller/form_data_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/colors_constant.dart';
import '../../model/add_form_data_model.dart';
import '../widgets/mandatory_title.dart';
import '../widgets/non_mandatory_title.dart';

class DynamicFormPage extends StatelessWidget {
  final FormDataModel formDataModel;
  final FormDataController formDataController = Get.put(FormDataController());

  DynamicFormPage({super.key, required this.formDataModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.arrow_back_sharp),
        ),
        title: const Text('add input'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                // Removed shrinkWrap to let ListView take available space
                children: buildFormFields(formDataModel),
              ),
            ),
            // Submit button
            ElevatedButton(
              onPressed: () {
                logg.i('Submit button pressed');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: BorderColor.orange,
                // Set the button color to orange
                minimumSize: const Size(double.infinity, 50),
                // Make the button width fill the screen, with height of 50
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                // Vertical padding
                shape: const RoundedRectangleBorder(
                  // Rectangular shape
                  borderRadius: BorderRadius.zero, // Remove rounded corners to make it rectangular
                ),
              ),
              child: const Text(
                'Submit',
                style: TextStyle(color: TextColor.white),
              ),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> buildFormFields(FormDataModel formDataModel) {
    List<Widget> fields = [];

    if (formDataModel.data?.getUserForm != null) {
      GetUserForm getUserForm = formDataModel.data!.getUserForm!;

      for (var question in getUserForm.questions ?? []) {
        fields.add(buildQuestionWidget(question));
      }
    }

    return fields;
  }

  Widget buildQuestionWidget(Questions question) {
    // Determine if the question is mandatory or optional
    bool isMandatory = question.isMandatoryField ?? false; // Assuming isMandatory is a field in the question

    // Show mandatory title if required
    Widget titleWidget = isMandatory
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: MandatoryTitle(text: question.question ?? ''),
          )
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: NonMandatoryTitle(text: question.question ?? ''),
          );

    switch (question.questionType) {
      case 'FORM':
        return Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                question.question ?? '',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              if (question.options != null && question.options!.isNotEmpty)
                for (var nestedForm in question.options!)
                  Column(
                    children: [
                      // Title for nested form (if exists)
                      Text(nestedForm.name ?? '', style: const TextStyle(fontSize: 16)),
                      // Row to display the two buttons side by side
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Location button
                          ElevatedButton(
                            onPressed: () {
                              formDataController.checkAndRequestLocationPermission();
                              logg.i('Location button pressed');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: BorderColor.orange,
                              minimumSize: const Size(150, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('Location'),
                          ),
                          // Selfie button
                          ElevatedButton(
                            onPressed: () {
                              formDataController.pickImageFromCamera();
                              logg.i('Selfie button pressed');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: BorderColor.orange,
                              minimumSize: const Size(150, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('Take a Selfie'),
                          ),
                        ],
                      ),
                      // Display captured location
                      Obx(() {
                        return formDataController.selectedLocation.value != null
                            ? Column(
                                children: [
                                  Text('Location: ${formDataController.selectedLocation.value}'),
                                  TextButton(
                                    onPressed: formDataController.resetLocation,
                                    child: const Text('Reset Location'),
                                  ),
                                ],
                              )
                            : const SizedBox();
                      }),
                      // Display captured selfie
                      Obx(() {
                        return formDataController.selectedSelfie.value != null
                            ? Column(
                                children: [
                                  Image.file(
                                    File(formDataController.selectedSelfie.value!.path),
                                    height: 100, // Adjust size as needed
                                  ),
                                  TextButton(
                                    onPressed: formDataController.resetSelfie,
                                    child: const Text('Reset Selfie'),
                                  ),
                                ],
                              )
                            : const SizedBox();
                      }),
                    ],
                  ),
            ],
          ),
        );
      case 'TEXTFORMFIELD':
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              titleWidget,
              TextFormField(
                autofocus: true,
                decoration: InputDecoration(
                  hintText: question.hintText ?? '',
                  // Removed labelText
                ),
                onChanged: (value) {
                  question.userResponse = value;
                },
              ),
            ],
          ),
        );

      case 'ELEVATEDBUTTON':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            titleWidget,
            ElevatedButton(
              onPressed: () {
                // Handle elevated button click if needed
              },
              child: Text(question.question ?? 'Button'),
            ),
          ],
        );
      case 'dropdown':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            titleWidget,
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                hintText: question.hintText ?? '',
                // Removed labelText
              ),
              value: question.userResponse?.toString(),
              items: question.options?.map((option) {
                return DropdownMenuItem<String>(
                  value: option.option,
                  child: Text(option.option ?? ''),
                );
              }).toList(),
              onChanged: (value) {
                question.userResponse = value;
              },
            ),
          ],
        );
      case 'RADIO':
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0), // Adds space between fields
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              titleWidget, // Assuming titleWidget is your mandatory/non-mandatory title
              ...question.options!.map((option) {
                return Obx(() {
                  return RadioListTile<String>(
                    activeColor: BorderColor.orange,
                    value: option.option ?? '',
                    groupValue: formDataController.selectedRadioValue.value,
                    // Use GetX's reactive value for groupValue
                    onChanged: (String? value) {
                      if (value != null) {
                        formDataController.updateRadioValue(value);
                        question.userResponse = value; // Optionally update the question's userResponse
                      }
                    },
                    title: Text(option.option ?? ''),
                  );
                });
              }),
            ],
          ),
        );
      case 'MOBILENUMBER': // Handling mobile number input
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            titleWidget,
            TextFormField(
              autofocus: true,
              keyboardType: TextInputType.phone, // Numeric keyboard for phone numbers
              decoration: InputDecoration(
                hintText: question.hintText ?? 'Enter mobile number',
                errorText: _validatePhoneNumber(question.userResponse, question.reValidation),
                // Removed labelText
              ),
              onChanged: (value) {
                question.userResponse = value;
              },
            ),
          ],
        );
      default:
        return Container();
    }
  }

  // Function to validate the phone number against the regex pattern
  String? _validatePhoneNumber(String? value, String? regexPattern) {
    if (value == null || value.isEmpty) {
      return null; // No validation error if it's empty (could add a custom message for required field)
    }
    final RegExp regex = RegExp(regexPattern ?? '');
    if (!regex.hasMatch(value)) {
      return 'Invalid phone number format'; // Return an error message if validation fails
    }
    return null;
  }
}
