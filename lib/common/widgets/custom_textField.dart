import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/modules/dashboard/controllers/theme_controller.dart';
import '../appColors.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final bool isMaxLength;
  final bool readOnly;
  final TextEditingController? controller;
  final IconData? prefixIcon;
  final Function(String)? onChanged; // Callback for text changes
  final TextInputType? keyboardType;
  final Function()? onTap;
  final double radius;

  const CustomTextField({
    super.key,
    this.readOnly = false,
    this.isMaxLength = false,
    required this.label,
    this.controller,
    this.prefixIcon,
    this.onChanged, // Accepts onChanged as a parameter
    this.keyboardType,
    this.onTap,
    this.radius = 12,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() => Text(
          widget.label,
          style: TextStyle(
            fontSize: 16,
            color: themeController.isDarkTheme.value
                ? Colors.white
                : Colors.black, // Dynamic label color
          ),
        )),
        const SizedBox(height: 8),
        Obx(() => TextField(
          maxLength: widget.isMaxLength ? 10 : null,
          readOnly: widget.readOnly,
          cursorColor: themeController.isDarkTheme.value
              ? Colors.white
              : AppColors.appColor, // Dynamic cursor color
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          onTap: widget.onTap,
          onChanged: widget.onChanged, // Passes text changes to the parent widget
          decoration: InputDecoration(
            hintStyle: TextStyle(
              color: themeController.isDarkTheme.value
                  ? Colors.white54
                  : AppColors.appColor, // Dynamic hint color
            ),
            prefixIcon: widget.prefixIcon != null
                ? Icon(
              widget.prefixIcon,
              color: themeController.isDarkTheme.value
                  ? Colors.white
                  : AppColors.appColor, // Dynamic prefix icon color
            )
                : null,
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
