import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';
import '../controllers/history_controller.dart';

class HistoryView extends GetView<HistoryController> {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HistoryController());
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: DropdownButtonHideUnderline(
                    child: Obx(() => DropdownButton<String>(
                      value: controller.selectedFilter.value,
                      items: [
                        DropdownMenuItem(value: 'All', child: Text('All Chat', style: h3)),
                        DropdownMenuItem(value: 'Pin', child: Text('Pin Chat', style: h3)),
                        DropdownMenuItem(value: 'Save', child: Text('Save Chat', style: h3)),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          controller.updateFilter(value);
                        }
                      },
                    )),
                  ),
                ),
              ),
            ),
            Text(
              'History',
              style: h2.copyWith(fontSize: 28, color: AppColors.textHistory),
            ),
            const SizedBox(height: 8),
            Text(
              'Today',
              style: h3.copyWith(fontSize: 22, color: AppColors.textHistory),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(() => ListView.builder(
                itemCount: controller.chatHistory.length,
                itemBuilder: (context, index) {
                  final chat = controller.chatHistory[index];
                  return ListTile(
                    title: Text(
                      chat,
                      style: h3.copyWith(fontSize: 18, color: AppColors.textHistory),
                    ),
                    trailing: PopupMenuButton<int>(
                      icon: const Icon(Icons.more_horiz_rounded),
                      onSelected: (value) {
                        switch (value) {
                          case 0:
                          // Handle 'Pin' action
                            break;
                          case 1:
                          // Handle 'Save' action
                            break;
                          case 2:
                          // Handle 'Delete' action
                            break;
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 0,
                          child: Row(
                            children: [
                              SvgPicture.asset('assets/images/history/pin_icon.svg'),
                              SizedBox(width: 10,),
                              Text('Pin', style: h3.copyWith(fontSize: 16)),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 1,
                          child: Row(
                            children: [
                              SvgPicture.asset('assets/images/history/edit _icon.svg'),
                              SizedBox(width: 10,),
                              Text('Edit', style: h3.copyWith(fontSize: 16)),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 2,
                          child: Row(
                            children: [
                              SvgPicture.asset('assets/images/history/delete_icon.svg'),
                              SizedBox(width: 10,),
                              Text('Delete', style: h3.copyWith(fontSize: 16)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      // Handle chat item click
                    },
                  );
                },
              )),
            ),
          ],
        ),
      ),
    );
  }
}
