import 'package:agcourt/common/widgets/customAppBar.dart';
import 'package:agcourt/common/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/save_class_controller.dart';

class SaveClassView extends StatelessWidget {
  final SaveClassController controller = Get.put(SaveClassController());

  SaveClassView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Save Classes',
      ),
      body: Obx(() {
        // Check if a class is selected
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
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: CustomButton(
                          text: controller.classList[index],
                          onPressed: () {
                            controller.selectClass(controller.classList[index]);
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
                  controller.clearSelection(); // Navigate back to main screen
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
          child: ListView.builder(
            itemCount: 5, // Number of "Last Chat" items
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Text(
                  'Last Chat',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            },
          ),
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
                controller.addClass(classNameController.text.trim());
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

// SaveClassController

