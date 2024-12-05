import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ApiService {

  final FlutterSecureStorage _storage = FlutterSecureStorage(); // For secure storage
  // Base URL for the API
  final String baseUrl = 'https://apparently-intense-toad.ngrok-free.app/';

  // Sign-up method
  Future<http.Response> signUp(String email, String password, String username) async {
    // Construct the endpoint URL
    final Uri url = Uri.parse('${baseUrl}authentication_app/signup/');

    // Headers for the HTTP request
    final Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    // Request body
    final Map<String, String> body = {
      "email": email,
      "password": password,
      "username": username,
    };

    // Make the POST request
    return await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );
  }

  // login method
  Future<http.Response> login(String username, String password) async {
    // Construct the endpoint URL
    final Uri url = Uri.parse('${baseUrl}authentication_app/login/');

    // Headers for the HTTP request
    final Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    // Request body
    final Map<String, String> body = {
      "username": username,
      "password": password,
    };

    // Make the POST request
    return await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );
  }

  // Add this method in ApiService
  Future<http.Response> verifyOTP(String username, String otp) async {
    // Construct the endpoint URL
    final Uri url = Uri.parse('${baseUrl}authentication_app/verify_email/');

    // Headers for the HTTP request
    final Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    // Request body
    final Map<String, String> body = {
      "username": username,
      "otp": otp,
    };

    // Make the POST request
    return await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );
  }



  // Method to check verification status with Bearer token
  Future<http.Response> checkVerificationStatus() async {
    final Uri url = Uri.parse('${baseUrl}authentication_app/user_profile/');

    // Retrieve the stored access token
    String? accessToken = await _storage.read(key: 'access_token');

    // Headers for the HTTP request with Bearer token
    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $accessToken", // Add the Bearer token
    };

    // Make the GET request
    return await http.get(url, headers: headers);
  }





  Future<http.Response> paymentRequest() async {
    final Uri url = Uri.parse('${baseUrl}subscription_app/buy_subscription_on_app/');

    // Retrieve the stored access token
    String? accessToken = await _storage.read(key: 'access_token');

    // Headers for the HTTP request with Bearer token
    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $accessToken", // Add the Bearer token
    };

    // Make the GET request
    return await http.post(url, headers: headers);
  }



}
