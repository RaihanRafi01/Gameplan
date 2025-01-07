// saved_messages.dart

import 'package:flutter/material.dart';

class SavedMessage {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final FontStyle fontStyle;
  final TextDecoration textDecoration;
  final TextAlign textAlign;

  SavedMessage({
    required this.text,
    required this.fontSize,
    required this.fontWeight,
    required this.fontStyle,
    required this.textDecoration,
    required this.textAlign,
  });
}

// Global list to store saved messages
List<SavedMessage> savedMessages = [];
Map<String, List<SavedMessage>> savedCollections = {};

