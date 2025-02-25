import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';
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
          return SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                !isFree
                    ? SvgPicture.asset(
                  'assets/images/auth/app_logo.svg',
                  color: themeController.isDarkTheme.value
                      ? Colors.white
                      : null,
                )
                    :  CustomButton(
                    height: 30,
                    textSize: 12,
                    text: 'Upgrade To Pro',
                    onPressed: () {
                      showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (BuildContext context) {
                          return const SubscriptionPopup(isManage: true);
                        },
                      );
                    },
                    width: 150,
                    backgroundGradientColor: themeController.isDarkTheme.value
                        ? AppColors.cardGradient
                        : [Colors.transparent, Colors.transparent],
                    borderGradientColor: themeController.isDarkTheme.value
                        ? AppColors.transparent
                        : AppColors.cardGradient,
                    isEditPage: true,
                    textColor: themeController.isDarkTheme.value
                        ? Colors.white
                        : AppColors.appColor3, // Replace with your day mode text color
                  )
              ],
            ),
          );
        }),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          // Show loading spinner while data is being fetched
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.selectedClass.value.isEmpty) {
          if (controller.classList.isNotEmpty) {
            return _buildClassList(context);
          } else {
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
          return _buildSelectedClassView();
        }
      }),
    );
  }

  Widget _buildClassList(context) {
    return Column(
      children: [
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
              'My Classes',
              style: h3.copyWith(
                fontSize: 24,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Align(
            alignment: Alignment.centerRight,
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: AppColors.cardGradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    _showAddClassDialog(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: controller.classList.length,
            itemBuilder: (context, index) {
              final classData = controller.classList[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
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
                  controller.clearSelection();
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
                  padding: const EdgeInsets.all(8.0),
                  child: CustomButton(
                    text: chat['chat_name'] ?? 'Unnamed Chat',
                    onPressed: () {
                      Get.to(() => ChatContentScreen(
                        content: chat['content'],
                        chatId: chat['chat'],
                        editId: chat['id'],
                        isPinned: chat['is_pinned'],
                        isSaved: chat['is_saved'],
                        folderId: chat['folder_id'],
                        title: chat['chat_name'],
                      ));
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
