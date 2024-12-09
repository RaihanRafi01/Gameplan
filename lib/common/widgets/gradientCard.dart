import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../appColors.dart';
import '../customFont.dart';

class GradientCard extends StatelessWidget {
  final String text;
  final bool isSentByUser;
  final Color textColor;

  const GradientCard({super.key, required this.text , this.isSentByUser = false , this.textColor = Colors.black});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: 50, // Minimum width for short texts
        maxWidth: MediaQuery.of(context).size.width * 0.65, // Max width for long texts
      ),
      child: Container(
        decoration: isSentByUser? BoxDecoration(border: Border.all(),borderRadius: BorderRadius.circular(5)) : BoxDecoration(
           gradient: LinearGradient(
            colors: AppColors.cardGradient,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            text,
            textAlign: TextAlign.start,
            style: h4.copyWith(
              color: isSentByUser? textColor : Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
