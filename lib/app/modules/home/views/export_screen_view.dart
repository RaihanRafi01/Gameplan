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

import '../../dashboard/controllers/dashboard_controller.dart';
import '../controllers/chat_edit_controller.dart';

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

  late List<TextEditingController> controllers;
  late List<TextStyle> textStyles;
  late List<TextAlign> textAlignments;
  double _fontSize = 16.0;
  int _currentEditingIndex = -1;

  @override
  void initState() {
    super.initState();

    // Initialize controllers for each message
    controllers = widget.messages
        .map((message) => TextEditingController(text: message['message']))
        .toList();

    // Initialize text styles and alignments for each message
    textStyles = List<TextStyle>.generate(
        widget.messages.length, (index) => TextStyle(fontSize: 16.0));
    textAlignments = List<TextAlign>.generate(
        widget.messages.length, (index) => TextAlign.left);
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
    //dashboardController.currentIndex.value = 1;
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
                  GestureDetector(
                    onTap: () {
                      editController.disableEditing();
                    },
                    child: SvgPicture.asset(
                        'assets/images/history/edit_icon.svg'),
                  ),
                  SizedBox(width: 16),
                  GestureDetector(
                    onTap: () {
                      // Pin functionality
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
                      editController.disableEditing();
                    }
                  },
                  child: SvgPicture.asset(
                      'assets/images/history/export_icon.svg'),
                ),
                SizedBox(width: 16),
                GestureDetector(
                  onTap: () {
                    final htmlContent = _generateHTMLContent();
                    historyEditController.addEditChat(widget.chatId, htmlContent);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Saved successfully!")),
                    );
                    editController.disableEditing(); // Disable editing after saving
                  },
                  child: SvgPicture.asset(
                      'assets/images/history/save_icon.svg'),
                ),
              ],
            )),
            SizedBox(height: 10),
            _buildToolbar(),
            Expanded(
              child: ListView.builder(
                itemCount: widget.messages.length,
                itemBuilder: (context, index) {
                  final isSentByUser = widget.messages[index]['isSentByUser'];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Focus(
                      onFocusChange: (hasFocus) {
                        if (hasFocus) {
                          setState(() {
                            _currentEditingIndex = index;
                          });
                        }
                      },
                      child: TextField(
                        controller: controllers[index],
                        maxLines: null,
                        onChanged: (value) {
                          widget.messages[index]['message'] = value;
                        },
                        style: textStyles[index].copyWith(
                          color: isSentByUser ? Colors.black : Colors.purple,
                        ),
                        textAlign: textAlignments[index],
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: isSentByUser
                              ? "Type your message here..."
                              : "Type bot response here...",
                        ),
                      ),
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
          DropdownButton<double>(
            value: _fontSize,
            items: [12.0, 14.0, 16.0, 18.0, 20.0, 22.0, 24.0]
                .map((size) => DropdownMenuItem(
                      value: size,
                      child: Text(size.toString()),
                    ))
                .toList(),
            onChanged: (value) {
              if (_currentEditingIndex != -1) {
                setState(() {
                  _fontSize = value!;
                  textStyles[_currentEditingIndex] =
                      textStyles[_currentEditingIndex]
                          .copyWith(fontSize: _fontSize);
                });
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.format_bold),
            color: _currentEditingIndex != -1 &&
                    textStyles[_currentEditingIndex].fontWeight ==
                        FontWeight.bold
                ? Colors.blue
                : Colors.black,
            onPressed: () {
              if (_currentEditingIndex != -1) {
                setState(() {
                  textStyles[_currentEditingIndex] =
                      textStyles[_currentEditingIndex].copyWith(
                          fontWeight:
                              textStyles[_currentEditingIndex].fontWeight ==
                                      FontWeight.bold
                                  ? FontWeight.normal
                                  : FontWeight.bold);
                });
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.format_italic),
            color: _currentEditingIndex != -1 &&
                    textStyles[_currentEditingIndex].fontStyle ==
                        FontStyle.italic
                ? Colors.blue
                : Colors.black,
            onPressed: () {
              if (_currentEditingIndex != -1) {
                setState(() {
                  textStyles[_currentEditingIndex] =
                      textStyles[_currentEditingIndex].copyWith(
                          fontStyle:
                              textStyles[_currentEditingIndex].fontStyle ==
                                      FontStyle.italic
                                  ? FontStyle.normal
                                  : FontStyle.italic);
                });
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.format_underline),
            color: _currentEditingIndex != -1 &&
                    textStyles[_currentEditingIndex].decoration ==
                        TextDecoration.underline
                ? Colors.blue
                : Colors.black,
            onPressed: () {
              if (_currentEditingIndex != -1) {
                setState(() {
                  textStyles[_currentEditingIndex] =
                      textStyles[_currentEditingIndex].copyWith(
                          decoration:
                              textStyles[_currentEditingIndex].decoration ==
                                      TextDecoration.underline
                                  ? TextDecoration.none
                                  : TextDecoration.underline);
                });
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.format_align_left),
            color: _currentEditingIndex != -1 &&
                    textAlignments[_currentEditingIndex] == TextAlign.left
                ? Colors.blue
                : Colors.black,
            onPressed: () {
              if (_currentEditingIndex != -1) {
                setState(() {
                  textAlignments[_currentEditingIndex] = TextAlign.left;
                });
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.format_align_center),
            color: _currentEditingIndex != -1 &&
                    textAlignments[_currentEditingIndex] == TextAlign.center
                ? Colors.blue
                : Colors.black,
            onPressed: () {
              if (_currentEditingIndex != -1) {
                setState(() {
                  textAlignments[_currentEditingIndex] = TextAlign.center;
                });
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.format_align_right),
            color: _currentEditingIndex != -1 &&
                    textAlignments[_currentEditingIndex] == TextAlign.right
                ? Colors.blue
                : Colors.black,
            onPressed: () {
              if (_currentEditingIndex != -1) {
                setState(() {
                  textAlignments[_currentEditingIndex] = TextAlign.right;
                });
              }
            },
          ),
        ],
      ),
    );
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
          SnackBar(content: Text("Storage permission is required to save PDFs.")),
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

                pw.Alignment alignment;
                switch (textAlignments[index]) {
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
                    widget.messages[index]['message'],
                    style: pw.TextStyle(
                      fontSize: textStyles[index].fontSize ?? 14,
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


  pw.TextAlign _convertTextAlignToPdfTextAlign(TextAlign textAlign) {
    switch (textAlign) {
      case TextAlign.center:
        return pw.TextAlign.center;
      case TextAlign.right:
        return pw.TextAlign.right;
      case TextAlign.left:
      default:
        return pw.TextAlign.left;
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

  void _copyAllMessages(BuildContext context) {
    final allMessages =
        widget.messages.map((message) => message['message']).join("\n");
    Clipboard.setData(ClipboardData(text: allMessages));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("All messages copied to clipboard!")),
    );
  }

  String _generateHTMLContent() {
    final htmlContent = StringBuffer();
    // htmlContent.write('<html><body>');

    for (int index = 0; index < widget.messages.length; index++) {
      final isSentByUser = widget.messages[index]['isSentByUser'];

      // Determine text alignment
      String alignment;
      switch (textAlignments[index]) {
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
        font-size: ${textStyles[index].fontSize}px;
        font-weight: ${textStyles[index].fontWeight == FontWeight.bold ? 'bold' : 'normal'};
        font-style: ${textStyles[index].fontStyle == FontStyle.italic ? 'italic' : 'normal'};
        text-decoration: ${textStyles[index].decoration == TextDecoration.underline ? 'underline' : 'none'};
        color: ${isSentByUser ? 'black' : 'purple'};
        text-align: $alignment;
      ''';

      htmlContent.write(
        '<div style="$style">${widget.messages[index]['message']}</div>',
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
