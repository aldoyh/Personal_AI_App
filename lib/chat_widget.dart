import 'package:flutter/material.dart';
import 'package:personal_ai_app/constants/constants.dart';
import 'package:personal_ai_app/services/assets_manager.dart';
import 'package:personal_ai_app/widgets/text_widget.dart';

class ChatWidget extends StatelessWidget {
  ChatWidget({required this.msg, required this.chatIndex});
  final String msg;
  final int chatIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: chatIndex == 0 ? kScaffoldBackgroundColor : kCardColor,
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  chatIndex == 0 ? AssetsManager.userImage : AssetsManager.botImage,
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: TextWidget(
                    label: msg,
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                if (chatIndex == 0) ...[
                  const Icon(
                    Icons.thumb_up_alt_outlined,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  const Icon(
                    Icons.thumb_down_alt_outlined,
                    color: Colors.white,
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
