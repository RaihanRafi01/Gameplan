import 'package:flutter/material.dart';
import '../appColors.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final TextEditingController? controller;
  final IconData? prefixIcon;
  final Function(String)? onChanged;
  final TextInputType? keyboardType;
  final Function()? onTap;
  final double radius;
  final Color textColor;

  const CustomTextField({
    super.key,
    required this.label,
    this.controller,
    this.prefixIcon,
    this.onChanged,
    this.keyboardType,
    this.onTap,
    this.radius = 12,
    this.textColor = AppColors.textColor
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
        Text(widget.label, style: TextStyle(fontSize: 16,color: Colors.black)),
        const SizedBox(height: 8),
        TextField(
          cursorColor: AppColors.appColor,
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          onTap: widget.onTap,
          decoration: InputDecoration(
            hintStyle: TextStyle(color: AppColors.appColor),
            prefixIcon: widget.prefixIcon != null ? Icon(color: AppColors.appColor,widget.prefixIcon) : null,
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
