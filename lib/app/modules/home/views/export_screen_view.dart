import 'dart:io';
import 'package:agcourt/app/modules/dashboard/views/widgets/customNavigationBar.dart';
import 'package:agcourt/app/modules/history/controllers/edit_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../common/widgets/history/folderSelectionDialog.dart';
import '../../dashboard/controllers/dashboard_controller.dart';
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

  late List<TextEditingController> controllers;
  /*late List<TextStyle> textStyles;
  late List<TextAlign> textAlignments;*/


  @override
  void initState() {
    super.initState();

    // Initialize controllers for each message
    controllers = widget.messages
        .map((message) => TextEditingController(text: message['message']))
        .toList();

    // Initialize text styles and alignments for each message
    /*textStyles = List<TextStyle>.generate(
        widget.messages.length, (index) => TextStyle(fontSize: 16.0));
    textAlignments = List<TextAlign>.generate(
        widget.messages.length, (index) => TextAlign.left);*/
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Plan"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (editController.isEditing.value) ...[
                  /*GestureDetector(
                    onTap: () {
                      editController.disableEditing();
                    },
                    child: SvgPicture.asset(
                        'assets/images/history/edit_icon.svg'),
                  ),*/
                  SizedBox(width: 16),
                  GestureDetector(
                    onTap: () async {
                      int editId = edC.editId.value;
                      showDialog(
                        context: context,
                        builder: (context) => FolderSelectionDialog(editId: editId),
                      );
                    },
                    child: SvgPicture.asset(
                        'assets/images/history/pin_icon.svg'),
                  ),
                  SizedBox(width: 16),
                  GestureDetector(
                    onTap: () {
                      // Delete functionality
                    },
                    child: SvgPicture.asset(
                        'assets/images/history/delete_icon.svg'),
                  ),
                  SizedBox(width: 16),
                ],
                GestureDetector(
                  onTap: () async {
                    final filePath = await _promptAndSavePDF();
                    if (filePath != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("PDF saved to: $filePath")),
                      );
                      _showPDF(filePath);
                      //editController.disableEditing();
                    }
                  },
                  child: SvgPicture.asset(
                      'assets/images/history/export_icon.svg'),
                ),
                SizedBox(width: 16),
                GestureDetector(
                  onTap: () {
                    editController.enableEditing();
                    final htmlContent = _generateHTMLContent();
                    historyEditController.addEditChat(widget.chatId, htmlContent);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Saved successfully!")),
                    );
                    //editController.disableEditing(); // Disable editing after saving
                  },
                  child: SvgPicture.asset(
                      'assets/images/history/save_icon.svg'),
                ),
              ],
            )),

            Obx(() {
              if(!editController.isEditing.value) {
                return _buildToolbar();
              }
              else{
                return SizedBox(height: 0);
              }
            }),
            SizedBox(height: 10),
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
                        Text(
                          sender,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                          ),
                        ),
                        SizedBox(width: 8),
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
                              style: textEditorController.textStyles[index],
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
            textEditorController.textStyles[index].fontWeight == FontWeight.bold,
            onPressed: (index) {
              final isBold = textEditorController.textStyles[index].fontWeight == FontWeight.bold;
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
              final isItalic = textEditorController.textStyles[index].fontStyle == FontStyle.italic;
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
      final index = textEditorController.currentEditingIndex.value;
      final active = index != -1 && isActive(index);

      return IconButton(
        icon: Icon(icon),
        color: active ? Colors.blue : Colors.black,
        onPressed: index != -1 ? () => onPressed(index) : null,
      );
    });
  }


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
      return null;
    }
  }

  Future<String> getSavePath(String fileName) async {
    // Get the external storage directory (unique to the app)
    final directory = await getExternalStorageDirectory();
    if (directory == null) {
      throw Exception("Unable to access external storage directory.");
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
      if (!await Permission.storage.isGranted) {
        await Permission.storage.request();
      }

      if (await Permission.storage.isDenied) {
        // Show a message to the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Storage permission is required to save PDFs.")),
        );
        return;
      }

      if (await Permission.storage.isPermanentlyDenied) {
        // Open app settings
        openAppSettings();
      }
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
    // htmlContent.write('<html><body>');

    for (int index = 0; index < widget.messages.length; index++) {
      final isSentByUser = widget.messages[index]['isSentByUser'];
      final sender = isSentByUser ? "User:" : "Bot:";

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
        color: ${isSentByUser ? 'black' : 'purple'};
        text-align: $alignment;
      ''';

      htmlContent.write(
        '<p style="$style"><strong>$sender</strong> ${widget.messages[index]['message']}</p>',
      );
    }

    // htmlContent.write('</body></html>');
    return htmlContent.toString();
  }

  void _showHTMLDialog(String htmlContent) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Generated HTML"),
          content: SingleChildScrollView(
            child: Html(data: htmlContent), // Display the HTML content
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }
}

class PDFViewerScreen extends StatelessWidget {
  final String filePath;

  PDFViewerScreen({super.key, required this.filePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PDF Viewer"),
      ),
      body: PDFView(
        filePath: filePath,
      ),
    );
  }
}
