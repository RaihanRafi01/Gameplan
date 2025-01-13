import 'package:get/get.dart';

class SaveClassController extends GetxController {
  var classList = <String>[].obs;
  var selectedClass = ''.obs;

  void addClass(String className) {
    if (className.isNotEmpty) {
      classList.add(className);
    }
  }

  void selectClass(String className) {
    selectedClass.value = className;
  }

  void clearSelection() {
    selectedClass.value = '';
  }
}