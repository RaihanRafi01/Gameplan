import 'package:get/get.dart';

class CalenderController extends GetxController {
  var selectedDate = DateTime.now().obs; // Reactive DateTime
  var focusedDate = DateTime.now().obs;  // Reactive DateTime
  var events = <Event>[
    Event(date: DateTime.now(), title: 'Today Chat', time: '9:00 PM'),
    Event(date: DateTime.now(), title: 'Today Chat', time: '8:00 AM'),
    // Events for 3 days after
    Event(date: DateTime.now().add(Duration(days: 3)), title: 'Meeting', time: '11:00 AM'),
    Event(date: DateTime.now().add(Duration(days: 6)), title: 'Conference Call', time: '2:00 PM'),
    // Events for 10 days after
    Event(date: DateTime.now().add(Duration(days: 10)), title: 'Project Deadline', time: '4:00 PM'),
    Event(date: DateTime.now().add(Duration(days: 13)), title: 'Team Dinner', time: '7:00 PM'),
  ].obs;
  // Reactive list of events

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
