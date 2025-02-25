import 'package:agcourt/common/customFont.dart';
import 'package:flutter/material.dart';

class CustomMessageInputField extends StatelessWidget {
  final TextEditingController textController;
  final VoidCallback onSend;
  final String hintText;
  final double padding;
  final Color color;

  const CustomMessageInputField({
    super.key,
    required this.textController,
    required this.onSend,
    this.color = Colors.black,
    this.padding = 10.0,
    this.hintText = 'Type your text...',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFFF4F4F4),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: textController,
                      style: h4.copyWith(color: color),
                      decoration: InputDecoration(
                        hintText: hintText,
                        hintStyle: h4.copyWith(color: Color(0xFF5D5D5D)),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                      autofocus: false, // Ensure no auto-focus
                      onSubmitted: (value) => onSend(), // Send on Enter key press
                    ),
                  ),
                  IconButton(
                    onPressed: onSend,
                    icon: Icon(Icons.send, color: color),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}