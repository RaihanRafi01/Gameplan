// chatContentScreen.dart
import 'dart:convert';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:xml/xml.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:pdf/widgets.dart' as pw;
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:xml/xml.dart';
import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';
import '../../../../common/widgets/history/folderSelectionDialog.dart';
import '../../dashboard/controllers/theme_controller.dart';
import '../../history/controllers/edit_controller.dart';
import '../../history/controllers/history_controller.dart';
import '../../home/controllers/textEditorController.dart';
import '../../home/views/export_screen_view.dart';
import '../controllers/save_class_controller.dart';

class ChatContentScreen extends StatefulWidget {
  //final Map<String, dynamic> chat;
  final String content;
  final int chatId;
  final int editId;
  final bool isPinned;
  final bool isSaved;
  final int? folderId;
  final String title;

  const ChatContentScreen(
      {super.key,
      required this.editId,
      required this.chatId,
      required this.content,
      required this.isPinned,
      this.folderId,
      required this.isSaved,
      required this.title});

  @override
  _ChatContentScreenState createState() => _ChatContentScreenState();
}

class _ChatContentScreenState extends State<ChatContentScreen> {
  final textEditorController = TextEditorController();
  final HistoryController historyController = Get.put(HistoryController());
  final messages = <Map<String, dynamic>>[].obs; // Reactive list for messages
  late List<TextEditingController> textControllers;
  final EditController historyEditController = Get.put(EditController());
  final SaveClassController saveClassController =
      Get.put(SaveClassController());
  final RxString title = ''.obs;
  final RxBool isEditMode = false.obs;
  final RxBool isPinMode = false.obs;


  @override
  void initState() {
    super.initState();
    print(':::::::::::::::::::::::::::::::::::::::::::::::::::::::: content : ${widget.content}');
    title.value = widget.title;
    isPinMode.value = widget.isPinned;
    saveClassController.isSaveMode.value = widget.isSaved;
    _parseHtmlContent(widget.content);
    _initializeTextControllers();
  }

