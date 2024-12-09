import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../data/services/api_services.dart';
import '../../authentication/views/verify_o_t_p_view.dart';
import '../../dashboard/views/dashboard_view.dart';

class HomeController extends GetxController {
  final ApiService _service = ApiService();
  var email = ''.obs;
  var password = ''.obs;
  var isLoading = false.obs;
  var profilePicUrl = ''.obs; // Store the profile picture URL
  final RxString usernameOBS = ''.obs;
  var name = ''.obs;
  var aboutYou = ''.obs;
  var subscriptionExpireDate = ''.obs;
  var subscriptionStatus = ''.obs;
  RxBool isExpired = false.obs;

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
        Get.off(() => DashboardView()); // Navigate to DashboardView
      } else {
        // Show a page to request further action if not verified
        Get.snackbar('Error', 'Account not verified. Please check your email.');
        Get.off(() => VerifyOTPView(userName: usernameOBS.value,));
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
      bool? _isExpired = responseData['is_expired'];

      String? _profilePicture = responseData['profile_picture'];
      String? _name = responseData['name'];
      String? about_you = responseData['about_you'];
      String? _email = responseData['email'];

      aboutYou.value = about_you ?? '';
      name.value = _name ?? '';
      email.value = _email ?? '';
      profilePicUrl.value = _profilePicture ?? '';
      subscriptionStatus.value = _subscriptionStatus ?? '';
      subscriptionExpireDate.value = _subscriptionExpireDate ?? '';
      isExpired.value = _isExpired ?? false;



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
    } else {
      Get.snackbar('Error', 'Verification status check failed');
    }
  }
}
