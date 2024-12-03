import 'package:get/get.dart';

class HistoryController extends GetxController {
  // Reactive variable for selected filter
  var selectedFilter = 'All'.obs;

  // Reactive list for chat history
  var chatHistory = <String>[
    'Last Chat 1',
    'Last Chat 2',
    'Last Chat 3',
    'Last Chat 4',
    'Last Chat 5',
  ].obs;

  // Update the filter and modify the chat history if needed
  void updateFilter(String filter) {
    selectedFilter.value = filter;
    // Logic to update chat history based on the selected filter
  }
}
