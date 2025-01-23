import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/modules/dashboard/controllers/theme_controller.dart';
import '../../appColors.dart';
import '../../customFont.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String hint;
  final bool isPassword;
  final bool readOnly;
  final TextEditingController? controller;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final Function(String)? onChanged;
  final TextInputType? keyboardType;
  final Function()? onTap;
  final double radius;
  final bool isLogin;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    this.isPassword = false,
    this.readOnly = false,
    this.isLogin = false,
    this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.keyboardType,
    this.onTap,
    this.radius = 12,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;
  final ThemeController themeController = Get.find<ThemeController>();

  @override
  void initState() {
    super.initState();
    if (!widget.isPassword) {
      _obscureText = false;
    }
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Text(
          widget.label,
          style: h4.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: widget.isLogin
                ? AppColors.blurtext // Gray color if isLogin is true
                : (themeController.isDarkTheme.value ? Colors.white : Colors.black), // Dynamic text color
          ),
        ),
        const SizedBox(height: 8),
        Obx(() => TextField(
          cursorColor: widget.isLogin
              ? Colors.black38 // Gray color if isLogin is true
              : (themeController.isDarkTheme.value ? Colors.white : AppColors.appColor), // Dynamic cursor color
          controller: widget.controller,
          onChanged: widget.onChanged,
          obscureText: widget.isPassword ? _obscureText : false,
          readOnly: widget.readOnly,
          keyboardType: widget.keyboardType,
          onTap: widget.onTap,
          decoration: InputDecoration(
            filled: widget.isLogin,
            fillColor: widget.isLogin? Colors.white : Colors.transparent,
            hintText: widget.hint,
            hintStyle: h4.copyWith(
              color: widget.isLogin
                  ? AppColors.textColor2 // Gray color if isLogin is true
                  : (themeController.isDarkTheme.value ? Colors.white54 : AppColors.appColor) , // Dynamic hint color
            ),
            prefixIcon: widget.prefixIcon != null
                ? Icon(
              widget.prefixIcon,
              color: themeController.isDarkTheme.value
                  ? Colors.white
                  : AppColors.appColor, // Dynamic prefix icon color
            )
                : null,
            suffixIcon: widget.isPassword
                ? IconButton(
              icon: Icon(
                _obscureText
                    ? Icons.visibility_off_rounded
                    : Icons.visibility_rounded,
                color: themeController.isDarkTheme.value
                    ? Colors.white
                    : AppColors.appColor, // Dynamic suffix icon color
              ),
              onPressed: _togglePasswordVisibility,
            )
                : (widget.suffixIcon != null
                ? Icon(
              widget.suffixIcon,
              color: themeController.isDarkTheme.value
                  ? Colors.white
                  : AppColors.appColor, // Dynamic suffix icon color
            )
                : null),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.radius),
              borderSide: BorderSide(
                color: themeController.isDarkTheme.value
                    ? Colors.white
                    : AppColors.appColor, // Dynamic border color
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.radius),
              borderSide: BorderSide(
                color: themeController.isDarkTheme.value
                    ? Colors.white
                    : AppColors.appColor, // Dynamic enabled border color
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.radius),
              borderSide: BorderSide(
                color: themeController.isDarkTheme.value
                    ? Colors.white
                    : AppColors.appColor, // Dynamic focused border color
                width: 2,
              ),
            ),
          ),
        )),
        const SizedBox(height: 12),
      ],
    );
  }
}
