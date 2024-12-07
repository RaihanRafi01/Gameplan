import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../../../data/services/api_services.dart';

class ProfileController extends GetxController {
  final ApiService _service = ApiService();

  var name = ''.obs;
  var email = ''.obs;
  var aboutYou = ''.obs;
  var picUrl = ''.obs;
  var isTextVisible = false.obs;

  /// Toggle visibility for a text field (e.g., password or sensitive info)
  void toggleTextVisibility() {
    isTextVisible.value = !isTextVisible.value;
  }

  /// Update the name
  void updateName(String newName) {
    name.value = newName;
    print('::::::::::::::::::::::::::::::::::::::::::::update hit');
  }

  /// Update "about you" field
  void updateAboutYou(String newAboutYou) {
    aboutYou.value = newAboutYou;
    print('::::::::::::::::::::::::::::::::::::::::::::update hit');
  }

  /// Fetch profile data from the server
  Future<void> fetchData() async {
    try {
      final http.Response response = await _service.getProfileInformation();

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String? _profilePicture = data['profile_picture'];
        String? _name = data['name'];
        String? about_you = data['about_you'];
        String? _email = data['email'];

        // Update observable variables
        aboutYou.value = about_you ?? '';
        name.value = _name ?? '';
        email.value = _email ?? '';
        picUrl.value = _profilePicture ?? ''; // Leave empty if no URL is provided
      } else {
        Get.snackbar('Error', 'Failed to fetch profile information');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    }
  }

  /// Update profile data (name, aboutYou, and profile picture)
  Future<void> updateData(String? newName, String? newAboutYou, File? profilePic) async {
    try {
      // Pass profilePic as nullable to the updateProfile method
      final http.Response response = await _service.updateProfile(newName, newAboutYou, profilePic);

      if (response.statusCode == 200) {
        // Update local values with the new data
        if (newName != null) name.value = newName;
        if (newAboutYou != null) aboutYou.value = newAboutYou;

        // If the profile picture was updated, fetch the updated profile
        if (profilePic != null) {
          await fetchData();
        }

        Get.snackbar('Success', 'Profile updated successfully');
      } else {
        final error = jsonDecode(response.body)['error'] ?? 'Failed to update profile';
        Get.snackbar('Error', error);
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    }
  }
}
