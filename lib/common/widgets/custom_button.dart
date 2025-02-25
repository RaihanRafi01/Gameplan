import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../appColors.dart';
import '../customFont.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final double textSize;
  final bool isGem;
  final VoidCallback onPressed;
  final List<Color> backgroundGradientColor;
  final List<Color> borderGradientColor;
  final Color textColor;
  final double borderRadius;
  final EdgeInsets padding;
  final bool isEditPage;
  final double width;
  final double height;
  final String svgAsset;

  const CustomButton({
    super.key,
    this.textSize = 16,
    required this.text,
    required this.onPressed,
    this.isGem = false,
    this.backgroundGradientColor = AppColors.cardGradient,
    this.borderGradientColor = AppColors.transparent,
    this.textColor = Colors.white,
    this.borderRadius = 10.0,
    this.padding = const EdgeInsets.symmetric(vertical: 5),
    this.isEditPage = false,
    this.width = double.maxFinite,
    this.height = 45,
    this.svgAsset = 'assets/images/home/class_icon.svg',
  });

  @override
  Widget build(BuildContext context) {
    // Check if background should be transparent
    final isBackgroundTransparent = backgroundGradientColor.every((color) => color == Colors.transparent);

    return SizedBox(
      height: height,
      width: width,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          decoration: BoxDecoration(
            // Only apply gradient if not transparent
            gradient: isBackgroundTransparent
                ? null
                : LinearGradient(
              colors: backgroundGradientColor,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Stack(
            children: [
              // Border layer
              if (isEditPage && !borderGradientColor.every((color) => color == Colors.transparent))
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(borderRadius),
                    border: Border.all(
                      width: 1,
                      style: BorderStyle.solid,
                      // Use first color of gradient for solid border, or implement gradient border differently
                      color: borderGradientColor.first,
                    ),
                  ),
                ),
              // Content
              Padding(
                padding: padding,
                child: Center(child: textWithIcon()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget textWithIcon() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isGem && svgAsset.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: SvgPicture.asset(
              svgAsset,
              width: 15.0,
              height: 15.0,
              color: textColor,
            ),
          ),
        Text(
          text,
          textAlign: TextAlign.center,
          style: h4.copyWith(
            fontSize: textSize,
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}