import 'package:flutter/material.dart';
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
  final Color textColor;

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
    this.textColor = AppColors.textColor,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: const TextStyle(fontSize: 16, color: Colors.black)),
        const SizedBox(height: 8),
        TextField(
          maxLength: widget.isMaxLength ? 10 : null,
          readOnly: widget.readOnly,
          cursorColor: AppColors.appColor,
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          onTap: widget.onTap,
          onChanged: widget.onChanged, // Passes text changes to the parent widget
          decoration: InputDecoration(
            hintStyle: TextStyle(color: AppColors.appColor),
            prefixIcon: widget.prefixIcon != null
                ? Icon(widget.prefixIcon, color: AppColors.appColor)
                : null,
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
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
