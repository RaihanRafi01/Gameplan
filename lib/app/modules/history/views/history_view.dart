import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';
import '../../../../common/widgets/custom_button.dart';
import '../../dashboard/controllers/theme_controller.dart';
import '../../dashboard/views/widgets/subscriptionPopup.dart';
import '../../home/controllers/home_controller.dart';
import '../../home/views/chat_screen_view.dart';
import '../../save_class/views/chatContentScreen.dart';
import '../controllers/edit_controller.dart';
import '../controllers/edit_history_controller.dart';
import '../controllers/history_controller.dart';

class HistoryView extends GetView<HistoryController> {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HistoryController());
    final EditController editHistoryController = Get.put(EditController());
    Get.find<HistoryController>().fetchAllChatList();
    Get.find<EditController>().fetchAllChatList();
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0),
        child: Obx(() {
          final ThemeController themeController = Get.find<ThemeController>();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 50,
                width: double.maxFinite,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: AppColors.cardGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Recent Plan',
                          style: h2.copyWith(fontSize: 24, color: Colors.white),
                        ),
                      ),
                      Card(
                        color: themeController.isDarkTheme.value
                            ? Colors.black38
                            : Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: DropdownButtonHideUnderline(
                            child: Obx(
                              () => DropdownButton<String>(
                                dropdownColor: themeController.isDarkTheme.value
                                    ? Colors.black
                                    : Colors.white,
                                value: controller.selectedFilter.value,
                                items: [
                                  DropdownMenuItem(
                                    value: 'All',
                                    child: Text(
                                      'All Plans',
                                      style: h3.copyWith(
                                        color: themeController.isDarkTheme.value
                                            ? Colors.white
                                            : Colors
                                                .black, // Dynamic text color
                                      ),
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Pin',
                                    child: Text(
                                      'Pin Plans',
                                      style: h3.copyWith(
                                        color: themeController.isDarkTheme.value
                                            ? Colors.white
                                            : Colors
                                                .black, // Dynamic text color
                                      ),
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Save',
                                    child: Text(
                                      'Save Plans',
                                      style: h3.copyWith(
                                        color: themeController.isDarkTheme.value
                                            ? Colors.white
                                            : Colors
                                                .black, // Dynamic text color
                                      ),
                                    ),
                                  ),
                                ],
                                onChanged: (value) {
                                  if (value != null) {
                                    controller.updateFilter(value);
                                  }
                                },
                                borderRadius: BorderRadius.circular(12),
                                alignment: AlignmentDirectional.bottomStart,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Obx(() {
                  final groupedChats = controller.groupedChatHistory;

                  if (groupedChats.isEmpty) {
                    return Center(
                      child: Text(
                        'No plans available',
                        style: h3.copyWith(
                          color: themeController.isDarkTheme.value
                              ? Colors.white70
                              : Colors.black87, // Dynamic text color
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: groupedChats.keys.length,
                    itemBuilder: (context, groupIndex) {
                      // Get the date group key and its chats
                      final groupKey = groupedChats.keys.elementAt(groupIndex);
                      final chats = groupedChats[groupKey]!;

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Date group header
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                groupKey,
                                style: h3.copyWith(
                                  fontSize: 22,
                                  color: themeController.isDarkTheme.value
                                      ? Colors.white
                                      : AppColors
                                          .textHistory, // Dynamic text color
                                ),
                              ),
                            ),
                            // Chat list for the date group
                            ...chats.map((chat) {
                              return ListTile(
                                title: GestureDetector(
                                  onTap: () {
                                    Get.to(() => ChatScreen(
                                              chat: chat.chatContents,
                                              chatId: chat.id,
                                              chatName: chat.chatName,
                                            ))
                                        ?.then(
                                            (value) => controller.fetchData());
                                  },
                                  child: Text(
                                    chat.chatName,
                                    style: h3.copyWith(
                                      fontSize: 18,
                                      color: themeController.isDarkTheme.value
                                          ? Colors.white
                                          : AppColors
                                              .textHistory, // Dynamic text color
                                    ),
                                  ),
                                ),
                                trailing: PopupMenuButton<int>(
                                  icon: Icon(
                                    Icons.more_horiz_rounded,
                                    color: themeController.isDarkTheme.value
                                        ? Colors.white
                                        : Colors.black, // Dynamic icon color
                                  ),
                                  onSelected: (value) {
                                    switch (value) {
                                      case 0:
                                        if (chat.isPinned) {
                                          controller.unpinChat(chat.id);
                                        } else {
                                          _showDatePicker(context, chat.id);
                                        }
                                        break;
                                      case 1:
                                        _showEditDialog(
                                            context, chat.id, chat.chatName,false);
                                        break;
                                      case 2:
                                        _showDeleteDialog(context, chat.id,false);
                                        break;
                                    }
                                  },
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      value: 0,
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                            chat.isPinned
                                                ? 'assets/images/history/pin_icon.svg'
                                                : 'assets/images/history/pin_icon.svg',
                                            color: themeController
                                                    .isDarkTheme.value
                                                ? Colors.white
                                                : Colors
                                                    .black, // Dynamic icon color
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            chat.isPinned ? 'Unpin' : 'Pin',
                                            style: h3.copyWith(
                                              fontSize: 16,
                                              color: themeController
                                                      .isDarkTheme.value
                                                  ? Colors.white
                                                  : Colors
                                                      .black, // Dynamic text color
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: 1,
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                            'assets/images/history/edit_icon.svg',
                                            color: themeController
                                                    .isDarkTheme.value
                                                ? Colors.white
                                                : Colors
                                                    .black, // Dynamic icon color
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            'Edit',
                                            style: h3.copyWith(
                                              fontSize: 16,
                                              color: themeController
                                                      .isDarkTheme.value
                                                  ? Colors.white
                                                  : Colors
                                                      .black, // Dynamic text color
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: 2,
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                            'assets/images/history/delete_icon.svg',
                                            color: themeController
                                                    .isDarkTheme.value
                                                ? Colors.white
                                                : Colors
                                                    .black, // Dynamic icon color
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            'Delete',
                                            style: h3.copyWith(
                                              fontSize: 16,
                                              color: themeController
                                                      .isDarkTheme.value
                                                  ? Colors.white
                                                  : Colors
                                                      .black, // Dynamic text color
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      );
                    },
                  );
                }),
              ),
              Container(
                height: 50,
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
                    'Save Class',
                    style: h3.copyWith(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Obx(() {
                  final groupedChats = editHistoryController.groupedChatHistory;

                  if (groupedChats.isEmpty) {
                    return Center(
                      child: Text(
                        'No plans available',
                        style: h3.copyWith(
                          color: themeController.isDarkTheme.value
                              ? Colors.white70
                              : Colors.black87, // Dynamic text color
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: groupedChats.keys.length,
                    itemBuilder: (context, groupIndex) {
                      // Get the date group key and its chats
                      final groupKey = groupedChats.keys.elementAt(groupIndex);
                      final chats = groupedChats[groupKey]!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Date group header
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              groupKey,
                              style: h3.copyWith(
                                fontSize: 22,
                                color: themeController.isDarkTheme.value
                                    ? Colors.white
                                    : AppColors
                                        .textHistory, // Dynamic text color
                              ),
                            ),
                          ),
                          // Chat list for the date group
                          ...chats.map((chat) {
                            return ListTile(
                              title: GestureDetector(
                                onTap: () {
                                  Get.to(ChatContentScreen(content:chat.content,chatId:chat.chatId,editId: chat.id,isPinned: chat.isPinned));
                                },
                                child: Text(
                                  chat.chatName,
                                  style: h3.copyWith(
                                    fontSize: 18,
                                    color: themeController.isDarkTheme.value
                                        ? Colors.white
                                        : AppColors
                                            .textHistory, // Dynamic text color
                                  ),
                                ),
                              ),
                              trailing: PopupMenuButton<int>(
                                icon: Icon(
                                  Icons.more_horiz_rounded,
                                  color: themeController.isDarkTheme.value
                                      ? Colors.white
                                      : Colors.black, // Dynamic icon color
                                ),
                                onSelected: (value) {
                                  switch (value) {
                                    case 1:
                                      _showEditDialog(
                                          context, chat.id, chat.chatName,true);
                                      break;
                                    case 2:
                                      _showDeleteDialog(context, chat.id,true);
                                      break;
                                  }
                                },
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    value: 1,
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          'assets/images/history/edit_icon.svg',
                                          color: themeController
                                              .isDarkTheme.value
                                              ? Colors.white
                                              : Colors
                                              .black, // Dynamic icon color
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          'Edit',
                                          style: h3.copyWith(
                                            fontSize: 16,
                                            color: themeController
                                                .isDarkTheme.value
                                                ? Colors.white
                                                : Colors
                                                .black, // Dynamic text color
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 2,
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          'assets/images/history/delete_icon.svg',
                                          color: themeController
                                              .isDarkTheme.value
                                              ? Colors.white
                                              : Colors
                                              .black, // Dynamic icon color
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          'Delete',
                                          style: h3.copyWith(
                                            fontSize: 16,
                                            color: themeController
                                                .isDarkTheme.value
                                                ? Colors.white
                                                : Colors
                                                .black, // Dynamic text color
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ],
                      );
                    },
                  );
                }),
              ),
            ],
          );
        }),
      ),
    );
  }

  void _showDatePicker(BuildContext context, int chatId) async {
    // Step 1: Show Date Picker
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      // Step 2: Show Time Picker
      TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (selectedTime != null) {
        // Combine the selected date and time into a single DateTime object
        final DateTime finalDateTime = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );

        // Call the controller to save the chat with the date and time
        controller.pinChat(chatId, finalDateTime);
      }
    }
  }

  void _showEditDialog(BuildContext context, int chatId, String currentTitle,bool isEdit) {
    final TextEditingController textController = TextEditingController(text: currentTitle);
    final EditController editHistoryController = Get.put(EditController());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Chat Title', style: h3),
          content: TextField(
            controller: textController,
            decoration: InputDecoration(
              labelText: 'Chat Title',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: h3.copyWith(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                final newTitle = textController.text.trim();
                if (newTitle.isNotEmpty) {
                  if(isEdit){
                    editHistoryController.updateChatTitle(chatId, newTitle);
                  }
                  if(!isEdit){
                    controller.updateChatTitle(chatId, newTitle);
                  }
                }
                Navigator.pop(context);
              },
              child: Text('Save', style: h3.copyWith(color: Colors.green)),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, int chatId,bool isEdit) {
    final EditController editHistoryController = Get.put(EditController());
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Do you want to Delete this chat?', style: h3),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel',
                  style: h3.copyWith(color: AppColors.textColor)),
            ),
            TextButton(
              onPressed: () {
                if(isEdit){
                  editHistoryController.deleteChat(chatId);
                }
                if(!isEdit){
                  controller.deleteChat(chatId);
                }
                Navigator.pop(context);
              },
              child: Text('Delete', style: h3.copyWith(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
