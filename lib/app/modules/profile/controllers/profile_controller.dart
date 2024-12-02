import 'package:get/get.dart';

class ProfileController extends GetxController {
  var name = 'John Doe'.obs; // Dummy data for name
  var email = 'john.doe@example.com'.obs; // Dummy data for email
  var aboutYou = 'Flutter Developer & Designer'.obs; // Dummy data for about you

  void updateName(String newName) {
    name.value = newName;
  }

  void updateEmail(String newEmail) {
    email.value = newEmail;
  }

  void updateAboutYou(String newAboutYou) {
    aboutYou.value = newAboutYou;
  }
}
