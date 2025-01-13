import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ChatEditController extends GetxController {
  // Messages with persistent TextEditingControllers
  var messages = <Map<String, dynamic>>[].obs;
  var textControllers = <TextEditingController>[].obs;

  // Formatting states
  var textStyles = <TextStyle>[].obs;
  var textAlignments = <TextAlign>[].obs;

  // Current editing states
  var currentTextAlign = TextAlign.left.obs;
  var fontSize = 16.0.obs;
  var isBold = false.obs;
  var isItalic = false.obs;
  var isUnderlined = false.obs;
  var currentEditingIndex = (-1).obs;

  // Initialize messages and controllers
  void initializeMessages(List<Map<String, dynamic>> initialMessages) {
    messages.value = initialMessages;

    // Create a TextEditingController and default styles for each message
    textControllers.value = List.generate(
      initialMessages.length,
          (index) => TextEditingController(text: initialMessages[index]['message']),
    );

    textStyles.value = List.generate(
      initialMessages.length,
          (_) => TextStyle(fontSize: fontSize.value),
    );

    textAlignments.value = List.generate(
      initialMessages.length,
          (_) => TextAlign.left,
    );
  }

  // Update the message text
  void updateMessage(int index, String text) {
    messages[index]['message'] = text;
  }

  // Update text alignment
  void updateAlignment(TextAlign alignment) {
    currentTextAlign.value = alignment;
    if (currentEditingIndex.value != -1) {
      textAlignments[currentEditingIndex.value] = alignment;
    }
  }

  // Update text style (bold, italic, underline, font size)
  void updateTextStyle({bool? bold, bool? italic, bool? underlined, double? size}) {
    if (currentEditingIndex.value == -1) return;

    final style = textStyles[currentEditingIndex.value];
    textStyles[currentEditingIndex.value] = style.copyWith(
      fontWeight: bold != null
          ? (bold ? FontWeight.bold : FontWeight.normal)
          : style.fontWeight,
      fontStyle: italic != null
          ? (italic ? FontStyle.italic : FontStyle.normal)
          : style.fontStyle,
      decoration: underlined != null
          ? (underlined ? TextDecoration.underline : TextDecoration.none)
          : style.decoration,
      fontSize: size ?? style.fontSize,
    );
  }

  var isEditing = false.obs; // Start with editing mode enabled

  void enableEditing() {
    isEditing.value = true;
  }

  void disableEditing() {
    isEditing.value = false;
  }


}
