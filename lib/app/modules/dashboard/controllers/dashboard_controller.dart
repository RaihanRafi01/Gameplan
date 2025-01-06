import 'package:get/get.dart';

class DashboardController extends GetxController {
  var currentIndex = 1.obs;
  void updateIndex(int index) {
    print('index chage :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::');
    currentIndex.value = index;
  }
}