  @override
  void dispose() {
    for (var controller in textControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Obx(() {
            final ThemeController themeController = Get.find<ThemeController>();
            return Text(
              title.value,
              style: TextStyle(
                color: themeController.isDarkTheme.value
                    ? Colors.white // White in dark mode
                    : Colors.black, // Black in light mode
              ),
            );
          }),
          actions: [
            Obx(() {
              final ThemeController themeController =
                  Get.find<ThemeController>();
              final popupMenuColor = themeController.isDarkTheme.value
                  ? Colors.grey[850] // Dark background in dark mode
                  : Colors.white; // Light background in light mode

              return PopupMenuButton<int>(
                color: popupMenuColor,
                icon: Icon(
                  Icons.menu,
                  color: themeController.isDarkTheme.value
                      ? Colors.white // White in dark mode
                      : Colors.black, // Black in light mode
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                offset: Offset(0, 50),
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      value: 1,
                      child: Row(
                        children: [
                          Icon(
                            Icons.edit,
                            color: themeController.isDarkTheme.value
                                ? Colors.white
                                : Colors.black,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Rename",
                            style: TextStyle(
                              color: themeController.isDarkTheme.value
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 0,
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/images/history/edit_icon.svg',
                            width: 23,
                            height: 23,
                            color: themeController.isDarkTheme.value
                                ? Colors.white
                                : Colors.black,
                          ),
                          SizedBox(width: 8),
                          Obx(() => Text(
                                isEditMode.value ? "View Mode" : "Edit",
                                style: TextStyle(
                                  color: themeController.isDarkTheme.value
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              )),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 2,
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/images/history/pin_icon.svg',
                            width: 23,
                            height: 23,
                            color: themeController.isDarkTheme.value
                                ? Colors.white
                                : Colors.black,
                          ),
                          SizedBox(width: 8),
                          Obx(() => Text(
                                isPinMode.value ? "UnPin" : "Pin",
                                style: TextStyle(
                                  color: themeController.isDarkTheme.value
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              )),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 3,
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/images/history/save_icon.svg',
                            width: 23,
                            height: 23,
                            color: themeController.isDarkTheme.value
                                ? Colors.white
                                : Colors.black,
                          ),
                          SizedBox(width: 8),
                          Obx(() => Text(
                            saveClassController.isSaveMode.value
                                    ? "UnSave To Class"
                                    : "Save To Class",
                                style: TextStyle(
                                  color: themeController.isDarkTheme.value
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              )),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 4,
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/images/history/delete_icon.svg',
                            width: 24,
                            height: 24,
                            color: themeController.isDarkTheme.value
                                ? Colors.white
                                : Colors.black,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Delete",
                            style: TextStyle(
                              color: themeController.isDarkTheme.value
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 5,
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/images/history/export_icon.svg',
                            width: 24,
                            height: 24,
                            color: themeController.isDarkTheme.value
                                ? Colors.white
                                : Colors.black,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Export as PDF",
                            style: TextStyle(
                              color: themeController.isDarkTheme.value
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 7,
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/images/history/export_icon.svg', // You can replace this with an appropriate .docx icon path or use an Icon
                            width: 24,
                            height: 24,
                            color: themeController.isDarkTheme.value
                                ? Colors.white
                                : Colors.black,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Export as Docx",
                            style: TextStyle(
                              color: themeController.isDarkTheme.value
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 6,
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/images/history/save_icon.svg',
                            width: 24,
                            height: 24,
                            color: themeController.isDarkTheme.value
                                ? Colors.white
                                : Colors.black,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Update",
                            style: TextStyle(
                              color: themeController.isDarkTheme.value
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ];
                },
                onSelected: (value) async {
                  if (value == 1) {
                    _showEditDialog(context, widget.editId, widget.title);
                  } else if (value == 0) {
                    isEditMode.value = !isEditMode.value;
                    textEditorController.currentEditingIndex.value =
                        textEditorController.currentEditingIndex.value == -1
                            ? 0
                            : -1;
                  } else if (value == 2) {
                    if (isPinMode.value) {
                      await historyController.unpinEditChat(widget.editId);
                      isPinMode.value = false;
                    } else {
                      _showDatePicker(context, widget.editId);
                      isPinMode.value = true;
                    }
                  } else if (value == 3) {
                    if (saveClassController.isSaveMode.value) {
                      await saveClassController.unSaveEditedChat(
                          widget.editId, widget.folderId!);
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) => FolderSelectionDialog(
                          editId: widget.editId,
                        ),
                      );

                    }
                  } else if (value == 4) {
                    _showDeleteDialog(context, widget.editId);
                  } else if (value == 5) {
                    // export logic
                    final filePath = await _promptAndSavePDF();
                    if (filePath != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("PDF saved to: $filePath")),
                      );
                      _showPDF(filePath);
                      //editController.disableEditing();
                    }
                    //await generateDocx('okay working');
                  } else if (value == 6) {
                    textEditorController.currentEditingIndex.value = -1;
                    final htmlContent = _generateHTMLContent();
                    historyEditController.updateEditChat(
                        widget.editId, htmlContent);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Saved successfully!")),
                    );
                  }else if (value == 7) {
                    // New logic for generating .docx
                    await generateAndShowDocx();
                  }
                },
              );
            }),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Obx(() => textEditorController.currentEditingIndex.value != -1
                  ? _buildToolbar()
                  : const SizedBox.shrink()),
              Expanded(
                child: Obx(() => ListView.builder(
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        return Obx(() {
                          final isEditing =
                              textEditorController.currentEditingIndex.value ==
                                  index;

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              children: [
                                /*Text(
                            "${messages[index]['sender']}: ",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                            ),
                          ),*/
                                Expanded(
                                  child: isEditing
                                      ? TextField(
                                          controller: textControllers[index],
                                          style: textEditorController
                                              .textStyles[index],
                                          textAlign: textEditorController
                                              .textAlignments[index],
                                          onChanged: (value) {
                                            messages[index]['content'] = value;
                                          },
                                          onSubmitted: (value) {
                                            // Exit edit mode after submission
                                            textEditorController
                                                .currentEditingIndex.value = -1;
                                          },
                                          autofocus: true,
                                          maxLines: null,
                                          // Allow multi-line input
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                          ),
                                        )
                                      : GestureDetector(
                                          onTap: () {
                                            // Allow editing only if index is valid
                                            if (textEditorController
                                                    .currentEditingIndex
                                                    .value ==
                                                -1) return;

                                            textEditorController
                                                .currentEditingIndex
                                                .value = index;

                                            // Retain cursor position after tapping
                                            WidgetsBinding.instance
                                                .addPostFrameCallback(
                                              (_) => textControllers[index]
                                                      .selection =
                                                  TextSelection.fromPosition(
                                                TextPosition(
                                                  offset: textControllers[index]
                                                      .text
                                                      .length,
                                                ),
                                              ),
                                            );
                                          },
                                          child: Text(
                                            messages[index]['content'],
                                            style: textEditorController
                                                .textStyles[index]
                                                .merge(
                                              TextStyle(
                                                fontWeight: messages[index]
                                                            ['sender'] ==
                                                        'User'
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                              ),
                                            ),
                                            /*style: textEditorController
                                    .textStyles[index],*/
                                            textAlign: textEditorController
                                                .textAlignments[index],
                                          ),
                                        ),
                                ),
                              ],
                            ),
                          );
                        });
                      },
                    )),
              ),
            ],
          ),
        ));
  }

  void _parseHtmlContent(String htmlContent) {
    final document = html_parser.parse(htmlContent);
    final paragraphs = document.getElementsByTagName('p');
    final parsedMessages = <Map<String, dynamic>>[];

    textEditorController.textStyles.clear();
    textEditorController.textAlignments.clear();

    for (var paragraph in paragraphs) {
      final style = paragraph.attributes['style'] ?? '';
      final strongTag = paragraph.getElementsByTagName('strong').firstOrNull;
      final sender = strongTag?.text.replaceAll(':', '') ?? 'unknown';

      // Remove the sender prefix (e.g., "User:" or "Bot:") from the content
      final content = paragraph.text.replaceFirst(RegExp(r'^.*:\s*'), '').trim();

      // Extract text style and alignment
      final textStyle = _parseInlineStyles(style);
      final textAlign = _parseAlignmentFromStyle(style);

      parsedMessages.add({
        'sender': sender,
        'content': content,
        'style': textStyle,
        'alignment': textAlign,
      });

      // Assign extracted styles to textEditorController
      textEditorController.textStyles.add(textStyle);
      textEditorController.textAlignments.add(textAlign);
    }

    messages.assignAll(parsedMessages);
  }


  TextStyle _parseInlineStyles(String style) {
    final fontSizeRegex = RegExp(r'font-size:\s*([\d.]+)px;');
    final colorRegex = RegExp(r'color:\s*([^;]+);');

    final fontSize = double.tryParse(
          fontSizeRegex.firstMatch(style)?.group(1) ?? '16.0',
        ) ??
        16.0;

    return TextStyle(fontSize: fontSize);
  }


  TextAlign _parseAlignmentFromStyle(String style) {
    if (style.contains('text-align: center;')) {
      return TextAlign.center;
    } else if (style.contains('text-align: right;')) {
      return TextAlign.right;
    } else {
      return TextAlign.left; // Default alignment
    }
  }

  void _initializeTextControllers() {
    textControllers = List.generate(
      messages.length,
      (index) => TextEditingController(text: messages[index]['content']),
    );
  }

  Widget _buildToolbar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Obx(() => DropdownButton<double>(
                value: textEditorController.fontSize.value,
                items: [12.0, 14.0, 16.0, 18.0, 20.0, 22.0, 24.0]
                    .map((size) => DropdownMenuItem(
                          value: size,
                          child: Text(size.toString()),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (textEditorController.currentEditingIndex.value != -1) {
                    textEditorController.fontSize.value = value!;
                    textEditorController.updateTextStyle(
                      index: textEditorController.currentEditingIndex.value,
                      fontSize: value,
                    );
                  }
                },
              )),
          _buildIconButton(
            icon: Icons.format_bold,
            isActive: (index) =>
                textEditorController.textStyles[index].fontWeight ==
                FontWeight.bold,
            onPressed: (index) {
              final isBold =
                  textEditorController.textStyles[index].fontWeight ==
                      FontWeight.bold;
              textEditorController.updateTextStyle(
                index: index,
                fontWeight: isBold ? FontWeight.normal : FontWeight.bold,
              );
            },
          ),
          _buildIconButton(
            icon: Icons.format_italic,
            isActive: (index) =>
                textEditorController.textStyles[index].fontStyle ==
                FontStyle.italic,
            onPressed: (index) {
              final isItalic =
                  textEditorController.textStyles[index].fontStyle ==
                      FontStyle.italic;
              textEditorController.updateTextStyle(
                index: index,
                fontStyle: isItalic ? FontStyle.normal : FontStyle.italic,
              );
            },
          ),
          _buildIconButton(
            icon: Icons.format_align_left,
            isActive: (index) =>
                textEditorController.textAlignments[index] == TextAlign.left,
            onPressed: (index) {
              textEditorController.updateTextAlignment(index, TextAlign.left);
            },
          ),
          _buildIconButton(
            icon: Icons.format_align_center,
            isActive: (index) =>
                textEditorController.textAlignments[index] == TextAlign.center,
            onPressed: (index) {
              textEditorController.updateTextAlignment(index, TextAlign.center);
            },
          ),
          _buildIconButton(
            icon: Icons.format_align_right,
            isActive: (index) =>
                textEditorController.textAlignments[index] == TextAlign.right,
            onPressed: (index) {
              textEditorController.updateTextAlignment(index, TextAlign.right);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required bool Function(int) isActive,
    required void Function(int) onPressed,
  }) {
    return Obx(() {
      final index = textEditorController.currentEditingIndex.value;
      return IconButton(
        icon: Icon(icon, color: isActive(index) ? Colors.blue : Colors.black),
        onPressed: () => onPressed(index),
      );
    });
  }

  String _generateHTMLContent() {
    final htmlContent = StringBuffer();

    for (int index = 0; index < messages.length; index++) {
      final sender = messages[index]['sender'] == 'User' ? 'User:' : 'Bot:';
      final content = messages[index]['content'];

      // Determine text alignment
      String alignment;
      switch (textEditorController.textAlignments[index]) {
        case TextAlign.center:
          alignment = 'center';
          break;
        case TextAlign.right:
          alignment = 'right';
          break;
        case TextAlign.left:
        default:
          alignment = 'left';
          break;
      }

      // Generate inline styles
      final style = '''
        font-size: ${textEditorController.textStyles[index].fontSize}px;
        font-weight: ${textEditorController.textStyles[index].fontWeight == FontWeight.bold ? 'bold' : 'normal'};
        font-style: ${textEditorController.textStyles[index].fontStyle == FontStyle.italic ? 'italic' : 'normal'};
        text-decoration: ${textEditorController.textStyles[index].decoration == TextDecoration.underline ? 'underline' : 'none'};
        text-align: $alignment;
        color: ${sender == 'User' ? 'black' : 'purple'};
      ''';

      // Wrap content in <p> tags with <strong> for sender
      htmlContent.write(
        '<p style="$style"><strong>$sender</strong>$content</p>',
      );
    }

    return htmlContent.toString();
  }

  void _showDatePicker(BuildContext context, int editId) async {
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
        historyController.pinEditChat(editId, finalDateTime);
      }
    }
  }

  void _showEditDialog(BuildContext context, int chatId, String currentTitle) {
    final TextEditingController textController =
        TextEditingController(text: currentTitle);

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
                  // Update the reactive title
                  title.value = newTitle;

                  // Update the title in the controller (if needed)
                  historyEditController.updateChatTitle(chatId, newTitle);
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

  void _showDeleteDialog(BuildContext context, int chatId) {
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
              onPressed: () async {
                await editHistoryController.deleteChat(chatId);
                Navigator.pop(context);
                Get.back();
              },
              child: Text('Delete', style: h3.copyWith(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  /*Future<void> generateAndShowDocx() async {
    try {
      // Load the template file from assets
      var data = await rootBundle.load('assets/template/template.docx');
      final bytes = data.buffer.asUint8List();

      // Load the template
      final docx = await DocxTemplate.fromBytes(bytes);



      // Replace placeholders with your content
      Content c = Content();
      //c.add(TextContent("title", "Generated Document"));

      // Prepare dynamic content for messages
      //List<Content> bodyContents = [];
      *//*for (final message in messages) {
        final content = message['content'];
        c.add(TextContent("body", content));
        //bodyContents.add(TextContent("body_item", content)); // Match `${body_item}`
      }*//*
      c.add(TextContent("body", "Simple docname"));
      //c.add(TextContent("body", bodyContents)); // Match `${body}` in the template
      //c.add(TextContent("main", 'okay tis is working'));

      // Generate the document
      final d = await docx.generate(c);

      if (d != null) {
        // Save the generated file
        final outputDir = await getTemporaryDirectory();
        final filePath = "${outputDir.path}/generated_document.docx";
        final file = File(filePath);

        await file.writeAsBytes(d);

        // Open the file
        OpenFile.open(filePath);
      } else {
        print("Failed to generate the document");
      }
    } catch (e) {
      print("Error: $e");
    }
  }*/



  Future<String?> _promptAndSavePDF() async {
    String? fileName = await _getFileName(context);
    if (fileName == null || fileName.trim().isEmpty) {
      return null;
    }

    // Ensure the file name ends with .pdf
    if (!fileName.endsWith(".pdf")) {
      fileName += ".pdf";
    }

    try {
      // Get the full save path using the helper function
      final filePath = await getSavePath(fileName);
      return await _generateAndSavePDF(filePath);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to determine save path: $e")),
      );
      print('error : $e');
      return null;
    }
  }

  Future<String> getSavePath(String fileName) async {
    // Get the appropriate directory based on the platform
    Directory? directory;

    if (Platform.isAndroid) {
      // Use external storage directory for Android
      directory = await getExternalStorageDirectory();
    } else if (Platform.isIOS) {
      // Use the Documents directory for iOS
      directory = await getApplicationDocumentsDirectory();
    } else {
      throw Exception("Unsupported platform");
    }

    if (directory == null) {
      throw Exception("Unable to access storage directory.");
    }

    // Combine the directory path with the file name
    final path = "${directory.path}/$fileName";
    return path;
  }

  Future<String?> _getFileName(BuildContext context) async {
    TextEditingController fileNameController = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Set PDF Name"),
          content: TextField(
            controller: fileNameController,
            decoration: InputDecoration(hintText: "Enter file name"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(null);
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(fileNameController.text);
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  Future<void> requestPermissions() async {
    if (Platform.isAndroid) {
      // Check and request storage permission for Android
      if (!await Permission.storage.isGranted) {
        await Permission.storage.request();
      }

      if (await Permission.storage.isDenied) {
        // Show a message to the user
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Storage permission is required to save PDFs."),
          ),
        );
        return;
      }

      if (await Permission.storage.isPermanentlyDenied) {
        // Open app settings if permission is permanently denied
        await openAppSettings();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please enable storage permission in settings."),
          ),
        );
        return;
      }
    } else if (Platform.isIOS) {
      // iOS typically doesn’t require storage permissions for app sandbox
      // If using Documents directory, no runtime permission is needed
      // Optionally, add a check for future-proofing (e.g., Photos access)
      // For now, we assume Documents directory usage, so no action is needed
      bool canWrite = await _checkWriteCapability();
      if (!canWrite) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Unable to write to storage. Check app permissions."),
          ),
        );
        await openAppSettings();
        return;
      }
    }
  }

  // Optional helper to verify write capability (for iOS or edge cases)
  Future<bool> _checkWriteCapability() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final testFile = File("${directory.path}/test.txt");
      await testFile.writeAsString("test");
      await testFile.delete(); // Clean up
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<String?> _generateAndSavePDF(String filePath) async {
    requestPermissions();
    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: List.generate(messages.length, (index) {
                final isSentByUser = messages[index]['sender'] == 'User';
                final sender = isSentByUser ? "user:" : "bot:";

                pw.Alignment alignment;
                switch (textEditorController.textAlignments[index]) {
                  case TextAlign.center:
                    alignment = pw.Alignment.center;
                    break;
                  case TextAlign.right:
                    alignment = pw.Alignment.centerRight;
                    break;
                  case TextAlign.left:
                  default:
                    alignment = pw.Alignment.centerLeft;
                    break;
                }

                return pw.Container(
                  alignment: alignment,
                  padding: const pw.EdgeInsets.only(bottom: 8),
                  child: pw.Text(
                    "$sender ${messages[index]['content']}",
                    style: pw.TextStyle(
                      fontSize: textEditorController.textStyles[index].fontSize ?? 14,
                      color: isSentByUser ? PdfColors.black : PdfColors.purple,
                    ),
                  ),
                );
              }),
            );
          },
        ),
      );

      final file = File(filePath);
      await file.writeAsBytes(await pdf.save());

      return filePath;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to save PDF: $e")),
      );
      print('Error: $e');
      return null;
    }
  }

  void _showPDF(String filePath) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PDFViewerScreen(filePath: filePath),
      ),
    );
  }


  Future<void> generateAndShowDocx() async {
    try {
      // Prepare the content for the .docx (using messages from the chat)
      final bodyContent = messages.map((message) {
        final sender = message['sender'] == 'User' ? 'User:' : 'Bot:';
        return '$sender ${message['content']}';
      }).join('\n');

      const apiUrl = 'https://backend.gameplanai.co.uk/chat_app/generate_docx_response/';
      final body = jsonEncode({
        "text": bodyContent, // Send the concatenated chat content
      });

      print('Request URL: $apiUrl');
      print('Request Body: $body');
      print('Request Headers: {Content-Type: application/json}');

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );

      print('Response Status: ${response.statusCode}');
      print('Response Headers: ${response.headers}');
      print('Response Content-Type: ${response.headers['content-type']}');
      print('Response Body Length: ${response.bodyBytes.length} bytes');

      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;

        // Save the file locally
        final directory = await getTemporaryDirectory();
        final filePath = '${directory.path}/downloaded_chat.docx';
        final file = File(filePath);
        await file.writeAsBytes(bytes);

        print('File saved at: $filePath');

        // Open the file
        final result = await OpenFile.open(filePath);
        if (result.type != ResultType.done) {
          throw Exception('Error opening file: ${result.message}');
        }
        print('File opened successfully with result: ${result.message}');
      } else {
        throw Exception('Failed to load file: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error generating .docx: $e')),
      );
      print('Error: $e');
    }
  }


}
