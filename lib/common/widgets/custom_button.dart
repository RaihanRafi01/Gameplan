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
  final double? height; // Nullable height for flexibility
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
    this.padding = const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
    this.isEditPage = false,
    this.width = double.maxFinite,
    this.height, // No default height; null means dynamic
    this.svgAsset = 'assets/images/home/class_icon.svg',
  });

  @override
  Widget build(BuildContext context) {
    final isBackgroundTransparent = backgroundGradientColor.every((color) => color == Colors.transparent);

    // Use SizedBox with fixed height if provided, otherwise let content determine height
    Widget buttonContent = InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        width: width,
        decoration: BoxDecoration(
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
            if (isEditPage && !borderGradientColor.every((color) => color == Colors.transparent))
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(borderRadius),
                  border: Border.all(
                    width: 1,
                    style: BorderStyle.solid,
                    color: borderGradientColor.first,
                  ),
                ),
              ),
            Padding(
              padding: padding,
              child: Center(child: textWithIcon()),
            ),
          ],
        ),
      ),
    );

    // Apply fixed height if specified, otherwise allow dynamic height
    return height != null
        ? SizedBox(
      height: height,
      width: width,
      child: buttonContent,
    )
        : buttonContent; // Dynamic height when height is null
  }

  Widget textWithIcon() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
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
        Flexible(
          child: Text(
            text,
            textAlign: TextAlign.start,
            style: h4.copyWith(
              fontSize: textSize,
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: height != null ? 1 : 2, // 1 line if fixed height, 2 if dynamic
          ),
        ),
      ],
    );
  }
}