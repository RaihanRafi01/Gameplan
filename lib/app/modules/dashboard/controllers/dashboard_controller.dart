import 'package:get/get.dart';

import '../../save_class/controllers/save_class_controller.dart';

class DashboardController extends GetxController {
  var currentIndex = 2.obs;
  final SaveClassController saveClassController = Get.put(SaveClassController());

  void updateIndex(int index) {
    print('index change :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::');

    // Check if the currentIndex is 1 and the new index is different
    if (currentIndex.value == 1 && index != currentIndex.value) {
      saveClassController.clearSelection();
    }

    // Update the index value
    currentIndex.value = index;
  }
}
