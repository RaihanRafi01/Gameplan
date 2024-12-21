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
    return Column(
      children: [
        ListTile(
          onTap: onTap,
          leading: SvgPicture.asset(svgPath),
          title: Text(text,style: h4,),
          trailing: Icon(Icons.navigate_next),
        ),
        Divider()
      ],
    );
  }
}
