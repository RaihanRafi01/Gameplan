import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../common/appColors.dart';
import '../../../../common/widgets/customAppBar.dart';
import '../../../../common/widgets/custom_button.dart';
import '../../dashboard/controllers/theme_controller.dart';
import '../../dashboard/views/widgets/subscriptionPopup.dart';
import '../../home/controllers/home_controller.dart';
import '../controllers/save_class_controller.dart';
import 'chatContentScreen.dart';

class SaveClassView extends StatelessWidget {
  final SaveClassController controller = Get.put(SaveClassController());

  SaveClassView({super.key}) {
    // Fetch class list when the view is initialized
    controller.fetchClassList();
  }

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.put(HomeController());
    final bool isFree = homeController.isFree.value;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Obx(() {
          final ThemeController themeController = Get.find<ThemeController>();
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/images/auth/app_logo.svg',
                color: themeController.isDarkTheme.value
                    ? Colors.white // White in dark mode
                    : null, // Black in light mode
              ),
              if (isFree)
                Obx(() {
                  final ThemeController themeController =
                  Get.find<ThemeController>();

                  return CustomButton(
                    height: 30,
                    textSize: 12,
                    text: 'Upgrade To Pro',
                    onPressed: () {
                      showDialog(
                        context: context,
                        barrierDismissible: true,
                        // Prevent closing the dialog by tapping outside
                        builder: (BuildContext context) {
                          return const SubscriptionPopup(
                              isManage:
                              true); // Use the SubscriptionPopup widget
                        },
                      );
                    },
                    width: 150,
                    backgroundGradientColor: AppColors.transparent,
                    borderGradientColor: AppColors.cardGradient,
                    isEditPage: true,
                    textColor: themeController.isDarkTheme.value
                        ? Colors.white
                        : AppColors.appColor, // Dynamic text color
                  );
                }),
            ],
          );
        }),
      ),
      body: Obx(() {
        // If no folder is selected
        if (controller.selectedClass.value.isEmpty) {
          // Show folder list if classList is not empty
          if (controller.classList.isNotEmpty) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: CustomButton(
                      width: 180,
                      height: 32,
                      textSize: 16,
                      text: 'Create New Class',
                      onPressed: () {
                        _showAddClassDialog(context);
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: controller.classList.length,
                      itemBuilder: (context, index) {
                        final classData = controller.classList[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: CustomButton(
                            isGem: true,
                            svgAsset: 'assets/images/home/class_icon.svg',
                            text: classData['folder_name'] ?? 'Unnamed Class',
                            onPressed: () {
                              controller.selectClass(classData['folder_name']);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          } else {
            // If classList is empty, show "Create a Class" button
            return Center(
              child: CustomButton(
                height: 60,
                textSize: 24,
                text: 'Create a Class',
                onPressed: () {
                  _showAddClassDialog(context);
                },
              ),
            );
          }
        } else {
          // If a folder is selected, show its chat names
          return _buildSelectedClassView();
        }
      }),
    );
  }

  Widget _buildSelectedClassView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  controller.clearSelection(); // Go back to folder list
                },
              ),
              Text(
                controller.selectedClass.value,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Obx(() {
            if (controller.selectedClassContents.isEmpty) {
              return const Center(
                child: Text(
                  'No chats available in this class.',
                  style: TextStyle(fontSize: 16),
                ),
              );
            }

            return ListView.builder(
              itemCount: controller.selectedClassContents.length,
              itemBuilder: (context, index) {
                final chat = controller.selectedClassContents[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: CustomButton(
                    text: chat['chat_name'] ?? 'Unnamed Chat',
                    onPressed: () {
                      print(':::::::::::::::::::::::CHAT: $chat');
                      Get.to(() => ChatContentScreen(content: chat['content'],chatId: chat['chat'],editId: chat['id'],isPinned: chat['is_pinned'], isSaved: chat['is_saved'],folderId: chat['folder_id'],title: chat['chat_name'],));
                    },
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }


  void _showAddClassDialog(BuildContext context) {
    TextEditingController classNameController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Class Name'),
          content: TextField(
            controller: classNameController,
            decoration: const InputDecoration(hintText: 'Class Name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final className = classNameController.text.trim();
                if (className.isNotEmpty) {
                  controller.addClass(className);
                }
                Get.back();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
