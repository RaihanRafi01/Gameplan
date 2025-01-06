import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter_pdfview/flutter_pdfview.dart';

class ExportScreen extends StatefulWidget {
  final List<Map<String, dynamic>> messages;

  ExportScreen({required this.messages});

  @override
  _ExportScreenState createState() => _ExportScreenState();
}

class _ExportScreenState extends State<ExportScreen> {
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Plan"),
        actions: [
          IconButton(
            icon: Icon(Icons.file_upload_outlined),
            onPressed: () async {
              final filePath = await _promptAndSavePDF();
              if (filePath != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("PDF saved to: $filePath")),
                );
                _showPDF(filePath);
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.copy),
            onPressed: () {
              _copyAllMessages(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
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
                      textStyles[_currentEditingIndex].copyWith(fontSize: _fontSize);
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
                textStyles[_currentEditingIndex].fontStyle == FontStyle.italic
                ? Colors.blue
                : Colors.black,
            onPressed: () {
              if (_currentEditingIndex != -1) {
                setState(() {
                  textStyles[_currentEditingIndex] =
                      textStyles[_currentEditingIndex].copyWith(
                          fontStyle: textStyles[_currentEditingIndex].fontStyle ==
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
    String? outputDir = await FilePicker.platform.getDirectoryPath();
    if (outputDir == null) {
      return null;
    }

    String? fileName = await _getFileName(context);
    if (fileName == null || fileName.trim().isEmpty) {
      return null;
    }

    if (!fileName.endsWith(".pdf")) {
      fileName += ".pdf";
    }

    final path = "$outputDir/$fileName";
    return await _generateAndSavePDF(path);
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

  Future<String?> _generateAndSavePDF(String filePath) async {
    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: List.generate(widget.messages.length, (index) {
                final isSentByUser = widget.messages[index]['isSentByUser'];
                return pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 8),
                  child: pw.Text(
                    widget.messages[index]['message'],
                    style: pw.TextStyle(
                      fontSize: textStyles[index].fontSize ?? 14,
                      color: isSentByUser ? PdfColors.black : PdfColors.purple,
                    ),
                    textAlign: _convertTextAlignToPdfTextAlign(
                        textAlignments[index]),
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
}
class PDFViewerScreen extends StatelessWidget {
  final String filePath;

  PDFViewerScreen({required this.filePath});

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
