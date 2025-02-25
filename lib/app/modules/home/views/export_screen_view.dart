import 'dart:io';
import 'package:agcourt/app/modules/dashboard/views/widgets/customNavigationBar.dart';
import 'package:agcourt/app/modules/history/controllers/edit_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';
import '../../../../common/widgets/history/folderSelectionDialog.dart';
import '../../dashboard/controllers/dashboard_controller.dart';
import '../../dashboard/controllers/theme_controller.dart'; // Add this import
import '../../history/controllers/history_controller.dart';
import '../../save_class/controllers/save_class_controller.dart';
import '../controllers/chat_edit_controller.dart';
import '../controllers/textEditorController.dart';

class ExportScreen extends StatefulWidget {
  final List<Map<String, dynamic>> messages;
  final int chatId;

  const ExportScreen({super.key, required this.messages, required this.chatId});

  @override
  _ExportScreenState createState() => _ExportScreenState();
}

class _ExportScreenState extends State<ExportScreen> {
  final ChatEditController editController = Get.put(ChatEditController());
  final EditController historyEditController = Get.put(EditController());
  final DashboardController dashboardController = Get.put(DashboardController());
  final TextEditorController textEditorController = Get.put(TextEditorController());
  final EditController edC = Get.put(EditController());
  final SaveClassController saveClassController =
  Get.put(SaveClassController());
  late List<TextEditingController> controllers;
  final HistoryController historyController = Get.put(HistoryController());

