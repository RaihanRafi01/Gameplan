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
  final String svgAsset;  // Add a parameter to pass the SVG asset path

  const CustomButton({
    super.key,
    this.textSize = 16, //16 for all //
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
    this.svgAsset = 'assets/images/home/class_icon.svg', // Default empty, no SVG displayed
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: backgroundGradientColor,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: isEditPage
              ? ShaderMask(
            shaderCallback: (Rect bounds) {
              return LinearGradient(
                colors: borderGradientColor,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(borderRadius),
                border: Border.all(
                  color: Colors.white, // Placeholder color (not visible)
                  width: 2, // Border width
                ),
              ),
              padding: padding,
              alignment: Alignment.center,
              child: textWithIcon(),
            ),
          )
              : Container(
            padding: padding,
            alignment: Alignment.center,
            child: textWithIcon(),
          ),
        ),
      ),
    );
  }

  // Helper method to return the text with an optional SVG icon
  Widget textWithIcon() {
    return Row(
      children: [
        if (isGem && svgAsset.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 15), // Add padding to the right of the image
            child: SvgPicture.asset(
              svgAsset, // SVG asset path
              width: 15.0, // Adjust the size as needed
              height: 15.0,
              color: Colors.white,// Adjust the size as needed
            ),
          ),
        Expanded(
          child: Text(
            text,
            textAlign: TextAlign.center, // Center the text horizontally
            style: h4.copyWith(
              fontSize: textSize,
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
