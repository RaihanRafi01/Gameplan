import 'package:get/get.dart';

class CalenderController extends GetxController {
  var selectedDate = DateTime.now().obs; // Reactive DateTime
  var focusedDate = DateTime.now().obs;  // Reactive DateTime
  var events = <Event>[Event(date: DateTime.now(), title: 'To day Chat', time: '9:00 PM'),
    Event(date: DateTime.now(), title: 'To day Chat', time: '8:00 AM'),].obs;            // Reactive list of events

  void selectDate(DateTime date) {
    selectedDate.value = date; // Update value
  }
}

class Event {
  final DateTime date;
  final String title;
  final String time;

  Event({required this.date, required this.title, required this.time});
}
