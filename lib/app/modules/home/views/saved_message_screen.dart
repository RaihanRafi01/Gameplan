import 'package:flutter/material.dart';
import '../../../../common/widgets/home/saved_text_model.dart'; // Import the SavedMessage model
import 'saved_message_viewer.dart'; // Import the SavedMessageViewer screen

class SavedMessagesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Saved Collections"),
      ),
      body: savedCollections.isEmpty
          ? Center(
        child: Text(
          "No collections available.",
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      )
          : ListView.builder(
        itemCount: savedCollections.keys.length,
        itemBuilder: (context, index) {
          final collectionName = savedCollections.keys.elementAt(index);
          final messages = savedCollections[collectionName]!;

          return Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 8.0, horizontal: 16.0),
            child: Card(
              elevation: 4,
              child: ListTile(
                title: Text(
                  collectionName,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  "${messages.length} message(s)",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SavedMessageViewer(
                        collectionName: collectionName,
                        messages: messages,
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
