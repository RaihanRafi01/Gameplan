import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/customAppBar.dart';
import '../../../../common/widgets/custom_button.dart';
import '../controllers/save_class_controller.dart';

class SaveClassView extends StatelessWidget {
  final SaveClassController controller = Get.put(SaveClassController());

  SaveClassView({super.key}) {
    // Fetch class list when the view is initialized
    controller.fetchClassList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Save Classes',
      ),
      body: Obx(() {
        // If a class is selected, show its contents
        if (controller.selectedClass.value.isNotEmpty) {
          return _buildSelectedClassView();
        }

        // Default view with list of classes
        if (controller.classList.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Center(
              child: CustomButton(
                height: 60,
                textSize: 24,
                text: 'Create a Class',
                onPressed: () {
                  _showAddClassDialog(context);
                },
              ),
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: CustomButton(
                    width: 180,
                    height: 32,
                    textSize: 16,
                    text: 'Create New Class',
                    onPressed: () {
                      _showAddClassDialog(context);
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: controller.classList.length,
                    itemBuilder: (context, index) {
                      final classData = controller.classList[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: CustomButton(
                          text: classData['folder_name'] ?? 'Unnamed Class',
                          onPressed: () {
                            controller.selectClass(classData['folder_name']);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }
      }),
    );
  }

  Widget _buildSelectedClassView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  controller.clearSelection(); // Clear selection and go back
                },
              ),
              Text(
                controller.selectedClass.value,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: Obx(() {
            if (controller.selectedClassContents.isEmpty) {
              return const Center(
                child: Text(
                  'No contents available for this class.',
                  style: TextStyle(fontSize: 16),
                ),
              );
            }

            return ListView.builder(
              itemCount: controller.selectedClassContents.length,
              itemBuilder: (context, index) {
                final content = controller.selectedClassContents[index];
                return ListTile(
                  title: Text(
                    content['content'] ?? 'Unnamed Content',
                    style: const TextStyle(fontSize: 18),
                  ),
                  subtitle: Text(
                    'Timestamp: ${content['timestamp'] ?? 'N/A'}',
                    style: const TextStyle(fontSize: 14),
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }

  void _showAddClassDialog(BuildContext context) {
    TextEditingController classNameController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Class Name'),
          content: TextField(
            controller: classNameController,
            decoration: const InputDecoration(hintText: 'Class Name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final className = classNameController.text.trim();
                if (className.isNotEmpty) {
                  controller.addClass(className);
                }
                Get.back();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
