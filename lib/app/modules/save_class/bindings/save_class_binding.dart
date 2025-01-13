import 'package:get/get.dart';

import '../controllers/save_class_controller.dart';

class SaveClassBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SaveClassController>(
      () => SaveClassController(),
    );
  }
}
