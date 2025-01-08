import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class FormDataController extends GetxController {
  RxMap<String, String> validationErrors = <String, String>{}.obs;
  var selectedLocation = Rxn<String>(); // Location as a string, you can change it if needed
  var selectedSelfie = Rxn<XFile>(); // Store the selfie image
  var selectedRadioValue = Rxn<String>(); // Store the radio button value

  final ImagePicker picker = ImagePicker();

  void setValidationError(String question, String error) {
    validationErrors[question] = error;
  }

  void clearValidationError(String question) {
    validationErrors.remove(question);
  }
  // Method to check and request location permission
  Future<void> checkAndRequestLocationPermission() async {
    // Check if location permission is granted
    var status = await Permission.location.status;
    if (!status.isGranted) {
      // Request permission
      await Permission.location.request();
    }

    // Once granted, get the location
    if (await Permission.location.isGranted) {
      _getCurrentLocation();
    } else {
      // Handle location permission denial
      print("Location permission denied.");
    }
  }

  // Method to get the current location and reverse geocode it to get the place name
  Future<void> _getCurrentLocation() async {
    try {
      // Get the current position (latitude and longitude)
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      // Reverse geocode the coordinates to get the place name (address)
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        // Get the first placemark and use it as the place name
        Placemark place = placemarks.first;
        String placeName = "${place.name}, ${place.locality}, ${place.country}";

        // Save the place name
        selectedLocation.value = placeName;
      }
    } catch (e) {
      print("Error getting location: $e");
      selectedLocation.value = "Unable to retrieve location.";
    }
  }

  // Reset location
  void resetLocation() {
    selectedLocation.value = null;
  }

  // Method to pick a selfie from camera
  Future<void> pickImageFromCamera() async {
    final XFile? selectedImage =
        await picker.pickImage(source: ImageSource.camera, preferredCameraDevice: CameraDevice.front);
    if (selectedImage != null) {
      selectedSelfie.value = selectedImage;
    }
  }



  // Reset selfie
  void resetSelfie() {
    selectedSelfie.value = null;
  }

  // Update the selected radio button value
  void updateRadioValue(String value) {
    selectedRadioValue.value = value;
  }
}
