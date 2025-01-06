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

  @override
  void initState() {
    super.initState();

    // Initialize controllers for each message
    controllers = widget.messages
        .map((message) => TextEditingController(text: message['message']))
        .toList();
  }

  @override
  void dispose() {
    // Dispose all controllers
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
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey, // Outline border color
              width: 1.5, // Border width
            ),
            borderRadius: BorderRadius.circular(12), // Rounded corners
          ),
          child: ListView.builder(
            itemCount: widget.messages.length,
            itemBuilder: (context, index) {
              final isSentByUser = widget.messages[index]['isSentByUser'];

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: TextField(
                  controller: controllers[index],
                  maxLines: null,
                  onChanged: (value) {
                    // Update the messages dynamically
                    widget.messages[index]['message'] = value;
                  },
                  style: TextStyle(
                    color: isSentByUser ? Colors.black : Colors.purple,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: isSentByUser
                        ? "Type your message here..."
                        : "Type bot response here...",
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _copyAllMessages(BuildContext context) {
    // Copy the entire text from the messages
    final allMessages =
    widget.messages.map((message) => message['message']).join("\n");
    Clipboard.setData(ClipboardData(text: allMessages));

    // Show confirmation message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("All messages copied to clipboard!")),
    );
  }

  Future<String?> _promptAndSavePDF() async {
    // Ask the user to select a directory and set the file name
    String? outputDir = await FilePicker.platform.getDirectoryPath();
    if (outputDir == null) {
      // User canceled the picker
      return null;
    }

    String? fileName = await _getFileName(context);
    if (fileName == null || fileName.trim().isEmpty) {
      // User canceled or entered an empty name
      return null;
    }

    // Add .pdf extension if not provided
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
                Navigator.of(context).pop(null); // Cancel
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(fileNameController.text); // Confirm
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
              children: widget.messages.map((message) {
                return pw.Text(
                  message['message'],
                  style: pw.TextStyle(
                    fontSize: 14,
                    color: message['isSentByUser'] ? PdfColors.black : PdfColors.purple,
                  ),
                );
              }).toList(),
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

  void _showPDF(String filePath) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PDFViewerScreen(filePath: filePath),
      ),
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
