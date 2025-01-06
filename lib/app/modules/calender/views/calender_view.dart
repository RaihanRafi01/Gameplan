import 'package:agcourt/app/modules/history/controllers/history_controller.dart';
import 'package:agcourt/app/modules/home/controllers/chat_controller.dart';
import 'package:agcourt/app/modules/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';
import '../../../../common/widgets/custom_button.dart';
import '../../dashboard/views/widgets/subscriptionPopup.dart';
import '../../home/views/chat_screen_view.dart';
import '../controllers/calender_controller.dart';

class CalenderView extends GetView<CalenderController> {
  const CalenderView({super.key});

  @override
  Widget build(BuildContext context) {
    final HistoryController historyController = Get.put(HistoryController());
    final HomeController homeController = Get.put(HomeController());
    historyController.fetchPinChatList();
    final bool isFree = homeController.isFree.value;
    Get.put(CalenderController());

    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 40),
          if (isFree)
            CustomButton(
              height: 30,
              textSize: 12,
              text: 'Upgrade To Pro',
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible: true, // Prevent closing the dialog by tapping outside
                  builder: (BuildContext context) {
                    return const SubscriptionPopup(
                        isManage: true); // Use the SubscriptionPopup widget
                  },
                );
              },
              width: 150,
              backgroundGradientColor: AppColors.transparent,
              borderGradientColor: AppColors.cardGradient,
              isEditPage: true,
              textColor: AppColors.textColor,
            ),
          SizedBox(height: 12),
          Container(
            height: 70,
            width: double.maxFinite,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: AppColors.cardGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Text(
                'Calendar',
                style: h3.copyWith(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          // Reactive Calendar
          Obx(() => TableCalendar(
            focusedDay: controller.focusedDate.value,
            firstDay: DateTime(2020),
            lastDay: DateTime(2030),
            calendarFormat: CalendarFormat.month,
            selectedDayPredicate: (day) {
              return isSameDay(day, controller.selectedDate.value);
            },
            onDaySelected: (selectedDay, focusedDay) {
              controller.selectDate(selectedDay);
              controller.focusedDate.value = focusedDay;
            },
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
            calendarStyle: CalendarStyle(
              isTodayHighlighted: false,
              selectedDecoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: AppColors.cardGradient,
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                shape: BoxShape.circle,
              ),
            ),
            // Highlight event dates
            eventLoader: (day) {
              // Check if the date has events
              return controller.events
                  .where((event) => isSameDay(event.date, day))
                  .toList();
            },
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, day, events) {
                if (events.isNotEmpty) {
                  return Positioned(
                    bottom: 4,
                    child: Container(
                      width: 40,
                      height: 6,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: AppColors.cardGradient,
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                }
                return null;
              },
            ),
          )),
          SizedBox(height: 20),
          // Expanded Event List View
          Expanded(
            child: Obx(() {
              // Filter events for the selected date
              final selectedDateEvents = controller.events
                  .where((event) => isSameDay(event.date, controller.selectedDate.value))
                  .toList();

              if (selectedDateEvents.isEmpty) {
                return Center(
                  child: Text('No events for the selected date', style: h3),
                );
              }

              return ListView.builder(
                itemCount: selectedDateEvents.length,
                itemBuilder: (context, index) {
                  final event = selectedDateEvents[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: InkWell(
                      onTap: () {
                        // Fetch the chat and navigate to ChatScreen
                        final chat = historyController.getChatById(event.ChatId);
                        if (chat != null) {
                          Get.to(() => ChatScreen(
                            chat: chat.chatContents,
                            chatId: chat.id,
                            chatName: chat.chatName,
                          ))?.then((value) => historyController.fetchData());
                        } else {
                          Get.snackbar(
                            'Error',
                            'Chat not found',
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        }
                      },
                      child: Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: AppColors.cardGradient,
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(8),
                                bottomLeft: Radius.circular(8),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '${event.date.day}',
                                style: h3.copyWith(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10), // Space between the container and text
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(event.title, style: h3),
                              Text(
                                DateFormat('EEE, hh:mm a').format(event.date), // Display day and time
                                style: h3,
                              ),
                            ],
                          ),
                          const Spacer(), // Pushes the icon to the right
                          GestureDetector(
                            onTap: () {
                              // Handle pin/unpin logic here if needed
                            },
                            child: SvgPicture.asset('assets/images/pin_icon.svg'),
                          ),
                          const SizedBox(width: 20),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
