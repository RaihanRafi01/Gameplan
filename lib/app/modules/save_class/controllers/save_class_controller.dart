import 'dart:convert'; // For JSON decoding
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../data/services/api_services.dart';
import '../../history/controllers/edit_controller.dart';

class SaveClassController extends GetxController {
  final ApiService _service = ApiService();
  final EditController editHistoryController = Get.put(EditController());

  var classList = <Map<String, dynamic>>[].obs; // List of classes with their data
  var selectedClass = ''.obs; // Currently selected class name
  var selectedClassContents = <Map<String, dynamic>>[].obs; // Contents of the selected class
  var isLoading = false.obs; // Observable for loading state
  final RxBool isSaveMode = false.obs;
  final RxBool isPinMode = false.obs;
  final RxInt tempFolderId = 1.obs;

  /// Select a class and update its contents
  void selectClass(String className) {
    selectedClass.value = className;

    final selected = classList.firstWhere(
          (element) => element['folder_name'] == className,
      orElse: () => {}, // Return an empty map
    );

    if (selected.isNotEmpty) {
      final contents = selected['folder_contents'] as List<dynamic>;

      selectedClassContents.assignAll(
        contents.map((item) => item as Map<String, dynamic>).toList(),
      );

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
    isLoading.value = true; // Start loading
    await editHistoryController.fetchAllChatList();
    try {
      final http.Response response = await _service.getClassList();

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        classList.assignAll(data.map((item) => item as Map<String, dynamic>).toList());
      } else {
        Get.snackbar('Error', 'Failed to load class list');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');
    } finally {
      isLoading.value = false; // End loading
    }
  }

  /// Refresh the contents of the selected class
  Future<void> refreshSelectedClassContents() async {
    if (selectedClass.value.isNotEmpty) {
      await fetchClassList(); // Refetch the class list to get updated data
      selectClass(selectedClass.value); // Re-select the current class to update contents
    }
  }

  /// Add a new class by calling the API and updating the local list
  Future<void> addClass(String className) async {
    if (className.isEmpty) {
      Get.snackbar('Error', 'Class name cannot be empty');
      return;
    }

    isLoading.value = true; // Start loading
    try {
      final http.Response response = await _service.createClass(className);

      if (response.statusCode == 200 || response.statusCode == 201) {
        await fetchClassList();
        Get.snackbar('Success', 'Class added successfully');
      } else {
        Get.snackbar('Error', 'Failed to add class');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');
    } finally {
      isLoading.value = false; // End loading
    }
  }

  Future<void> pinToClass(int editID, int folderID) async {
    isLoading.value = true; // Start loading
    try {
      final http.Response response = await _service.pinToClass(editID, folderID);

      if (response.statusCode == 200 || response.statusCode == 201) {
        await fetchClassList();
        Get.snackbar('Success', 'Class saved successfully');
      } else {
        Get.snackbar('Warning!', 'Failed to save class');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');
    } finally {
      isLoading.value = false; // End loading
    }
  }

  Future<void> unSaveEditedChat(int editId, int folderId) async {
    isLoading.value = true; // Start loading
    try {
      final http.Response response = await _service.unSaveEditChat(editId, folderId);

      if (response.statusCode == 200) {
        Get.snackbar('Removed', 'Removed from class successfully');
        isSaveMode.value = false;
        await fetchClassList();
      } else {
        Get.snackbar('Warning!', 'Failed to removed');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');
    } finally {
      isLoading.value = false; // End loading
    }
  }
}
