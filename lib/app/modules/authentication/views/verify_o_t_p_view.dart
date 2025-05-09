import 'dart:async';
import 'package:agcourt/app/modules/authentication/views/reset_password_view.dart';
import 'package:agcourt/app/modules/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';
import '../../../../common/widgets/auth/pinCode_InputField.dart';
import '../../../../common/widgets/custom_button.dart';
import '../../../data/services/api_services.dart';
import '../controllers/authentication_controller.dart';

class VerifyOTPView extends StatefulWidget {
  final String? forgotUserName;
  final bool isForgot;
  const VerifyOTPView({super.key, this.forgotUserName, this.isForgot = false});

  @override
  State<VerifyOTPView> createState() => _VerifyOTPViewState();
}

class _VerifyOTPViewState extends State<VerifyOTPView> {
  late Timer _timer;
  late final String email;
  int _remainingSeconds = 30;
  bool _isResendEnabled = false;
  String? _verificationMessage;
  final AuthenticationController _controller = Get.put(AuthenticationController());
  final TextEditingController _otpController = TextEditingController();

  @override
  void initState() {
    final HomeController homeController = Get.put(HomeController());
    email = homeController.emailOBS.value;
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      _isResendEnabled = false;
      _remainingSeconds = 30;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _timer.cancel();
        setState(() {
          _isResendEnabled = true;
        });
      }
    });
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$secs";
  }

  void _resendOTP() {
    print("OTP resent");
    _controller.resendOTP(widget.forgotUserName!);
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        // Define a light theme specifically for this view
        primaryColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          color: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(color: Colors.black, fontSize: 20),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black),
          bodyMedium: TextStyle(color: Colors.black),
        ),
        colorScheme: const ColorScheme.light(
          primary: Colors.white,
          onPrimary: Colors.black,
          surface: Colors.white,
          onSurface: Colors.black,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'OTP has been sent to your Email',
                    style: h4.copyWith(fontSize: 14),
                  ),
                  const SizedBox(height: 20),
                  PinCodeInputField(
                    onCompleted: (code) {
                      _otpController.text = code;
                    },
                  ),
                  if (_verificationMessage != null)
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        _verificationMessage!,
                        style: h4.copyWith(
                          color: _verificationMessage == "Code is Correct"
                              ? Colors.green
                              : Colors.red,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                  CustomButton(
                    height: 45,
                    borderRadius: 5,
                    width: 150,
                    text: "Verify OTP",
                    onPressed: () {
                      print(':::::::::::::::::::::::::USERNAME TO BE SENT:::${widget.forgotUserName}');
                      final otp = _otpController.text.trim();
                      if (otp.isEmpty) {
                        Get.snackbar('Error', 'Please enter the OTP');
                      } else {
                        widget.isForgot
                            ? _controller.verifyForgotOTP(widget.forgotUserName!, otp)
                            : _controller.verifyOTP(email, otp);
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _formatTime(_remainingSeconds),
                        style: const TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      const Text(' | ', style: TextStyle(fontSize: 16)),
                      GestureDetector(
                        onTap: _isResendEnabled ? _resendOTP : null,
                        child: Text(
                          'Resend OTP',
                          style: h4.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: _isResendEnabled
                                ? AppColors.appColor
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Obx(() {
              return _controller.isLoading.value
                  ? Container(
                color: Colors.black45,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              )
                  : const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }
}