
import 'package:artrooms/ui/widgets/widget_chatroom_message_attachment_file.dart';
import 'package:artrooms/ui/widgets/widget_chatroom_message_attachment_photos.dart';
import 'package:artrooms/ui/widgets/widget_chatroom_message_reply.dart';
import 'package:artrooms/ui/widgets/widget_chatroom_message_text.dart';
import 'package:flutter/material.dart';

import '../../beans/bean_message.dart';
import '../theme/theme_colors.dart';


Widget buildMyMessageBubble(BuildContext context, State state, DataMessage message, bool isLast, bool isPreviousSameDateTime, bool isNextSameTime, double screenWidth) {
  return Container(
    margin:
    EdgeInsets.only(left: 16, right: 16, top: 0, bottom: isLast ? 9 : 0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Visibility(
          visible: message.content.isNotEmpty,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 1.2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Visibility(
                      visible: ((isPreviousSameDateTime && !isNextSameTime) ||
                          (!isPreviousSameDateTime && !isNextSameTime)) &&
                          message.content.isNotEmpty,
                      child: Text(
                        message.getTime(),
                        style: const TextStyle(
                          color: colorMainGrey300,
                          fontSize: 10,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w400,
                          height: 0.15,
                          letterSpacing: -0.20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      constraints:
                      BoxConstraints(maxWidth: screenWidth * 0.55),
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        color: colorPrimaryBlue,
                        borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(24),
                            topRight: Radius.circular(
                                isPreviousSameDateTime ? 24 : 0),
                            bottomLeft: const Radius.circular(24),
                            bottomRight: const Radius.circular(24)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildReply(message),
                          Container(
                            // height: min(100, message.content.length * 2),
                            padding: const EdgeInsets.only(left: 10),
                            child: WidgetChatroomMessageText(
                              message: message.content,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Stack(
          children: [
            Container(
              alignment: Alignment.topRight,
              child: buildAttachment(context, state, message, screenWidth,),
            ),
            Container(
                alignment: Alignment.topRight,
                margin: const EdgeInsets.only(top: 4),
                child: buildImageAttachments(context, message, screenWidth,)),
          ],
        ),
      ],
    ),
  );
}
