
import 'dart:convert';

import 'package:artrooms/beans/bean_message.dart';
import 'package:flutter/material.dart';


class WidgetChatroomMessageFlow extends StatelessWidget {

  final DataMessage message;

  const WidgetChatroomMessageFlow({super.key,
    required this.message
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
    child: Row(
      children: [
        Container(
          width: 4,
        ),
        const SizedBox(width: 0),
        Expanded(child:  buildReplyMessageForText()),
      ],
    ),
  );
  }

  Widget buildReplyMessageForText() {

    ParentMessage parentMessage = ParentMessage(0, "", "","");

    try{
       parentMessage = ParentMessage.fromJson(const JsonDecoder().convert(message.data));
    }catch(_){
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                '${parentMessage.senderName}에게 답장',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontFamily: 'SUIT',
                  fontWeight: FontWeight.w400,
                  height: 0,
                  letterSpacing: -0.26,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
            parentMessage.content,
            maxLines: 1,
            textAlign: TextAlign.start,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 13,
              fontFamily: 'SUIT',
              fontWeight: FontWeight.w400,
              height: 0,
              letterSpacing: -0.26,
        )),
      ],
    );
  }

}