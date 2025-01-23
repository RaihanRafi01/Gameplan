import 'dart:convert';

import 'package:agcourt/app/modules/dashboard/views/dashboard_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../common/appColors.dart';
import '../../../data/services/api_services.dart';
import '../../home/views/home_view.dart';
import '../../home/views/webViewScreen.dart';
class SubscriptionController extends GetxController {
  final ApiService _service = ApiService();
  // Observables for selected plan
  var selectedPlan = "Yearly".obs;

  // Method to update the selected plan
  void selectPlan(String plan) {
    selectedPlan.value = plan;
  }

  Future<void> checkPayment(String type) async {
    // Show loading dialog
    Get.dialog(
      Center(child: CircularProgressIndicator(color: AppColors.textColor2,)),
      barrierDismissible: false,
    );

    try {
      // Call the API
      final http.Response paymentResponse = await _service.paymentRequest(type);

      // Close the loading dialog immediately after receiving the response
      if (Get.isDialogOpen == true) {
        Get.back(); // Close the dialog
      }

      print(':::::::::statusCode:::::::::::::::::::::::::::::${paymentResponse.statusCode}');
      print(':::::::::body:::::::::::::::::::::::::::::${paymentResponse.body}');

      if (paymentResponse.statusCode == 200) {
        final responseBody = jsonDecode(paymentResponse.body);

        final checkoutUrl = responseBody['checkout_url'];
        final message = responseBody['Message'];

        if (message != null && message.isNotEmpty) {
          // Show the message in a snackbar
          Get.snackbar('Message', message);
        } else if (checkoutUrl != null && checkoutUrl.isNotEmpty) {
          // Navigate to the WebViewScreen if checkoutUrl is valid
          print(':::::::::checkout_url:::::::::::::::::::::::::::::$checkoutUrl');
          Get.off(() => WebViewScreen(
            url: checkoutUrl,
            onUrlMatched: () {
              Get.offAll(() => DashboardView());
            },
          ));
        } else {
          // Show a generic error message for unexpected responses
          Get.snackbar('Error', 'Unexpected response. Please try again.');
        }
      } else {
        // Show error message if the status code is not 200
        Get.snackbar('Error', 'Verification status check failed');
      }
    } catch (e) {
      // Handle any exceptions
      print('Error: $e');
      Get.snackbar('Error', 'An error occurred. Please try again.');
    } finally {
      // Ensure the loading dialog is closed in case it wasn't already closed
      if (Get.isDialogOpen == true) {
        Get.back(); // Close the dialog
      }
    }
  }




}