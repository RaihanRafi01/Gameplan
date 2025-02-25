import 'package:agcourt/app/modules/home/controllers/chat_controller.dart';
import 'package:agcourt/app/modules/profile/views/faq_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';
import '../../../../common/widgets/custom_button.dart';
import '../../../../common/widgets/home/custom_messageInputField.dart';
import '../../dashboard/controllers/theme_controller.dart';
import '../../dashboard/views/widgets/subscriptionPopup.dart';
import '../../history/controllers/history_controller.dart';
import '../controllers/home_controller.dart';
import 'chat_screen_view.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatController chatController = Get.put(ChatController());
    final HomeController homeController = Get.put(HomeController());
    final HistoryController historyController = Get.put(HistoryController());
    historyController.fetchPinChatList();
    final TextEditingController textController = TextEditingController();
    final bool isFree2 = homeController.isFree.value;
    final ThemeController themeController = Get.find<ThemeController>();
    final FocusNode textFieldFocusNode = FocusNode();

    // Ensure keyboard is dismissed on initial load or return
    WidgetsBinding.instance.addPostFrameCallback((_) {
      textFieldFocusNode.unfocus();
      print('HomeView loaded or returned, keyboard dismissed');
    });

    return WillPopScope(
      onWillPop: () async {
        textFieldFocusNode.unfocus();
        print('Back button pressed, keyboard dismissed');
        return true;
      },
      child: Scaffold(
        body: GestureDetector(
          onTap: () {
            textFieldFocusNode.unfocus(); // Dismiss keyboard when tapping outside
            print('Tapped outside, keyboard dismissed');
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 40),
                  if (isFree2)
                    Obx(() {
                      return CustomButton(
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
                            : AppColors.appColor3,
                      );
                    }),
                  SizedBox(height: 60),
                  Obx(() {
                    return SvgPicture.asset(
                      'assets/images/auth/app_logo.svg',
                      color: themeController.isDarkTheme.value ? Colors.white : null,
                    );
                  }),
                  SizedBox(height: 30),
                  Text(
                    "What do you need help with today?",
                    style: h3.copyWith(fontSize: 28),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: GestureDetector(
                        onTap: () => Get.to(
                              () => FaqView(selectedIndex: 0),
                          transition: Transition.noTransition,
                        ),
                        child: Obx(() {
                          return Container(
                            constraints: BoxConstraints(maxWidth: double.maxFinite),
                            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: themeController.isDarkTheme.value
                                    ? Colors.white
                                    : Colors.black,
                                width: 1,
                              ),
                            ),
                            child: Text(
                              "What should I tell the AI to get the best session plan?",
                              style: TextStyle(
                                fontSize: 16,
                                color: themeController.isDarkTheme.value
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                  Obx(() {
                    final bool isFree = homeController.isFree.value;
                    return CustomMessageInputField(
                      textController: textController,
                      focusNode: textFieldFocusNode,
                      onSend: () async {
                        final message = textController.text.trim();
                        textFieldFocusNode.unfocus(); // Dismiss keyboard immediately

                        if (message.isNotEmpty) {
                          print('::::::::::is free before sending :::::::::${homeController.isFree.value}');
                          int? chatId = chatController.chatId.value;

                          print('hit subscribed');
                          await chatController.createChat(message).then((_) {
                            chatId = chatController.chatId.value;

                            String truncatedMessage = message.length > 20
                                ? '${message.substring(0, 20)}...'
                                : message;

                            historyController.updateChatTitle(chatId!, truncatedMessage);
                            Get.to(
                                  () => ChatScreen(chatId: chatId, chatName: 'Untitled Chat'),
                              transition: Transition.noTransition,
                            )?.then((_) {
                              textFieldFocusNode.unfocus();
                              print('Returned from ChatScreen, keyboard dismissed');
                            });
                          });

                          textController.clear();
                        }
                      },
                    );
                  }),
                  Obx(() => chatController.isLoading.value
                      ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.textColor),
                    ),
                  )
                      : const SizedBox.shrink()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}