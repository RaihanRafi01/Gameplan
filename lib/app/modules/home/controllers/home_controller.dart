import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/services/api_services.dart';
import '../../authentication/views/authentication_view.dart';
import '../../authentication/views/verify_o_t_p_view.dart';
import '../../dashboard/views/dashboard_view.dart';

class HomeController extends GetxController {
  final ApiService _service = ApiService();
  var email = ''.obs;
  var password = ''.obs;
  var username = ''.obs;
  var isLoading = false.obs;
  var profilePicUrl = ''.obs; // Store the profile picture URL
  final RxString usernameOBS = ''.obs;
  var name = ''.obs;
  var aboutYou = ''.obs;
  var subscriptionExpireDate = ''.obs;
  var package_name = ''.obs;
  var subscriptionStatus = ''.obs;
  RxBool isExpired = false.obs;
  RxBool isFree = false.obs;




  // New flag to track if the user is editing the profile
  var isEditingProfile = false.obs;

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


  Future<void> checkVerified() async {
    // Check if the account is verified
    final http.Response verificationResponse = await _service.getProfileInformation();

    if (verificationResponse.statusCode == 200) {
      final responseData = jsonDecode(verificationResponse.body);

      bool isVerified = responseData['is_verified'];


      if (isVerified) {
        // Navigate to the Dashboard if verified
        //Get.snackbar('Success', 'Account verified!');
        Get.offAll(() => DashboardView()); // Navigate to DashboardView
      } else {
        // Show a page to request further action if not verified
        Get.snackbar('Error', 'Account not verified. Please check your email.');
        Get.off(() => VerifyOTPView());
      }

    } else {
      Get.snackbar('Error', 'Verification status check failed');
    }
  }


  Future<void> fetchProfileData() async {
    // Check if the account is verified
    final http.Response verificationResponse = await _service.getProfileInformation();

    if (verificationResponse.statusCode == 200) {
      final responseData = jsonDecode(verificationResponse.body);
      String? _subscriptionStatus = responseData['subscription_status'];
      String? _subscriptionExpireDate = responseData['subscription_expires_on'];
      String? _package_name = responseData['package_name'];
      bool? _isExpired = responseData['is_expired'];

      String? _profilePicture = responseData['profile_picture'];
      String? _name = responseData['name'];
      String? about_you = responseData['about_you'];
      String? _email = responseData['email'];
      String? _username = responseData['username'];

      aboutYou.value = about_you ?? '';
      name.value = _name ?? '';
      email.value = _email ?? '';
      username.value = _username ?? '';
      profilePicUrl.value = _profilePicture ?? '';
      subscriptionStatus.value = _subscriptionStatus ?? '';
      subscriptionExpireDate.value = _subscriptionExpireDate ?? '';
      package_name.value = _package_name ?? '';
      isExpired.value = _isExpired ?? false;

      print('::::::::::::::::::::subscriptionStatus:::::::::::::::::::::::::::$subscriptionStatus');


      // TODO make this == before deployment

      isFree.value = subscriptionStatus.value == 'not_subscribed';


      /*if (isVerified) {
        // Navigate to the Dashboard if verified
        //Get.snackbar('Success', 'Account verified!');
        Get.off(() => DashboardView()); // Navigate to DashboardView
      } else {
        // Show a page to request further action if not verified
        Get.snackbar('Error', 'Account not verified. Please check your email.');
        Get.off(() => VerifyOTPView(userName: usernameOBS.value,));
      }*/


      // If profile_picture is null, set a default image URL
     // profilePicUrl.value = _profilePicture ?? 'assets/images/home/default_profile_pic.jpg'; // Default image URL
    }
    else if (verificationResponse.statusCode == 401){
      Get.snackbar('Session Expired', 'Please Login again to Continue');
      final FlutterSecureStorage _storage = FlutterSecureStorage();
      await _storage.delete(key: 'access_token');
      await _storage.delete(key: 'refresh_token');

      // SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', false); // User is logged out

      Get.offAll(() => AuthenticationView());
    }
    else {
      Get.snackbar('Error', 'Verification status check failed');
    }
  }
}
