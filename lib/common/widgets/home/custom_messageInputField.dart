import 'package:agcourt/common/customFont.dart';
import 'package:flutter/material.dart';

class CustomMessageInputField extends StatefulWidget {
  final TextEditingController textController;
  final VoidCallback onSend;
  final String hintText;
  final double padding;
  final Color color;
  final FocusNode? focusNode;

  const CustomMessageInputField({
    super.key,
    required this.textController,
    required this.onSend,
    this.color = Colors.black,
    this.padding = 10.0,
    this.hintText = 'Type your text...',
    this.focusNode,
  });

  @override
  _CustomMessageInputFieldState createState() => _CustomMessageInputFieldState();
}

class _CustomMessageInputFieldState extends State<CustomMessageInputField> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(() {
      print('Focus changed: ${_focusNode.hasFocus}');
    });
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(widget.padding),
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
                      controller: widget.textController,
                      focusNode: _focusNode,
                      style: h4.copyWith(color: widget.color),
                      decoration: InputDecoration(
                        hintText: widget.hintText,
                        hintStyle: h4.copyWith(color: Color(0xFF5D5D5D)),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                      autofocus: false,
                      onTap: () {
                        _focusNode.requestFocus(); // Ensure focus on tap
                        print('TextField tapped, keyboard requested');
                      },
                      onSubmitted: (value) => widget.onSend(),
                    ),
                  ),
                  IconButton(
                    onPressed: widget.onSend,
                    icon: Icon(Icons.send, color: widget.color),
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