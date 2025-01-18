import 'dart:convert'; // For JSON decoding
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../data/services/api_services.dart';

class SaveClassController extends GetxController {
  final ApiService _service = ApiService();

  // Observables to manage data and state
  var classList = <Map<String, dynamic>>[].obs; // List of classes with their data
  var selectedClass = ''.obs; // Currently selected class name
  var selectedClassContents = <Map<String, dynamic>>[].obs; // Contents of the selected class

  /// Select a class and update its contents
  void selectClass(String className) {
    selectedClass.value = className;

    // Find the selected class from the classList
    final selected = classList.firstWhere(
          (element) => element['folder_name'] == className,
      orElse: () => {}, // Return an empty map
    );

    // Update contents of the selected class if it exists
    if (selected.isNotEmpty) {
      final contents = selected['folder_contents'] as List<dynamic>;

      // Ensure the contents are properly typed
      selectedClassContents.assignAll(
        contents.map((item) => item as Map<String, dynamic>).toList(),
      );

      // Print the folder contents for debugging
      print('Contents of $className:');
      for (var content in selectedClassContents) {
        print(content);
      }
    } else {
      selectedClassContents.clear();
      print('No contents found for the selected class: $className');
    }
  }



  /// Clear the current class selection
  void clearSelection() {
    selectedClass.value = '';
    selectedClassContents.clear();
  }

  /// Fetch the list of classes from the API
  Future<void> fetchClassList() async {
    try {
      final http.Response response = await _service.getClassList();

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        // Update the class list with the fetched data
        classList.assignAll(data.map((item) => item as Map<String, dynamic>).toList());
      } else {
        Get.snackbar('Error', 'Failed to load class list');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');
    }
  }

  /// Add a new class by calling the API and updating the local list
  Future<void> addClass(String className) async {
    if (className.isEmpty) {
      Get.snackbar('Error', 'Class name cannot be empty');
      return;
    }

    try {
      final http.Response response = await _service.createClass(className);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Add the new class to the local list
        fetchClassList(); // Refresh the folder list
        classList.add({
          'id': DateTime.now().millisecondsSinceEpoch, // Temporary ID
          'owner_user': null, // Replace with actual owner ID if available
          'folder_name': className,
          'folder_contents': [],
        });

        Get.snackbar('Success', 'Class added successfully');
      } else {
        Get.snackbar('Error', 'Failed to add class');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');
    }
  }

  Future<void> pinToClass(int editID,int folderID) async {
    try {
      final http.Response response = await _service.pinToClass(editID,folderID);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Add the new class to the local list
        fetchClassList();
        Get.snackbar('Success', 'Class pinned successfully');
      } else {
        Get.snackbar('Error', 'Failed to pinned class');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');
    }
  }

  Future<void> unpinChat(int editId,int folderId) async {
    try {
      // Make the API call to get chat list
      final http.Response response = await _service.unpinEditChat(editId,folderId);

      print('::::::::::::::::::::::::CODE::::::${response.statusCode}');
      print('::::::::::::::::::::::::CODE::::::${response.toString()}');

      if (response.statusCode == 200) {
        // Decode the API response into a list of maps
        Get.snackbar('Unpinned', 'Edit Unpinned successfully');
        await fetchClassList();

        // Find and remove the event corresponding to the chatId
        /*final eventToRemove = calendarController.events.firstWhere(
                (event) => event.ChatId == chatId // Return null if no matching event is found
        );

        if (eventToRemove != null) {
          // Remove the event from the calendarController events list
          calendarController.events.remove(eventToRemove);

          // Optionally refresh the calendar view if needed
          // calendarController.events.refresh();
        }
        fetchData();*/
      } else {
        // Handle unsuccessful response
        Get.snackbar('Error', 'Failed to unpin');
      }
    } catch (e) {
      // Handle any exceptions during the API call
      Get.snackbar('Error', 'Something went wrong: $e');
    }
  }
}


