import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';
import '../../../app/modules/dashboard/controllers/theme_controller.dart';

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

  // Static TextField for isLogin: true
  Widget _buildStaticTextField() {
    return TextField(
      cursorColor: Colors.black38, // Fixed for light theme
      controller: widget.controller,
      onChanged: widget.onChanged,
      obscureText: widget.isPassword ? _obscureText : false,
      readOnly: widget.readOnly,
      keyboardType: widget.keyboardType,
      onTap: widget.onTap,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: widget.hint,
        hintStyle: h4.copyWith(color: AppColors.textColor2),
        prefixIcon: widget.prefixIcon != null
            ? Icon(widget.prefixIcon, color: AppColors.appColor)
            : null,
        suffixIcon: widget.isPassword
            ? IconButton(
          icon: Icon(
            _obscureText
                ? Icons.visibility_off_rounded
                : Icons.visibility_rounded,
            color: AppColors.appColor,
          ),
          onPressed: _togglePasswordVisibility,
        )
            : (widget.suffixIcon != null
            ? Icon(widget.suffixIcon, color: AppColors.appColor)
            : null),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.radius),
          borderSide: const BorderSide(color: AppColors.appColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.radius),
          borderSide: const BorderSide(color: AppColors.appColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.radius),
          borderSide: const BorderSide(color: AppColors.appColor, width: 2),
        ),
      ),
    );
  }

  // Dynamic TextField with Obx for isLogin: false
  Widget _buildDynamicTextField() {
    return Obx(() {
      final isDark = themeController.isDarkTheme.value;
      return TextField(
        cursorColor: isDark ? Colors.white : AppColors.appColor,
        controller: widget.controller,
        onChanged: widget.onChanged,
        obscureText: widget.isPassword ? _obscureText : false,
        readOnly: widget.readOnly,
        keyboardType: widget.keyboardType,
        onTap: widget.onTap,
        decoration: InputDecoration(
          filled: false,
          hintText: widget.hint,
          hintStyle: h4.copyWith(
            color: isDark ? Colors.white54 : AppColors.appColor,
          ),
          prefixIcon: widget.prefixIcon != null
              ? Icon(
            widget.prefixIcon,
            color: isDark ? Colors.white : AppColors.appColor,
          )
              : null,
          suffixIcon: widget.isPassword
              ? IconButton(
            icon: Icon(
              _obscureText
                  ? Icons.visibility_off_rounded
                  : Icons.visibility_rounded,
              color: isDark ? Colors.white : AppColors.appColor,
            ),
            onPressed: _togglePasswordVisibility,
          )
              : (widget.suffixIcon != null
              ? Icon(
            widget.suffixIcon,
            color: isDark ? Colors.white : AppColors.appColor,
          )
              : null),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.radius),
            borderSide: BorderSide(
              color: isDark ? Colors.white : AppColors.appColor,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.radius),
            borderSide: BorderSide(
              color: isDark ? Colors.white : AppColors.appColor,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.radius),
            borderSide: BorderSide(
              color: isDark ? Colors.white : AppColors.appColor,
              width: 2,
            ),
          ),
        ),
      );
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
                ? AppColors.blurtext
                : (themeController.isDarkTheme.value
                ? Colors.white
                : Colors.black),
          ),
        ),
        const SizedBox(height: 8),
        widget.isLogin ? _buildStaticTextField() : _buildDynamicTextField(),
        const SizedBox(height: 12),
      ],
    );
  }
}