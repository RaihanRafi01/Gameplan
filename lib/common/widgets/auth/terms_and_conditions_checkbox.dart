import 'package:agcourt/app/modules/profile/views/terms_privacy_view.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../appColors.dart';
import '../../customFont.dart';

// New widget class for Checkbox and Terms/Privacy Policy logic
class TermsAndConditionsCheckbox extends StatefulWidget {
  final Function(bool) onCheckboxChanged;

  const TermsAndConditionsCheckbox({super.key, required this.onCheckboxChanged});

  @override
  _TermsAndConditionsCheckboxState createState() => _TermsAndConditionsCheckboxState();
}

class _TermsAndConditionsCheckboxState extends State<TermsAndConditionsCheckbox> {
  bool _isChecked = false;


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Checkbox(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          activeColor: AppColors.appColor,
          checkColor: Colors.white,
          value: _isChecked,
          onChanged: (bool? value) {
            setState(() {
              _isChecked = value ?? false;
            });
            widget.onCheckboxChanged(_isChecked);  // Notify parent widget about the checkbox state
          },
        ),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'By creating an account, I accept the ',
                  style: h4.copyWith(color: Colors.black),
                ),
                TextSpan(
                  text: 'Terms & Conditions',
                  style: h4.copyWith(color: Colors.blue),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Get.to(() => TermsPrivacyView(isTerms: true));
                    },
                ),
                TextSpan(
                  text: ' & ',
                  style: h4.copyWith(color: Colors.black),
                ),
                TextSpan(
                  text: 'Privacy Policy',
                  style: h4.copyWith(color: Colors.blue),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Get.to(() => TermsPrivacyView(isTerms: false));
                    },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
