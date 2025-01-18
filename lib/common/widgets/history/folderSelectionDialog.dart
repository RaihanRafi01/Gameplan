import 'package:agcourt/app/modules/home/controllers/chat_edit_controller.dart';
import 'package:agcourt/common/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/modules/history/controllers/edit_controller.dart';
import '../../../app/modules/save_class/controllers/save_class_controller.dart';

class FolderSelectionDialog extends StatelessWidget {
  final TextEditingController folderNameController = TextEditingController();
  final SaveClassController controller = Get.put(SaveClassController());
  final EditController editController = Get.put(EditController());

  final int editId;

  FolderSelectionDialog({super.key,required this.editId});

  @override
  Widget build(BuildContext context) {
    // Fetch the class list when the dialog is opened
    controller.fetchClassList();

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        width: MediaQuery.of(context).size.width * 0.8,
        child: Obx(() {
          if (controller.classList.isEmpty) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Create Folder',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                // Create Folder Button
                CustomButton(text: 'Create Folder', onPressed: ()async {
                  final folderName = folderNameController.text.trim();
                  if (folderName.isNotEmpty) {
                    await controller.addClass(folderName);
                    folderNameController.clear(); // Clear the input field
                  } else {
                    Get.snackbar('Error', 'Folder name cannot be empty');
                  }
                }),
                const SizedBox(height: 16.0),
              ],
            );
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title
              Text(
                'Select or Create Folder',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16.0),

              // Text Field for Folder Name
              TextField(
                controller: folderNameController,
                decoration: InputDecoration(
                  labelText: 'Enter folder name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 8.0),

              // Create Folder Button
              CustomButton(text: 'Create Folder', onPressed: ()async {
                final folderName = folderNameController.text.trim();
                if (folderName.isNotEmpty) {
                  await controller.addClass(folderName);
                  folderNameController.clear(); // Clear the input field
                } else {
                  Get.snackbar('Error', 'Folder name cannot be empty');
                }
              }),
              const SizedBox(height: 16.0),

              // Available Folders List
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Available Folders:',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8.0),

              // ListView of Folders
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: controller.classList.length,
                  itemBuilder: (context, index) {
                    final folder = controller.classList[index];
                    return ListTile(
                      leading: Icon(Icons.folder, color: Colors.amber),
                      title: Text(folder['folder_name'] ?? 'Unnamed Folder'),
                      onTap: () async {
                        int folderId = folder['id'];
                        //var editId = editId;
                        //controller.selectClass(folder['folder_name']);
                        print('Selected Folder ID: ${folder['id']}, Name: ${folder['folder_name']} Edit id : $editId');
                        controller.pinToClass(editId,folderId);
                        Get.back(); // Close the dialog
                      },
                    );
                  },
                ),
              ),

              // Close Button
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text(
                    'Close',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
