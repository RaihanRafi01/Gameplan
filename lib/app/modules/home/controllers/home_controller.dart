import 'package:get/get.dart';

class HomeController extends GetxController {
  var email = ''.obs;
  var password = ''.obs;
  var isLoading = false.obs;

  void submitForm() {
    if (email.isEmpty || password.isEmpty) {
      // Handle error
      print("Form is not valid");
      return;
    }

    isLoading.value = true;

    // Simulate network request
    Future.delayed(Duration(seconds: 2), () {
      isLoading.value = false;
      print("Form Submitted!");
    });
  }

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}

