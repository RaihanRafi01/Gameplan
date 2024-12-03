import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Assuming you may use SVG icons.
import 'package:agcourt/common/widgets/gradientCard.dart';

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
        if (isSentByUser) // Avatar on the left for user's messages
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage(avatarUrl),
            ),
          ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              if (!isSentByUser && editCallback != null)
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: GestureDetector(
                    onTap: editCallback,
                    child: SvgPicture.asset('assets/images/home/edit_icon.svg'),
                  ),
                ),
              SizedBox(width: 0),
              GradientCard(
                text: message,
                isSentByUser: isSentByUser,
              ),
              // Show edit icon only for bot's messages
            ],
          )
        ),
        if (!isSentByUser) // Avatar on the right for bot's messages
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
