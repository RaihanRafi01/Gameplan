import 'package:agcourt/common/customFont.dart';
import 'package:flutter/material.dart';

class CustomMessageInputField extends StatelessWidget {
  final TextEditingController textController;
  final VoidCallback onSend;
  final String hintText;

  const CustomMessageInputField({
    super.key,
    required this.textController,
    required this.onSend,
    this.hintText = 'type your text',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: textController,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: h4,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.black),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: onSend,
                        child: const Icon(Icons.send, size: 24),
                      ),
                      /*const SizedBox(width: 6),
                      GestureDetector(
                        onTap: () {
                          // Action for second button (if needed)
                        },
                        child: const Icon(Icons.add, size: 24),
                      ),*/
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
