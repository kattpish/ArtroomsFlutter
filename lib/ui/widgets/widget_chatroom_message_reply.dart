import 'dart:convert';

import 'package:artrooms/beans/bean_message.dart';
import 'package:artrooms/ui/widgets/widget_chatroom_message_reply_flow.dart';
import 'package:flutter/material.dart';

import '../theme/theme_colors.dart';

class WidgetChatroomMessageReply extends StatelessWidget {
  final DataMessage message;
  final VoidCallback onCancelReply;

  const WidgetChatroomMessageReply(
      {super.key, required this.message, required this.onCancelReply});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Container(
            color: colorPrimaryPurple,
            width: 0,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: buildReplyMessage(),
          ),
        ],
      ),
    );
  }

  Widget buildReplyMessage() {
    return Row(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      message.senderName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(message.content,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF979797),
                    fontSize: 14,
                    fontFamily: 'SUIT',
                    fontWeight: FontWeight.w400,
                    height: 0,
                    letterSpacing: -0.28,
                  )),
            ],
          ),
        ),
        GestureDetector(
          onTap: onCancelReply,
          child: const Icon(
            Icons.close,
            size: 20,
            color: colorMainGrey500,
          ),
        ),
      ],
    );
  }
}

Widget buildReply(int index, DataMessage message, bool isMe,
    Null Function(int id) onReplyClick) {
  return (_doParseReplyMessage(message.data))
      ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                ParentMessage? parent = _getParentMessage(message.data);
                if (parent != null) {
                  onReplyClick(parent.messageId);
                }
              },
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: WidgetChatroomMessageFlow(
                  message: message,
                  isMe: isMe,
                  key: null,
                ),
              ),
            ),
            Container(
              height: 1,
              margin: const EdgeInsets.only(top: 10, bottom: 8),
              decoration: BoxDecoration(
                color: isMe
                    ? Colors.white.withOpacity(0.2)
                    : Colors.black.withOpacity(0.2),
              ),
            ),
          ],
        )
      : const SizedBox.shrink();
}

bool _doParseReplyMessage(String json) {
  try {
    ParentMessage parentMessage =
        ParentMessage.fromJson(const JsonDecoder().convert(json));
    if (parentMessage.messageId != 0 && parentMessage.senderName != "") {
      return true;
    }
    return false;
  } catch (_) {
    return false;
  }
}

ParentMessage? _getParentMessage(String json) {
  try {
    ParentMessage parentMessage =
        ParentMessage.fromJson(const JsonDecoder().convert(json));
    return parentMessage;
  } catch (_) {
    return null;
  }
}
