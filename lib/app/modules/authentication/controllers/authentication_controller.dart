import 'package:agcourt/app/modules/authentication/views/verify_o_t_p_view.dart';
import 'package:agcourt/app/modules/dashboard/views/dashboard_view.dart';
import 'package:agcourt/app/modules/home/views/webViewScreen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/services/api_services.dart';
import '../../home/controllers/home_controller.dart';
import '../../home/views/home_view.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthenticationController extends GetxController {
  final HomeController homeController = Get.put(HomeController());
  final ApiService _service = ApiService();


  // Observable variable to store username
  //final RxString usernameOBS = ''.obs;

  final FlutterSecureStorage _storage = FlutterSecureStorage(); // For secure storage


  // Store tokens securely
  Future<void> storeTokens(String accessToken, String refreshToken) async {
    await _storage.write(key: 'access_token', value: accessToken);
    await _storage.write(key: 'refresh_token', value: refreshToken);
  }

  Future<void> signUp(String email, String password, String username) async {
    try {
      final http.Response response = await _service.signUp(
          email, password, username);

      print(':::::::::::::::RESPONSE:::::::::::::::::::::${response.body.toString()}');
      print(':::::::::::::::CODE:::::::::::::::::::::${response.statusCode}');
      print(':::::::::::::::REQUEST:::::::::::::::::::::${response.request}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Assuming the server responds with success on code 200 or 201
        final responseBody = jsonDecode(response.body);
        final accessToken = responseBody['access'];
        final refreshToken = responseBody['refresh'];

        // Store the tokens securely
        await storeTokens(accessToken, refreshToken);

        print(':::::::::::::::responseBody:::::::::::::::::::::$responseBody');
        print(':::::::::::::::accessToken:::::::::::::::::::::$accessToken');
        print(':::::::::::::::refreshToken:::::::::::::::::::::$refreshToken');

        Get.snackbar('Success', 'Account created successfully!');
        //Get.off(() => VerifyOTPView());

        homeController.fetchProfileData();
        homeController.checkVerified();

        // SharedPreferences

        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true); // User is logged in



      } else {
        final responseBody = jsonDecode(response.body);
        Get.snackbar('Error', responseBody['message'] ?? 'Sign-up failed\nPlease Use Different Username');
      }
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred');
      print('Error: $e');
    }
  }

  Future<void> login(String username, String password) async {
    try {
      final http.Response response = await _service.login(username, password);

      print(':::::::::::::::RESPONSE:::::::::::::::::::::${response.body
          .toString()}');
      print(':::::::::::::::CODE:::::::::::::::::::::${response.statusCode}');
      print(':::::::::::::::REQUEST:::::::::::::::::::::${response.request}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Assuming the server responds with success on code 200 or 201
        final responseBody = jsonDecode(response.body);

        print(
            ':::::::::::::::responseBody:::::::::::::::::::::${responseBody}');


        final accessToken = responseBody['access'];
        final refreshToken = responseBody['refresh'];

        // Store the tokens securely
        await storeTokens(accessToken, refreshToken);

        homeController.fetchProfileData();
        homeController.checkVerified();

        // SharedPreferences

        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true); // User is logged in


      } else {
        final responseBody = jsonDecode(response.body);
        Get.snackbar('Error', responseBody['message'] ?? 'Sign-up failed');
      }
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred');
      print('Error: $e');
    }
  }


  Future<void> verifyOTP(String userName,String otp) async {
    try {
      print(':::::OTP:::::::$otp::::::USERNAME:::::$userName::::');
      final http.Response response = await _service.verifyOTP(
          userName, otp);

      print(':::::::::::::::RESPONSE:::::::::::::::::::::${response.body
          .toString()}');
      print(':::::::::::::::CODE:::::::::::::::::::::${response.statusCode}');
      print(':::::::::::::::REQUEST:::::::::::::::::::::${response.request}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Assuming the server responds with success on code 200 or 201
        final responseBody = jsonDecode(response.body);

        print(':::::::::::::::responseBody:::::::::::::::::::::${responseBody}');

        homeController.checkVerified();
        homeController.fetchProfileData();

      } else {
        final responseBody = jsonDecode(response.body);
        Get.snackbar('Error', responseBody['message'] ?? 'Verification failed');
      }
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred');
      print('Error: $e');
    }
  }

  Future<void> resendOTP() async {
    try {
      print(':::::resendOTP:::::::::::::::::');
      final http.Response response = await _service.resendOTP();

      print(':::::::::::::::RESPONSE:::::::::::::::::::::${response.body
          .toString()}');
      print(':::::::::::::::CODE:::::::::::::::::::::${response.statusCode}');
      print(':::::::::::::::REQUEST:::::::::::::::::::::${response.request}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Assuming the server responds with success on code 200 or 201
        final responseBody = jsonDecode(response.body);

        print(':::::::::::::::responseBody:::::::::::::::::::::${responseBody}');
        Get.snackbar('OTP Send','Please Check Your Email');

      } else {
        Get.snackbar('Error', 'Please try again later');
      }
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred');
      print('Error: $e');
    }
  }


  /*Future<void> checkVerified() async {

    // Check if the account is verified
    final http.Response verificationResponse = await _service.getProfileInformation();

    if (verificationResponse.statusCode == 200) {
      final verificationData = jsonDecode(verificationResponse.body);
      bool isVerified = verificationData['is_verified'];

      if (isVerified) {
        // Navigate to the Dashboard if verified
        Get.snackbar('Success', 'Account verified!');
        Get.off(() => DashboardView()); // Navigate to DashboardView
      } else {
        // Show a page to request further action if not verified
        Get.snackbar('Error', 'Account not verified. Please check your email.');
        Get.off(() => VerifyOTPView(userName: usernameOBS.value,));
      }
    } else {
      Get.snackbar('Error', 'Verification status check failed');
    }
  }*/


  Future<void> checkPayment() async {

    // Check if the account is verified
    final http.Response paymentResponse = await _service.paymentRequest();

    if (paymentResponse.statusCode == 200) {
      final responseBody = jsonDecode(paymentResponse.body);

      final checkout_url = responseBody['checkout_url'];

      Get.off(() => WebViewScreen(url: checkout_url,
        onUrlMatched: () { Get.offAll(()=>HomeView()); },));

    } else {
      Get.snackbar('Error', 'Verification status check failed');
    }
  }


}

