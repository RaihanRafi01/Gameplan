import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class ApiService {
  final FlutterSecureStorage _storage =
      FlutterSecureStorage(); // For secure storage
  // Base URL for the API
  final String baseUrl =
      'https://backend.gameplanai.co.uk/'; // https://apparently-intense-toad.ngrok-free.app/     //     https://agcourt.pythonanywhere.com/   // https://charming-willingly-starfish.ngrok-free.app/

  // signup with other

  Future<http.Response> signUpWithOther(String username, String email) async {
    // Construct the endpoint URL
    final Uri url =
        Uri.parse('${baseUrl}authentication_app/social_signup_signin/');

    // Headers for the HTTP request
    final Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    // Request body
    final Map<String, String> body = {"username": username, "email": email};

    // Make the POST request
    return await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );
  }

  // Sign-up method
  Future<http.Response> signUp(
      String email, String password, String username) async {
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
      "email": username,
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
      "email": username,
      "otp": otp,
    };

    // Make the POST request
    return await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );
  }

  Future<http.Response> verifyForgotOTP(String username, String otp) async {
    // Construct the endpoint URL
    final Uri url =
        Uri.parse('${baseUrl}authentication_app/verify_forget_password_otp/');

    // Headers for the HTTP request
    final Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    // Request body
    final Map<String, String> body = {
      "email": username,
      "otp": otp,
    };

    // Make the POST request
    return await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );
  }

  /*Future<http.Response> resendOTP() async {
    // Construct the endpoint URL
    final Uri url = Uri.parse('${baseUrl}authentication_app/resend_otp/');

    // Retrieve the stored access token
    String? accessToken = await _storage.read(key: 'access_token');

    // Headers for the HTTP request with Bearer token
    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $accessToken", // Add the Bearer token
    };

    // Make the POST request
    return await http.post(url, headers: headers);
  }*/

  Future<http.Response> sendResetOTP(String username) async {
    // Construct the endpoint URL
    final Uri url = Uri.parse('${baseUrl}authentication_app/forgot_password/');

    // Headers for the HTTP request
    final Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    // Request body
    final Map<String, String> body = {"email": username};

    // Make the POST request
    return await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );
  }

  // Method to check verification status with Bearer token
  Future<http.Response> getProfileInformation() async {
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

  Future<http.Response> updateProfile(
      String? name, String? aboutYou, File? profilePic) async {
    print(':::::::::::::::::::::NAME:::::::::::$name');
    print(':::::::::::::::::::::aboutYou:::::::::::$aboutYou');
    String? accessToken = await _storage.read(key: 'access_token');
    final Uri url = Uri.parse('${baseUrl}authentication_app/user_profile/');

    try {
      // Prepare the multipart request
      var request = http.MultipartRequest('POST', url);

      // Add text fields to the request only if they are not null or empty
      if (name != null && name.isNotEmpty) {
        request.fields['name'] = name;
      }
      if (aboutYou != null && aboutYou.isNotEmpty) {
        request.fields['about_you'] = aboutYou;
      }

      // Add the profile picture file if it exists and is provided
      if (profilePic != null && profilePic.existsSync()) {
        var picStream = http.ByteStream(profilePic.openRead());
        var picLength = await profilePic.length();

        // Determine the file extension and set the content type accordingly
        String extension =
            profilePic.uri.pathSegments.last.split('.').last.toLowerCase();
        String contentType;

        switch (extension) {
          case 'png':
            contentType = 'image/png';
            break;
          case 'jpg':
          case 'jpeg':
            contentType = 'image/jpeg';
            break;
          default:
            contentType =
                'application/octet-stream'; // Default if type is unknown
            break;
        }

        var picMultipart = http.MultipartFile(
          'profile_picture',
          picStream,
          picLength,
          filename: profilePic.uri.pathSegments.last,
          contentType: MediaType.parse(contentType),
        );
        request.files.add(picMultipart);
      }

      // Set the headers with the Bearer token
      request.headers['Authorization'] = 'Bearer $accessToken';

      // Send the request and await the response
      final response = await request.send();

      // Check the status code and handle the response
      if (response.statusCode == 200) {
        // Convert the stream response to a normal response
        final responseString = await response.stream.bytesToString();
        print('Profile updated successfully: $responseString');
        return http.Response(responseString, 200);
      } else {
        final responseString = await response.stream.bytesToString();
        print('Failed to update profile: $responseString');
        return http.Response(responseString, response.statusCode);
      }
    } catch (e) {
      print('Error updating profile: $e');
      return http.Response('Error: $e', 500); // Return error with 500 status
    }
  }

  Future<http.Response> paymentRequest(String type) async {
    final Uri url =
        Uri.parse('${baseUrl}subscription_app/buy_subscription_on_app/');

    // Retrieve the stored access token
    String? accessToken = await _storage.read(key: 'access_token');

    // Headers for the HTTP request with Bearer token
    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $accessToken", // Add the Bearer token
    };

    // Request body
    final Map<String, String> body = {"subscription_plan": type};

    // Make the GET request
    return await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );
  }

  Future<http.Response> createFreeChat(String text_content) async {
    final Uri url = Uri.parse('${baseUrl}chat_app/send_temporary_chat/');

    // Retrieve the stored access token
    String? accessToken = await _storage.read(key: 'access_token');

    // Headers for the HTTP request with Bearer token
    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $accessToken", // Add the Bearer token
    };

    // Request body
    final Map<String, String> body = {"text_content": text_content};

    // Make the POST request
    return await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );
  }

  Future<http.Response> createChat(String text_content) async {
    final Uri url = Uri.parse('${baseUrl}chat_app/create_chat/');

    // Retrieve the stored access token
    String? accessToken = await _storage.read(key: 'access_token');

    // Headers for the HTTP request with Bearer token
    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $accessToken", // Add the Bearer token
    };

    // Request body
    final Map<String, String> body = {"text_content": text_content};

    // Make the POST request
    return await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );
  }

  Future<http.Response> chat(String text_content, int id) async {
    final Uri url = Uri.parse('${baseUrl}chat_app/add_message_to_chat/$id/');

    // Retrieve the stored access token
    String? accessToken = await _storage.read(key: 'access_token');

    // Headers for the HTTP request with Bearer token
    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $accessToken", // Add the Bearer token
    };

    // Request body
    final Map<String, String> body = {"text_content": text_content};

    // Make the POST request
    return await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );
  }

  Future<http.Response> getChatList() async {
    final Uri url = Uri.parse('${baseUrl}chat_app/get_all_chat_list_of_user/');

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

  Future<http.Response> getPinChatList() async {
    final Uri url = Uri.parse('${baseUrl}chat_app/get_pinned_chat_list/');

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

  Future<http.Response> getSaveChatList() async {
    final Uri url = Uri.parse('${baseUrl}chat_app/get_saved_chats/');

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

  Future<http.Response> updateChatTitle(int ChatId, String title) async {
    final Uri url = Uri.parse('${baseUrl}chat_app/update_chat_title/$ChatId/');

    // Retrieve the stored access token
    String? accessToken = await _storage.read(key: 'access_token');

    // Headers for the HTTP request with Bearer token
    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $accessToken", // Add the Bearer token
    };

    // Request body
    final Map<String, String> body = {"chat_title": title};

    // Make the POST request
    return await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );
  }

  Future<http.Response> pinChat(int ChatId, DateTime pinDate) async {
    final Uri url = Uri.parse('${baseUrl}chat_app/pin_a_chat/$ChatId/');

    // Retrieve the stored access token
    String? accessToken = await _storage.read(key: 'access_token');

    // Headers for the HTTP request with Bearer token
    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $accessToken", // Add the Bearer token
    };

    // Request body
    final Map<String, String> body = {"pin_date": pinDate.toIso8601String()};

    // Make the POST request
    return await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );
  }

  Future<http.Response> pinEditChat(int ChatId, DateTime pinDate) async {
    final Uri url = Uri.parse('${baseUrl}chat_app/pin_edited_chat/$ChatId/');

    // Retrieve the stored access token
    String? accessToken = await _storage.read(key: 'access_token');

    // Headers for the HTTP request with Bearer token
    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $accessToken", // Add the Bearer token
    };

    // Request body
    final Map<String, String> body = {"pin_date": pinDate.toIso8601String()};

    // Make the POST request
    return await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );
  }

  Future<http.Response> unpinChat(int ChatId) async {
    final Uri url = Uri.parse('${baseUrl}chat_app/unpin_a_chat/$ChatId/');

    // Retrieve the stored access token
    String? accessToken = await _storage.read(key: 'access_token');

    // Headers for the HTTP request with Bearer token
    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $accessToken", // Add the Bearer token
    };

    // Make the POST request
    return await http.post(url, headers: headers);
  }

  Future<http.Response> unpinEditChat(int editId) async {
    final Uri url = Uri.parse('${baseUrl}chat_app/unpin_edited_chat/$editId/');

    // Retrieve the stored access token
    String? accessToken = await _storage.read(key: 'access_token');

    // Headers for the HTTP request with Bearer token
    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $accessToken", // Add the Bearer token
    };

    // Make the POST request
    return await http.post(url, headers: headers);
  }

  Future<http.Response> saveChat(int ChatId) async {
    final Uri url = Uri.parse('${baseUrl}chat_app/save_a_chat/$ChatId/');

    // Retrieve the stored access token
    String? accessToken = await _storage.read(key: 'access_token');

    // Headers for the HTTP request with Bearer token
    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $accessToken", // Add the Bearer token
    };

    // Make the POST request
    return await http.post(url, headers: headers);
  }

  Future<http.Response> deleteChat(int ChatId) async {
    final Uri url = Uri.parse('${baseUrl}chat_app/delete_a_chat/$ChatId/');

    // Retrieve the stored access token
    String? accessToken = await _storage.read(key: 'access_token');

    // Headers for the HTTP request with Bearer token
    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $accessToken", // Add the Bearer token
    };

    // Make the DELETE request
    return await http.delete(
      url,
      headers: headers,
    );
  }

  Future<http.Response> editBotMessage(int ChatId, String textContent) async {
    final Uri url = Uri.parse('${baseUrl}chat_app/edit_bot_message/$ChatId/');

    // Retrieve the stored access token
    String? accessToken = await _storage.read(key: 'access_token');

    // Headers for the HTTP request with Bearer token
    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $accessToken", // Add the Bearer token
    };

    // Request body
    final Map<String, String> body = {"text_content": textContent};

    // Make the POST request
    return await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );
  }

  Future<http.Response> resetPassword(String userName, String password) async {
    final Uri url = Uri.parse('${baseUrl}authentication_app/reset_password/');

    // Headers for the HTTP request with Bearer token
    final Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    // Request body
    final Map<String, String> body = {
      "email": userName,
      "password": password
    };

    // Make the POST request
    return await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );
  }

  Future<http.Response> getEditedChatList() async {
    final Uri url = Uri.parse('${baseUrl}chat_app/get_all_edited_chat/');

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

  Future<http.Response> deleteEditChat(int ChatId) async {
    final Uri url = Uri.parse('${baseUrl}chat_app/delete_edited_chat/$ChatId/');

    // Retrieve the stored access token
    String? accessToken = await _storage.read(key: 'access_token');

    // Headers for the HTTP request with Bearer token
    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $accessToken", // Add the Bearer token
    };

    // Make the DELETE request
    return await http.delete(
      url,
      headers: headers,
    );
  }

  Future<http.Response> addEditChat(int ChatId, String content) async {
    final Uri url = Uri.parse('${baseUrl}chat_app/edit_conversation/$ChatId/');

    // Retrieve the stored access token
    String? accessToken = await _storage.read(key: 'access_token');

    // Headers for the HTTP request with Bearer token
    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $accessToken", // Add the Bearer token
    };

    // Request body
    final Map<String, String> body = {"content": content};

    // Make the POST request
    return await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );
  }

  Future<http.Response> updateEditChat(int ChatId, String content) async {
    final Uri url =
        Uri.parse('${baseUrl}chat_app/update_edited_conversation/$ChatId/');

    // Retrieve the stored access token
    String? accessToken = await _storage.read(key: 'access_token');

    // Headers for the HTTP request with Bearer token
    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $accessToken", // Add the Bearer token
    };

    // Request body
    final Map<String, String> body = {"content": content};

    // Make the POST request
    return await http.patch(
      url,
      headers: headers,
      body: jsonEncode(body),
    );
  }

  /*Future<http.Response> pinEditChat(int ChatId, DateTime pinDate) async {
    final Uri url = Uri.parse('${baseUrl}chat_app/pin_edited_chat/$ChatId/');

    // Retrieve the stored access token
    String? accessToken = await _storage.read(key: 'access_token');

    // Headers for the HTTP request with Bearer token
    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $accessToken", // Add the Bearer token
    };

    // Request body
    final Map<String, String> body = {
      "pin_date": pinDate.toIso8601String()
    };

    // Make the POST request
    return await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );
  }*/

  Future<http.Response> unSaveEditChat(int editId, int folderID) async {
    final Uri url = Uri.parse(
        '${baseUrl}chat_app/unpin_an_edited_chat_to_a_folder/$editId/$folderID/');

    // Retrieve the stored access token
    String? accessToken = await _storage.read(key: 'access_token');

    // Headers for the HTTP request with Bearer token
    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $accessToken", // Add the Bearer token
    };

    // Make the POST request
    return await http.post(url, headers: headers);
  }

  Future<http.Response> createClass(String className) async {
    final Uri url = Uri.parse('${baseUrl}chat_app/create_class/');

    // Retrieve the stored access token
    String? accessToken = await _storage.read(key: 'access_token');

    // Headers for the HTTP request with Bearer token
    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $accessToken", // Add the Bearer token
    };

    // Request body
    final Map<String, String> body = {"folder_name": className};

    // Make the POST request
    return await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );
  }

  Future<http.Response> getClassList() async {
    final Uri url = Uri.parse('${baseUrl}chat_app/get_all_classes/');

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

  Future<http.Response> pinToClass(int editId, int folderId) async {
    final Uri url = Uri.parse(
        '${baseUrl}chat_app/pin_an_edited_chat_to_a_folder/$editId/$folderId/');

    // Retrieve the stored access token
    String? accessToken = await _storage.read(key: 'access_token');

    // Headers for the HTTP request with Bearer token
    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $accessToken", // Add the Bearer token
    };

    // Request body

    // Make the POST request
    return await http.post(
      url,
      headers: headers,
    );
  }

  Future<http.Response> getEditChatList() async {
    final Uri url = Uri.parse('${baseUrl}chat_app/get_all_edited_chat/');

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

  Future<http.Response> updateEditChatTitle(int ChatId, String title) async {
    final Uri url = Uri.parse('${baseUrl}chat_app/rename_edited_chat/$ChatId/');

    // Retrieve the stored access token
    String? accessToken = await _storage.read(key: 'access_token');

    // Headers for the HTTP request with Bearer token
    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $accessToken", // Add the Bearer token
    };

    // Request body
    final Map<String, String> body = {"chat_name": title};

    // Make the POST request
    return await http.patch(
      url,
      headers: headers,
      body: jsonEncode(body),
    );
  }

  Future<http.Response> helpAndSupport(String email, String query) async {
    final Uri url = Uri.parse('${baseUrl}help_support/send_feedback/');

    // Headers for the HTTP request with Bearer token
    final Map<String, String> headers = {
      "Content-Type": "application/json",
    };

// Request body
    final Map<String, String> body = {
      "email": email,
      "query": query,
    };

    // Make the POST request
    return await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );
  }
}
