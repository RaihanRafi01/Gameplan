import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TextEditorController extends GetxController {
  var fontSize = 16.0.obs;
  var currentEditingIndex = (-1).obs;
  var textStyles = <TextStyle>[].obs;
  var textAlignments = <TextAlign>[].obs;

  // Initialize styles for messages
  void initializeStyles(int messageCount) {
    textStyles.value = List.generate(
      messageCount,
          (_) => TextStyle(fontSize: 16.0),
    );
    textAlignments.value = List.generate(
      messageCount,
          (_) => TextAlign.left,
    );
  }

  // Reset all styles to default
  void resetStyles(int index) {
    if (_isValidIndex(index)) {
      textStyles[index] = const TextStyle(fontSize: 16.0);
      textAlignments[index] = TextAlign.left;
      debugPrint("Styles reset for message at index $index.");
    }
  }

  // Update text style for the current message
  void updateTextStyle({
    required int index,
    double? fontSize,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    TextDecoration? decoration,
  }) {
    if (_isValidIndex(index)) {
      final style = textStyles[index];
      textStyles[index] = style.copyWith(
        fontSize: fontSize ?? style.fontSize,
        fontWeight: fontWeight ?? style.fontWeight,
        fontStyle: fontStyle ?? style.fontStyle,
        decoration: decoration ?? style.decoration,
      );
      debugPrint("Text style updated for message at index $index: $textStyles[index]");
    }
  }

  // Update text alignment for the current message
  void updateTextAlignment(int index, TextAlign alignment) {
    if (_isValidIndex(index)) {
      textAlignments[index] = alignment;
      debugPrint("Text alignment updated for message at index $index: $alignment");
    }
  }

  // Add new messages and initialize styles dynamically
  void addMessages(int newMessageCount) {
    textStyles.addAll(List.generate(
      newMessageCount,
          (_) => const TextStyle(fontSize: 16.0),
    ));
    textAlignments.addAll(List.generate(
      newMessageCount,
          (_) => TextAlign.left,
    ));
    debugPrint("Added $newMessageCount new messages. Updated styles and alignments.");
  }

  // Validate index range
  bool _isValidIndex(int index) {
    return index >= 0 && index < textStyles.length;
  }
}
