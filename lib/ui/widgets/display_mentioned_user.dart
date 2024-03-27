
import 'package:flutter/material.dart';

class MentionedUser extends StatelessWidget {
  final List<String> member;
  final VoidCallback onCancelReply;

  const MentionedUser({super.key,
    required this.member,
    required this.onCancelReply
  });

  @override
  Widget build(BuildContext context) =>
      IntrinsicHeight(
          child: Row(
              children: [
                Container(
                  color: Colors.green,
                  width: 4,
                ),
                const SizedBox(width: 8),
                Expanded(child: buildReplyMessage(member))
              ]));

  Widget buildReplyMessage(List<String> memberList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(children: [
          Row(
            children: [
               Expanded(
                child: Text(
                  memberList[0],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text('', style: TextStyle(color: Colors.black54)),
          Row(
            children: [
               Expanded(
                child: Text(
                  memberList[1],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text('', style: TextStyle(color: Colors.black54)),
        ],),

      ],
    );
  }
}