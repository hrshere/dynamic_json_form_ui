import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/colors_constant.dart';
import '../../../../utils/utils.dart';
import '../../controller/form_data_controller.dart';
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
        title: const Text('Add Input'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: buildFormFields(formDataModel),
              ),
            ),
            ElevatedButton(
              onPressed: _handleSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: BorderColor.orange,
                minimumSize: const Size(double.infinity, 50),
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              child: const Text(
                'Submit',
                style: TextStyle(color: TextColor.white),
              ),
            ),
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
    bool isMandatory = question.isMandatoryField ?? false;
    Widget titleWidget = isMandatory
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: MandatoryTitle(text: question.question ?? ''),
          )
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: NonMandatoryTitle(text: question.question ?? ''),
          );

    // Switch case for question types
    switch (question.questionType) {
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
                  errorText: formDataController.validationErrors[question.question ?? ''],
                ),
                onChanged: (value) {
                  question.userResponse = value;
                  formDataController.clearValidationError(question.question ?? ''); // Clear validation error on change
                },
                validator: isMandatory
                    ? (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'This field is required';
                        }
                        return null;
                      }
                    : null,
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
              onPressed: () {},
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
                errorText: formDataController.validationErrors[question.question ?? ''],
              ),
              value: question.userResponse?.toString(),
              items: question.options?.map((option) {
                return DropdownMenuItem<String>(value: option.option, child: Text(option.option ?? ''));
              }).toList(),
              onChanged: (value) {
                question.userResponse = value;
                formDataController.clearValidationError(question.question ?? ''); // Clear validation error on change
              },
              validator: isMandatory
                  ? (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'This field is required';
                      }
                      return null;
                    }
                  : null,
            ),
          ],
        );
      case 'RADIO':
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              titleWidget,
              ...question.options!.map((option) {
                return Obx(() {
                  return RadioListTile<String>(
                    activeColor: BorderColor.orange,
                    value: option.option ?? '',
                    groupValue: formDataController.selectedRadioValue.value,
                    onChanged: (String? value) {
                      if (value != null) {
                        formDataController.updateRadioValue(value);
                        question.userResponse = value;
                        formDataController
                            .clearValidationError(question.question ?? ''); // Clear validation error on change
                      }
                    },
                    title: Text(option.option ?? ''),
                  );
                });
              }),
            ],
          ),
        );
      case 'MOBILENUMBER':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            titleWidget,
            TextFormField(
              autofocus: true,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: question.hintText ?? 'Enter mobile number',
                errorText: isMandatory ? _validatePhoneNumber(question.userResponse, question.reValidation) : '',
              ),
              onChanged: (value) {
                question.userResponse = value;
                formDataController.clearValidationError(question.question ?? ''); // Clear validation error on change
              },
              validator: isMandatory
                  ? (value) {
                      // First check if the field is empty
                      if (value == null || value.trim().isEmpty) {
                        return 'This field is required';
                      }

                      // Then validate the phone number format if it's not empty
                      return _validatePhoneNumber(value, question.reValidation);
                    }
                  : null, // No validation for non-mandatory fields
            ),
          ],
        );

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
      default:
        return Container();
    }
  }

  // Validate phone number format
  String? _validatePhoneNumber(String? value, String? regexPattern) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    final RegExp regex = RegExp(regexPattern ?? r'^\d{10}$'); // Assuming 10 digit phone numbers
    if (!regex.hasMatch(value)) {
      return 'Invalid phone number format';
    }
    return null;
  }

  Future<void> _handleSubmit() async {
    bool isValid = true;

    // Create a list to store the responses for display
    List<String> responses = [];

    // Iterate through each question to validate the responses
    for (var question in formDataModel.data!.getUserForm!.questions!) {
      // Skip validation if question name is empty or null
      if (question.question == null || question.question!.trim().isEmpty) {
        print('Skipping validation for empty question name.');
        continue; // Skip to the next question
      }

      print('Validating: ${question.question}, Response: ${question.userResponse}');

      // Validate mandatory field
      if (question.isMandatoryField ?? false) {
        // If the userResponse is null or an empty string, mark the form as invalid
        if (question.userResponse == null || question.userResponse!.trim().isEmpty) {
          isValid = false;
          formDataController.setValidationError(question.question ?? '', 'This field is required');
          print('Field "${question.question}" is mandatory and is missing a response.');
        }
      }

      // Collect responses for the dialog after validation
      if (question.userResponse != null && question.userResponse!.isNotEmpty) {
        responses.add('${question.question}: ${question.userResponse}');
      } else {
        // Handle case where userResponse is null or empty, and avoid adding it to responses
        responses.add('${question.question}: No response provided');
      }
    }

    // If form is valid, show the dialog with responses
    if (isValid) {
      print('Form is valid. Submitting responses...');

      // Check that responses are not empty before calling dialog
      if (responses.isNotEmpty && responses.any((response) => response != null)) {
        // await Get.snackbar('alert', 'we are saving your responses');
        logg.i(responses);
      } else {
        print('No valid responses to display.');
      }
    } else {
      print('Form is invalid. Please fill out all required fields.');
    }
  }

// Method to show the dialog
//   void _showResponseDialog(List<String> responses) {
//     // Ensure that responses is not null and contains valid data
//     if (responses == null || responses.isEmpty || responses.any((response) => response == null || response.isEmpty)) {
//       // If the responses list is empty or contains null values, show an error message
//       Get.snackbar('Error', 'No valid responses to display.');
//       return;
//     }
//
//     // If everything is fine, proceed to show the dialog
//     Get.dialog(
//       AlertDialog(
//         title: Text('Form Responses'),
//         content: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: responses.map((response) {
//               return Text(response);  // Safely display responses
//             }).toList(),
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               // Close the dialog when the user presses the 'OK' button
//               Get.back();
//             },
//             child: Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }
}
