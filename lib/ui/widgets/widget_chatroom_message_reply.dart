
import 'dart:convert';

import 'package:artrooms/beans/bean_message.dart';
import 'package:artrooms/ui/widgets/widget_chatroom_message_reply_flow.dart';
import 'package:flutter/material.dart';


class WidgetChatroomMessageReply extends StatelessWidget {

  final DataMessage message;
  final VoidCallback onCancelReply;

  const WidgetChatroomMessageReply({super.key,
    required this.message,
    required this.onCancelReply
  });

  @override
  Widget build(BuildContext context) => IntrinsicHeight(
    child: Row(
      children: [
        Container(
          color: Colors.green,
          width: 4,
        ),
        const SizedBox(width: 8),
        Expanded(child: buildReplyMessage()),
      ],
    ),
  );

  Widget buildReplyMessage() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Expanded(
            child: Text(
              message.senderName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          GestureDetector(
            onTap: onCancelReply,
            child: const Icon(Icons.close, size: 16),
          )
        ],
      ),
      const SizedBox(height: 8),
      Text(message.content, style: const TextStyle(color: Colors.black54)),
    ],
  );

}

Widget buildReply(DataMessage message) {
  return (_doParseReplyMessage(message.data))
      ? Column(
    children: [
      Container(
          padding: const EdgeInsets.all(0),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          child: WidgetChatroomMessageFlow(
            message: message,
            key: null,
          )),
      const Divider(color: Colors.white),
      // const SizedBox(height: 2,),
    ],
  )
      : Container()
  ;
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
