import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../data/services/api_services.dart';

class HomeController extends GetxController {
  final ApiService _service = ApiService();
  var email = ''.obs;
  var password = ''.obs;
  var isLoading = false.obs;
  var profilePicUrl = ''.obs; // Store the profile picture URL

  void submitForm() {
    if (email.isEmpty || password.isEmpty) {
      // Handle error
      print("Form is not valid");
      return;
    }

    isLoading.value = true;

    // Simulate network request
    Future.delayed(Duration(seconds: 2), () {
      isLoading.value = false;
      print("Form Submitted!");
    });
  }

  Future<void> fetchProfilePicUrl() async {
    // Check if the account is verified
    final http.Response verificationResponse = await _service.getProfileInformation();

    if (verificationResponse.statusCode == 200) {
      final verificationData = jsonDecode(verificationResponse.body);
      String? profilePicture = verificationData['profile_picture'];

      // If profile_picture is null, set a default image URL
      profilePicUrl.value = profilePicture ?? 'assets/images/home/default_profile_pic.jpg'; // Default image URL
    } else {
      Get.snackbar('Error', 'Verification status check failed');
    }
  }
}
