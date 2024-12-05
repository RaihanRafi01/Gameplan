import 'package:agcourt/common/widgets/custom_button.dart';
import 'package:agcourt/common/widgets/custom_textField.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';

class HelpSupportView extends GetView {
  const HelpSupportView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CustomTextField(label: 'Email', prefixIcon: Icons.email_outlined),
            SizedBox(height: 20),
            CustomTextField(label: 'Write Your Problem'),
            Spacer(),
            CustomButton(
              text: 'SEND',
              onPressed: () {
                _showConfirmationDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: Column(
            children: [
              Text(
                'Help!',
                textAlign: TextAlign.center,
                style: h1.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Our team will contact you within 24 hours',
                textAlign: TextAlign.center,
                style: h4.copyWith(fontSize: 16),
              ),
              SizedBox(height: 20),
              CustomButton(
                text: 'OK',
                onPressed: () {
                  Navigator.pop(context);  // Close the dialog
                },
                backgroundGradientColor: AppColors.transparent,
                borderGradientColor: AppColors.cardGradient,
                isEditPage: true,
                textColor: AppColors.textColor,
              ),
            ],
          ),
        );
      },
    );
  }
}
