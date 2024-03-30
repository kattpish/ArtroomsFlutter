import 'dart:convert';

import 'package:artrooms/beans/bean_message.dart';
import 'package:flutter/material.dart';

class ReplyMessageFlowWidget extends StatelessWidget {
  final DataMessage message;

  const ReplyMessageFlowWidget({super.key,
    required this.message
  });

  @override
  Widget build(BuildContext context) => IntrinsicHeight(
    child: Row(
      children: [
        Container(
          // color: Colors.green,
          width: 4,
        ),
        const SizedBox(width: 8),
        Expanded(child:  buildReplyMessageForText()),
      ],
    ),
  );

  Widget buildReplyMessageForText() {
    // Map<String, dynamic> jsonInput
    late ParentMessage parentMessage = ParentMessage(0, "", "","");
    try{
       parentMessage = ParentMessage.fromJson(const JsonDecoder().convert(message.data));
    }catch(_){
      // parentMessage = ParentMessage(0, "", "");
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                parentMessage.content,
                style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(parentMessage.senderName, style: const TextStyle(color: Colors.white)),
      ],
    );
  }

}