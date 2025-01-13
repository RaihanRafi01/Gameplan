import 'package:get/get.dart';

class DashboardController extends GetxController {
  var currentIndex = 2.obs;
  void updateIndex(int index) {
    print('index chage :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::');
    currentIndex.value = index;
  }
}