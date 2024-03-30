import 'package:artrooms/beans/bean_message.dart';
import 'package:flutter/material.dart';

class ReplyMessageWidget extends StatelessWidget {

  final DataMessage message;
  final VoidCallback onCancelReply;

  const ReplyMessageWidget({super.key,
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