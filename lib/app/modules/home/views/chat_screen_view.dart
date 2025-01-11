import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:agcourt/app/modules/home/controllers/home_controller.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../common/appColors.dart';
import '../../../../common/widgets/customAppBar.dart';
import '../../../../common/widgets/custom_button.dart';
import '../../../../common/widgets/home/custom_messageInputField.dart';
import '../../../../common/widgets/home/messageBubble.dart';
import '../../dashboard/views/widgets/subscriptionPopup.dart';
import '../../history/controllers/history_controller.dart';
import '../controllers/chat_controller.dart';
import 'export_screen_view.dart';

class ChatScreen extends StatelessWidget {
  final List<ChatContent>? chat;
  final String? initialMessage;
  final int? chatId;
  final String? chatName;

  ChatScreen(
      {super.key,
      this.chat,
      this.initialMessage,
      this.chatId,
      this.chatName,
      });

  // Initialize the controller
  final ChatController chatController = Get.put(ChatController());

  final HistoryController historyController = Get.put(HistoryController());
  final HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {

    if (chat != null) {
      chatController.initializeMessages(chat!);
      chatController.chatId.value = chatId;
    }

    final bool isFree = homeController.isFree.value;
    print('=====================================================:::::::::::::::STATUS::::$isFree');

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context); // Default back action
          },
          child: Icon(
            Icons.arrow_back, // Back button icon
            color: Colors.black, // Adjust the color
          ),
        ),
        centerTitle: true,
        title: isFree? CustomButton(
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
          width: 170,
          backgroundGradientColor: AppColors.transparent,
          borderGradientColor: AppColors.cardGradient,
          isEditPage: true,
          textColor: AppColors.textColor,
        ): SvgPicture.asset('assets/images/auth/app_logo.svg'),
        actions: [
          PopupMenuButton<int>(
            color: Colors.white,
            icon: Icon(Icons.menu),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            offset: Offset(0, 50),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: SizedBox(
                  width: 135, // Ensure the same width for all items
                  child: Row(
                    children: [
                      Icon(Icons.copy_rounded),
                      SizedBox(width: 8),
                      Text("Copy"),
                    ],
                  ),
                ),
              ),
              PopupMenuItem(
                value: 2,
                child: SizedBox(
                  width: 135, // Ensure the same width for all items
                  child: Row(
                    children: [
                      Icon(Icons.edit),
                      SizedBox(width: 8),
                      Text("Edit"),
                    ],
                  ),
                ),
              ),
              PopupMenuItem(
                value: 3,
                child: SizedBox(
                  width: 135, // Ensure the same width for all items
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/history/save_icon.png',
                        scale: 3,
                      ),
                      SizedBox(width: 8),
                      Text("Save To Class"),
                    ],
                  ),
                ),
              ),
              PopupMenuItem(
                value: 4,
                child: SizedBox(
                  width: 135, // Adjust width consistently
                  child: Row(
                    children: [
                      Icon(Icons.file_upload_outlined),
                      SizedBox(width: 8),
                      Text("Export"),
                    ],
                  ),
                ),
              ),
              PopupMenuItem(
                value: 5,
                child: SizedBox(
                  width: 135, // Adjust width consistently
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/images/history/pin_icon.svg',
                        width: 24,
                        height: 24,
                      ),
                      SizedBox(width: 8),
                      Text("Pin To Calender"),
                    ],
                  ),
                ),
              ),
            ],
            onSelected: (value) {
              if (value == 1) {
                _copyAllMessages(context);
              } else if (value == 2) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExportScreen(messages: chatController.messages,chatId: chatId!,),
                  ),
                );
              } else if (value == 3) {
                historyController.saveChat(chatId!);
              }
              else if (value == 4) {
                _exportToPDF(context);
              }
              else if (value == 5) {
                _showDatePicker(context, chatId!);
              }
            },
          ),
        ],
      ),
        body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Column(
          children: [
            Expanded(
              child: Obx(
                () => ListView.builder(
                  controller: ScrollController(),
                  itemCount: chatController.messages.length,
                  reverse: true,
                  itemBuilder: (context, index) {
                    final messageData =
                        chatController.messages.reversed.toList()[index];
                    final actualIndex =
                        chatController.messages.length - 1 - index;
                    return MessageBubble(
                      message: messageData['message'],
                      isSentByUser: messageData['isSentByUser'],
                      editCallback: !messageData['isSentByUser']
                          ? () {
                        var botChatId = chat?[actualIndex].id;
                        print('::::::::::botChatId HIT::::::::::::::::::::::::::::::::::$botChatId');
                        chatController.startEditingMessage(actualIndex,botChatId!);
                      }

                          : null,
                    );
                  },
                ),
              ),
            ),
            Obx(
              () => CustomMessageInputField(
                padding: 0,
                textController: chatController.messageController,
                onSend: (){
                  chatController.sendMessage() ;
                }  ,
                hintText: chatController.editingMessageIndex.value != null
                    ? 'Edit bot message'
                    : 'Type a message',
              ),
            ),
          ],
        ),
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
        historyController.pinChat(chatId, finalDateTime);
      }
    }
  }

  void _copyAllMessages(BuildContext context) {
    final allMessages = chatController.messages
        .map((message) => message['message'])
        .join("\n");
    Clipboard.setData(ClipboardData(text: allMessages));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("All messages copied to clipboard!")),
    );
  }

  Future<void> _exportToPDF(BuildContext context) async {
    String? outputDir = await FilePicker.platform.getDirectoryPath();
    if (outputDir == null) return;

    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: chatController.messages.map((message) {
              return pw.Text(
                message['message'],
                style: pw.TextStyle(
                  fontSize: 14,
                  color: message['isSentByUser']
                      ? PdfColors.black
                      : PdfColors.purple,
                ),
              );
            }).toList(),
          );
        },
      ),
    );

    final file = File("$outputDir/chat_export.pdf");
    await file.writeAsBytes(await pdf.save());
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("PDF saved to: ${file.path}")),
    );
  }


}
