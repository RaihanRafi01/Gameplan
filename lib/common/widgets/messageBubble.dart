import 'package:agcourt/common/widgets/gradientCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isSentByUser;
  final String avatarUrl;
  final VoidCallback? editCallback; // Callback for edit action

  const MessageBubble({
    super.key,
    required this.message,
    required this.isSentByUser,
    required this.avatarUrl,
    this.editCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
      isSentByUser ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: [
        if (isSentByUser)
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage(avatarUrl),
            ),
          ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GradientCard(text: message, isSentByUser: isSentByUser),
        ),
        if (isSentByUser && editCallback != null)
          GestureDetector(
            onTap: editCallback,
            child: SvgPicture.asset('assets/images/home/edit_icon.svg'),
          ),
        if (!isSentByUser)
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage(avatarUrl),
            ),
          ),
      ],
    );
  }
}
