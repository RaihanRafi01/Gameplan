import 'package:get/get.dart';

class DashboardController extends GetxController {
  var currentIndex = 1.obs;
  void updateIndex(int index) {
    currentIndex.value = index;
  }
}