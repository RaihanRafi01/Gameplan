import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';
import '../controllers/calender_controller.dart';

class CalenderView extends GetView<CalenderController> {
  const CalenderView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CalenderController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          // Reactive Calendar
          // Calendar view code with highlighted event dates
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
              /*todayDecoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),*/
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
          // Events List for selected date
          Expanded(
            child: Obx(() {
              // Filter events for the selected date
              final selectedDateEvents = controller.events
                  .where((event) =>
                  isSameDay(event.date, controller.selectedDate.value))
                  .toList();

              return ListView.builder(
                itemCount: selectedDateEvents.length,
                itemBuilder: (context, index) {
                  final event = selectedDateEvents[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(8),bottomLeft: Radius.circular(8)),
                          ),
                          child: Center(
                            child: Text(
                              '${event.date.day}',
                              style: h3.copyWith(color: Colors.white, fontSize: 22,fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        SizedBox(width: 10), // Space between the container and text
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(event.title,style: h3,),
                            Text(
                              '${DateFormat('EEE').format(event.date)} : At ${event.time}',
                              style: h3,
                            ),
                          ],
                        ),
                        Spacer(), // Pushes the icon to the right
                        GestureDetector(
                          onTap: (){},
                            child: SvgPicture.asset('assets/images/pin_icon.svg')),
                        SizedBox(width: 20,)
                      ],
                    )
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
