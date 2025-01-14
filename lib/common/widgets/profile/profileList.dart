import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../app/modules/dashboard/controllers/theme_controller.dart';
import '../../customFont.dart';

class ProfileList extends StatelessWidget {
  final String svgPath;
  final String text;
  final VoidCallback onTap; // Callback for tap actions

  const ProfileList({
    super.key,
    required this.svgPath,
    required this.text,
    required this.onTap, // Required onTap callback
  });

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();

    return Column(
      children: [
        Obx(() => ListTile(
          onTap: onTap,
          leading: SvgPicture.asset(
            svgPath,
            color: themeController.isDarkTheme.value
                ? Colors.white
                : Colors.black, // Adjust icon color
          ),
          title: Text(
            text,
            style: h3.copyWith(
              color: themeController.isDarkTheme.value
                  ? Colors.white
                  : Colors.black, // Adjust text color
            ),
          ),
          trailing: Icon(
            Icons.navigate_next,
            color: themeController.isDarkTheme.value
                ? Colors.white
                : Colors.black, // Adjust trailing icon color
          ),
        )),
        Divider(
          color: themeController.isDarkTheme.value
              ? Colors.white54
              : Colors.grey, // Adjust divider color
        ),
      ],
    );
  }
}
