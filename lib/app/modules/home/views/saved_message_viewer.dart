/*
import 'package:flutter/material.dart';
import '../../../../common/widgets/home/saved_text_model.dart';

class SavedMessageViewer extends StatelessWidget {
  final String collectionName;
  final List<SavedMessage> messages;

  SavedMessageViewer({required this.collectionName, required this.messages});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Collection: $collectionName"),
      ),
      body: messages.isEmpty
          ? Center(
        child: Text(
          "No messages in this collection.",
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final message = messages[index];
          return ListTile(
            title: Text(
              message.text,
              style: TextStyle(
                fontSize: message.fontSize,
                fontWeight: message.fontWeight,
                fontStyle: message.fontStyle,
                decoration: message.textDecoration,
              ),
              textAlign: message.textAlign,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Icon(Icons.arrow_back),
        tooltip: "Back to Collections",
      ),
    );
  }
}
*/
