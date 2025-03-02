import 'package:agcourt/app/modules/authentication/views/reset_password_view.dart';
import 'package:agcourt/app/modules/authentication/views/verify_o_t_p_view.dart';
import 'package:agcourt/app/modules/dashboard/views/dashboard_view.dart';
import 'package:agcourt/app/modules/home/views/webViewScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../common/widgets/auth/popUpWidget.dart';
import '../../../data/services/api_services.dart';
import '../../home/controllers/home_controller.dart';
import '../../home/views/home_view.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthenticationController extends GetxController {
  final HomeController homeController = Get.put(HomeController());
  final ApiService _service = ApiService();
  var isLoading = false.obs; // Reactive loading state


  // Observable variable to store username
  //final RxString usernameOBS = ''.obs;

  final FlutterSecureStorage _storage = FlutterSecureStorage(); // For secure storage


  // Store tokens securely
  Future<void> storeTokens(String accessToken, String refreshToken) async {
    await _storage.write(key: 'access_token', value: accessToken);
    await _storage.write(key: 'refresh_token', value: refreshToken);
  }

  Future<void> signUpWithOther(String username, String email) async {
    isLoading.value = true; // Show the loading screen
    try {
      final http.Response response = await _service.signUpWithOther(
          username, email);

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

        Get.snackbar('Success', 'Logged In successfully!');
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
    }finally {
      isLoading.value = false; // Hide the loading screen
    }
  }

  Future<void> signUp(String email, String password, String username) async {
    isLoading.value = true; // Show the loading screen
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
        Get.snackbar('Warning!', responseBody['message'] ?? 'Sign-up failed\nPlease Use Different Email');
      }
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred');
      print('Error: $e');
    }finally {
      isLoading.value = false; // Hide the loading screen
    }
  }

  Future<void> login(String email, String password) async {
    isLoading.value = true; // Show the loading screen
    try {
      final http.Response response = await _service.login(email, password);

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

        homeController.emailOBS.value = email;

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
    } finally {
      isLoading.value = false; // Hide the loading screen
    }
  }


  Future<void> verifyOTP(String userName,String otp) async {
    isLoading.value = true; // Show the loading screen
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
    }finally {
      isLoading.value = false; // Hide the loading screen
    }
  }

  Future<void> verifyForgotOTP(String userName,String otp) async {
    isLoading.value = true; // Show the loading screen
    try {
      print(':::::FORGOT HIT::::');
      print(':::::OTP:::::::$otp::::::USERNAME:::::$userName::::');
      final http.Response response = await _service.verifyForgotOTP(
          userName, otp);

      print(':::::::::::::::RESPONSE:::::::::::::::::::::${response.body
          .toString()}');
      print(':::::::::::::::CODE:::::::::::::::::::::${response.statusCode}');
      print(':::::::::::::::REQUEST:::::::::::::::::::::${response.request}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Assuming the server responds with success on code 200 or 201
        final responseBody = jsonDecode(response.body);

        print(':::::::::::::::responseBody:::::::::::::::::::::${responseBody}');
        Get.offAll (() => ResetPasswordView(userName: userName,));

      } else {
        final responseBody = jsonDecode(response.body);
        Get.snackbar('Error', responseBody['message'] ?? 'Verification failed');
      }
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred');
      print('Error: $e');
    }finally {
      isLoading.value = false; // Hide the loading screen
    }
  }

  Future<void> resendOTP(String email) async {
    isLoading.value = true; // Show the loading screen
    try {
      print('::::::::USERNAME:::::$email::::');
      final http.Response response = await _service.sendResetOTP(email);

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
    }finally {
      isLoading.value = false; // Hide the loading screen
    }
  }

  Future<void> sendResetOTP(String userName) async {
    isLoading.value = true; // Show the loading screen
    try {
      print('::::::::USERNAME:::::$userName::::');
      final http.Response response = await _service.sendResetOTP(userName);

      print(':::::::::::::::RESPONSE:::::::::::::::::::::${response.body
          .toString()}');
      print(':::::::::::::::CODE:::::::::::::::::::::${response.statusCode}');
      print(':::::::::::::::REQUEST:::::::::::::::::::::${response.request}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Assuming the server responds with success on code 200 or 201
        final responseBody = jsonDecode(response.body);

        print(':::::::::::::::responseBody:::::::::::::::::::::${responseBody}');

        Get.offAll(() => VerifyOTPView(forgotUserName: userName,isForgot: true,));


      } else {
        final responseBody = jsonDecode(response.body);
        Get.snackbar('Error', responseBody['message'] ?? 'Please Provide your correct Email');
      }
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred');
      print('Error: $e');
    }finally {
      isLoading.value = false; // Hide the loading screen
    }
  }


  Future<void> resetPassword(String userName,String password) async {
    isLoading.value = true; // Show the loading screen
    try {
      print(':::::resetPassword API Call Started:::::');
      final http.Response response = await _service.resetPassword(userName,password);

      print(':::::RESPONSE::::: ${response.body.toString()}');
      print(':::::CODE::::: ${response.statusCode}');
      print(':::::REQUEST::::: ${response.request}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Assuming the server responds with success on code 200 or 201
        final responseBody = jsonDecode(response.body);
        print(':::::responseBody::::: $responseBody');

        // Show bottom sheet on successful response
        Get.bottomSheet(
          PasswordChangedBottomSheet(
            onBackToLogin: () {
              Get.back(); // Close the bottom sheet
              // Navigate to the login screen or perform another action here
            },
          ),
          isScrollControlled: true,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to reset password. Please try again later.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      print('Error: $e');
    }finally {
      isLoading.value = false; // Hide the loading screen
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





}

