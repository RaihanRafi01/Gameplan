import 'package:agcourt/app/modules/history/controllers/history_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../../common/appColors.dart';
import '../../../../../common/widgets/custom_button.dart';
import '../../../home/controllers/chat_controller.dart';
import '../../../home/controllers/chat_edit_controller.dart';
import '../../../home/views/export_screen_view.dart';
import '../../controllers/theme_controller.dart';
import 'subscriptionPopup.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isFree;
  final Function(BuildContext,int) showDatePicker;
  final ChatController chatController;
  final int? chatId;

  MyAppBar({
    required this.isFree,
    required this.showDatePicker,
    required this.chatController,
    required this.chatId,
  });

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final historyController = Get.find<HistoryController>();

    return Obx(() {
      bool isDarkTheme = themeController.isDarkTheme.value;

      return AppBar(
        toolbarHeight: 40,
        backgroundColor: isDarkTheme ? Color(0xFF374151) : Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context); // Default back action
          },
          child: Icon(
            Icons.arrow_back, // Back button icon
            color: isDarkTheme ? Colors.white : Colors.black, // Adjust color based on theme
          ),
        ),
        centerTitle: true,
        title: isFree
            ? CustomButton(
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
            : SvgPicture.asset(
          'assets/images/auth/app_logo.svg',
          color: themeController.isDarkTheme.value
              ? Colors.white // White in dark mode
              : null, // Black in light mode
        ),
        actions: [
          PopupMenuButton<int>(
            color: isDarkTheme ? Colors.grey[900] : Colors.white,
            icon: Icon(Icons.menu, color: isDarkTheme ? Colors.white : Colors.black),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            offset: Offset(0, 50),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: SizedBox(
                  width: 80,
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/images/history/edit_icon.svg',
                        width: 24,
                        height: 24,
                        color: isDarkTheme ? Colors.white : Colors.black, // Adjust color based on theme
                      ),
                      SizedBox(width: 8),
                      Text("Edit", style: TextStyle(color: isDarkTheme ? Colors.white : Colors.black)),
                    ],
                  ),
                ),
              ),
              PopupMenuItem(
                value: 2,
                child: SizedBox(
                  width: 80, // Ensure the same width for all items
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/images/history/save_icon.svg',
                        width: 24,
                        height: 24,
                        color: isDarkTheme ? Colors.white : Colors.black, // Adjust color based on theme
                      ),
                      SizedBox(width: 8),
                      Text("Save",style: TextStyle(color: isDarkTheme ? Colors.white : Colors.black)),
                    ],
                  ),
                ),
              ),
              PopupMenuItem(
                value: 3,
                child: SizedBox(
                  width: 80,
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/images/history/pin_icon.svg',
                        width: 24,
                        height: 24,
                        color: isDarkTheme ? Colors.white : Colors.black, // Adjust color based on theme
                      ),
                      SizedBox(width: 8),
                      Text("Pin", style: TextStyle(color: isDarkTheme ? Colors.white : Colors.black)),
                    ],
                  ),
                ),
              ),
            ],
            onSelected: (value) {
              if (value == 1) {
                final ChatEditController editController = Get.put(ChatEditController());
                editController.disableEditing();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExportScreen(
                      messages: chatController.messages,
                      chatId: chatId!,
                    ),
                  ),
                );
              }
              else if (value == 2) {
                historyController.saveChat(chatId!);
              }
              else if (value == 3) {
                showDatePicker(context,chatId!);
              }
            },
          ),
        ],
      );
    });
  }

  @override
  Size get preferredSize => const Size.fromHeight(40);
}
