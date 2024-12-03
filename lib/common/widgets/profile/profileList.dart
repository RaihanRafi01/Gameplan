import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
    return GestureDetector(
      onTap: onTap, // Call the provided callback when tapped
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
        child: Column(
          children: [
            Row(
              children: [
                SvgPicture.asset(svgPath),
                SizedBox(width: 10),
                Text(text,style: h4,),
                Spacer(),
                Icon(Icons.navigate_next),
              ],
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
