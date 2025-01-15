import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../app/modules/dashboard/controllers/theme_controller.dart';
import '../../customFont.dart';

class ProfileList extends StatelessWidget {
  final String? svgPath;
  final String text;
  final VoidCallback onTap;
  final Widget? trailingWidget; // Optional trailing widget

  const ProfileList({
    super.key,
    this.svgPath,
    required this.text,
    required this.onTap,
    this.trailingWidget, // Initialize trailingWidget
  });

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();

    return Column(
      children: [
        Obx(() => ListTile(
          onTap: onTap,
          leading: svgPath != null // Check if svgPath is provided
              ? SvgPicture.asset(
            svgPath!,
            color: themeController.isDarkTheme.value
                ? Colors.white
                : Colors.black,
          )
              : null,
          title: Text(
            text,
            style: h3.copyWith(
              color: themeController.isDarkTheme.value
                  ? Colors.white
                  : Colors.black,
            ),
          ),
          trailing: trailingWidget ??
              Icon(
                Icons.navigate_next,
                color: themeController.isDarkTheme.value
                    ? Colors.white
                    : Colors.black,
              ),
        )),
        Divider(
          color: themeController.isDarkTheme.value
              ? Colors.white54
              : Colors.grey,
        ),
      ],
    );
  }
}
