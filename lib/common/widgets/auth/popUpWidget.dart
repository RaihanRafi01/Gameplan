import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../app/modules/authentication/views/authentication_view.dart';
import '../../customFont.dart';
import '../custom_button.dart';

class PasswordChangedBottomSheet extends StatefulWidget {
  final VoidCallback onBackToLogin;

  const PasswordChangedBottomSheet({Key? key, required this.onBackToLogin}) : super(key: key);

  @override
  _PasswordChangedBottomSheetState createState() => _PasswordChangedBottomSheetState();
}

class _PasswordChangedBottomSheetState extends State<PasswordChangedBottomSheet> {
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    // Trigger the fade-in animation after the widget is built.
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _isVisible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset('assets/images/auth/password_change_bar.svg'),
          SizedBox(height: 30),
          AnimatedOpacity(
            opacity: _isVisible ? 1.0 : 0.0,
            duration: Duration(seconds: 1), // Animation duration
            child: SvgPicture.asset('assets/images/auth/password_change_tic.svg'),
          ),
          const SizedBox(height: 20),
          Text(
            "Password Changed!",
            style: h1.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Return to the login page to enter your account with your new password.",
            textAlign: TextAlign.center,
            style: h2.copyWith(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: CustomButton(text: "Back To Login", onPressed: ()=> Get.offAll(()=> AuthenticationView())),
          ),
        ],
      ),
    );
  }
}
