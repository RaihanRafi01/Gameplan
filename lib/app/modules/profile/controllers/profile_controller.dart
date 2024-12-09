import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../../../data/services/api_services.dart';
import '../../home/controllers/home_controller.dart';

class ProfileController extends GetxController {
  final HomeController homeController = Get.put(HomeController());
  final ApiService _service = ApiService();
  var isTextVisible = false.obs;
  //var name = ''.obs;
  //var email = ''.obs;
  //var aboutYou = ''.obs;
  //var picUrl = ''.obs;

  var selectedFAQIndex = (-1).obs; // Initialize with no item selected

   // Initialize with no item selected

  void setSelectedFAQIndex(int index) {
    selectedFAQIndex.value = index;
  }

  /// Toggle visibility for a text field (e.g., password or sensitive info)
  void toggleTextVisibility() {
    isTextVisible.value = !isTextVisible.value;
  }

  /// Update the name
  void updateName(String newName) {
    homeController.name.value = newName;
    print('::::::::::::::::::::::::::::::::::::::::::::update hit');
  }

  /// Update "about you" field
  void updateAboutYou(String newAboutYou) {
    homeController.aboutYou.value = newAboutYou;
    print('::::::::::::::::::::::::::::::::::::::::::::update hit');
  }

  /*/// Fetch profile data from the server
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
        homeController.aboutYou.value = about_you ?? '';
        homeController.name.value = _name ?? '';
        homeController.email.value = _email ?? '';
        homeController.profilePicUrl.value = _profilePicture ?? ''; // Leave empty if no URL is provided
      } else {
        Get.snackbar('Error', 'Failed to fetch profile information');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    }
  }*/

  /// Update profile data (name, aboutYou, and profile picture)
  Future<void> updateData(String? newName, String? newAboutYou, File? profilePic) async {
    try {
      // Pass profilePic as nullable to the updateProfile method
      final http.Response response = await _service.updateProfile(newName, newAboutYou, profilePic);

      if (response.statusCode == 200) {
        // Update local values with the new data
        if (newName != null) homeController.name.value = newName;
        if (newAboutYou != null) homeController.aboutYou.value = newAboutYou;

        // If the profile picture was updated, fetch the updated profile
        if (profilePic != null) {
          //await fetchData();
          await homeController.fetchProfileData();
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
