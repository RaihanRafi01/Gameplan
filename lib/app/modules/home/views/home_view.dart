import 'package:agcourt/common/widgets/home/custom_messageInputField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/gradientCard.dart';
import '../controllers/home_controller.dart';
import 'chat_screen_view.dart'; // Import the ChatScreen

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Form'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 50),
            const Text(
              "What do you need help with today?",
              style: TextStyle(fontSize: 28),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 50), // Add some spacing at the top
            //CustomMessageInputField(),
            const SizedBox(height: 40),
            Expanded(
              child: GridView.builder(
                itemCount: 4,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 2,
                ),
                itemBuilder: (BuildContext context, int index) {
                  final gridText = "Option  dffs ::::::::::: sasf :::::::::::::::::::::::::::::::::::::::::::::::ds ds${index + 1}";
                  return GestureDetector(
                    onTap: () {
                      Get.to(() => ChatScreen(initialMessage: gridText));
                    },
                    child: GradientCard(
                      text: gridText,
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
}