  @override
  void initState() {
    super.initState();
    controllers = widget.messages
        .map((message) => TextEditingController(text: message['message']))
        .toList();
    textEditorController.initializeStyles(widget.messages.length);
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        backgroundColor: themeController.isDarkTheme.value ? const Color(0xFF374151) : Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context); // Default back action
          },
          child: Obx(() => Icon(
            Icons.arrow_back,
            color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
          )),
        ),
        centerTitle: true,
        title: const Text(
          "Edit Plan",
          style: TextStyle(fontSize: 18),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Obx(() => Icon(
              Icons.menu,
              color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
            )),
            color: themeController.isDarkTheme.value ? Colors.grey[900] : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            offset: const Offset(0, 50),
            onSelected: (value) async {
              switch (value) {
                case 'save_to_class':
                  int editId = edC.editId.value;

                  if (saveClassController.isSaveMode.value) {
                    await saveClassController.unSaveEditedChat(
                        editId, saveClassController.tempFolderId.value);
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => FolderSelectionDialog(
                        editId: editId,
                      ),
                    );

                  }
                  break;
                case 'delete':
                  int editId = edC.editId.value;
                  _showDeleteDialog(context, editId, true);
                  break;
                case 'export':
                  _promptAndSavePDF().then((filePath) {
                    if (filePath != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("PDF saved to: $filePath")),
                      );
                      _showPDF(filePath);
                    }
                  });
                  break;
                case 'save':
                  editController.enableEditing();
                  final htmlContent = _generateHTMLContent();
                  historyEditController.addEditChat(widget.chatId, htmlContent);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Saved successfully!")),
                  );
                  break;
                case 'pin':
                  int editId = edC.editId.value;
                  if (saveClassController.isPinMode.value) {
                    await historyController.unpinEditChat(editId);
                    saveClassController.isPinMode.value = false;
                  } else {
                    _showDatePicker(context, editId);
                    saveClassController.isPinMode.value = true;
                  }
                  break;
              }
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'export',
                  child: SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        Obx(() => SvgPicture.asset(
                          'assets/images/history/export_icon.svg',
                          width: 24,
                          height: 24,
                          color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
                        )),
                        const SizedBox(width: 8),
                        Obx(() => Text(
                          'Export',
                          style: TextStyle(
                            color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
                          ),
                        )),
                      ],
                    ),
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'save',
                  child: SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        Obx(() => SvgPicture.asset(
                          'assets/images/history/save_icon.svg',
                          width: 24,
                          height: 24,
                          color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
                        )),
                        const SizedBox(width: 8),
                        Obx(() => Text(
                          'Save',
                          style: TextStyle(
                            color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
                          ),
                        )),
                      ],
                    ),
                  ),
                ),
                if (editController.isEditing.value) ...[
                  PopupMenuItem<String>(
                    value: 'pin',
                    child: SizedBox(
                      width: 120,
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
                            saveClassController.isPinMode.value ? "UnPin" : "Pin",
                            style: TextStyle(
                              color: themeController.isDarkTheme.value
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          )),
                        ],
                      ),
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'save_to_class',
                    child: SizedBox(
                      width: 140,
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
                  ),
                  PopupMenuItem<String>(
                    value: 'delete',
                    child: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          Obx(() => SvgPicture.asset(
                            'assets/images/history/delete_icon.svg',
                            width: 24,
                            height: 24,
                            color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
                          )),
                          const SizedBox(width: 8),
                          Obx(() => Text(
                            'Delete',
                            style: TextStyle(
                              color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
                            ),
                          )),
                        ],
                      ),
                    ),
                  ),
                ],
              ];
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Obx(() {
              if (!editController.isEditing.value) {
                return _buildToolbar();
              } else {
                return const SizedBox(height: 0);
              }
            }),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: widget.messages.length,
                itemBuilder: (context, index) {
                  final isSentByUser = widget.messages[index]['isSentByUser'];
                  final sender = isSentByUser ? "user:" : "bot:";

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(width: 8),
                        Expanded(
                          child: Focus(
                            onFocusChange: (hasFocus) {
                              if (hasFocus) {
                                textEditorController.currentEditingIndex.value = index;
                              }
                            },
                            child: Obx(() => TextField(
                              controller: TextEditingController(
                                  text: widget.messages[index]['message']),
                              maxLines: null,
                              textAlign: textEditorController.textAlignments[index],
                              style: textEditorController.textStyles[index].merge(
                                TextStyle(
                                  fontWeight: isSentByUser
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: isSentByUser
                                    ? "Type your message here..."
                                    : "Type bot response here...",
                              ),
                              onChanged: (value) {
                                editController.disableEditing();
                                widget.messages[index]['message'] = value;
                              },
                            )),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Rest of the methods remain unchanged; included for completeness

  Widget _buildToolbar() {
    final ThemeController themeController = Get.find<ThemeController>();
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Obx(() => DropdownButton<double>(
            dropdownColor: themeController.isDarkTheme.value ? Colors.grey[900] : Colors.white,
            value: textEditorController.fontSize.value,
            items: [12.0, 14.0, 16.0, 18.0, 20.0, 22.0, 24.0]
                .map((size) => DropdownMenuItem(
              value: size,

              child: Text(size.toString(),style: TextStyle(color: themeController.isDarkTheme.value ? Colors.white : Colors.black),),
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
            textEditorController.textStyles[index].fontWeight == FontWeight.bold,
            onPressed: (index) {
              final isBold =
                  textEditorController.textStyles[index].fontWeight == FontWeight.bold;
              textEditorController.updateTextStyle(
                index: index,
                fontWeight: isBold ? FontWeight.normal : FontWeight.bold,
              );
            },
          ),
          _buildIconButton(
            icon: Icons.format_italic,
            isActive: (index) =>
            textEditorController.textStyles[index].fontStyle == FontStyle.italic,
            onPressed: (index) {
              final isItalic =
                  textEditorController.textStyles[index].fontStyle == FontStyle.italic;
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
    required bool Function(int index) isActive,
    required void Function(int index) onPressed,
  }) {
    return Obx(() {
      final ThemeController themeController = Get.find<ThemeController>();
      final index = textEditorController.currentEditingIndex.value;
      final active = index != -1 && isActive(index);

      return IconButton(
        icon: Icon(icon),
        color: active ? Colors.blue : themeController.isDarkTheme.value ? Colors.white : Colors.black,
        onPressed: index != -1 ? () => onPressed(index) : null,
      );
    });
  }

  Future<String?> _promptAndSavePDF() async {
    String? fileName = await _getFileName(context);
    if (fileName == null || fileName.trim().isEmpty) {
      return null;
    }

    if (!fileName.endsWith(".pdf")) {
      fileName += ".pdf";
    }

    try {
      final filePath = await getSavePath(fileName);
      return await _generateAndSavePDF(filePath);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to determine save path: $e")),
      );
      return null;
    }
  }

  Future<String> getSavePath(String fileName) async {
    final directory = await getExternalStorageDirectory();
    if (directory == null) {
      throw Exception("Unable to access external storage directory.");
    }
    final path = "${directory.path}/$fileName";
    return path;
  }

  Future<String?> _getFileName(BuildContext context) async {
    TextEditingController fileNameController = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Set PDF Name"),
          content: TextField(
            controller: fileNameController,
            decoration: const InputDecoration(hintText: "Enter file name"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(fileNameController.text),
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  Future<void> requestPermissions() async {
    if (Platform.isAndroid) {
      if (!await Permission.storage.isGranted) {
        await Permission.storage.request();
      }
      if (await Permission.storage.isDenied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Storage permission is required to save PDFs.")),
        );
      }
      if (await Permission.storage.isPermanentlyDenied) {
        openAppSettings();
      }
    }
  }

  Future<String?> _generateAndSavePDF(String filePath) async {
    await requestPermissions();
    try {
      final pdf = pw.Document();
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: List.generate(widget.messages.length, (index) {
                final isSentByUser = widget.messages[index]['isSentByUser'];
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
                    "$sender ${widget.messages[index]['message']}",
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

  String _generateHTMLContent() {
    final htmlContent = StringBuffer();
    for (int index = 0; index < widget.messages.length; index++) {
      final isSentByUser = widget.messages[index]['isSentByUser'];
      final sender = isSentByUser ? "User:" : "Bot:";

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

      final style = '''
        font-size: ${textEditorController.textStyles[index].fontSize}px;
        font-weight: ${textEditorController.textStyles[index].fontWeight == FontWeight.bold ? 'bold' : 'normal'};
        font-style: ${textEditorController.textStyles[index].fontStyle == FontStyle.italic ? 'italic' : 'normal'};
        text-decoration: ${textEditorController.textStyles[index].decoration == TextDecoration.underline ? 'underline' : 'none'};
        color: ${isSentByUser ? 'black' : 'purple'};
        text-align: $alignment;
      ''';

      htmlContent.write(
        '<p style="$style"><strong>$sender</strong> ${widget.messages[index]['message']}</p>',
      );
    }
    return htmlContent.toString();
  }

  void _showHTMLDialog(String htmlContent) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Generated HTML"),
          content: SingleChildScrollView(
            child: Html(data: htmlContent),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, int chatId, bool isEdit) {
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
                if (isEdit) {
                  editHistoryController.deleteChat(chatId);
                }
                if (!isEdit) {
                  historyEditController.deleteChat(chatId);
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
}

class PDFViewerScreen extends StatelessWidget {
  final String filePath;

  const PDFViewerScreen({super.key, required this.filePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PDF Viewer"),
      ),
      body: PDFView(
        filePath: filePath,
      ),
    );
  }
}