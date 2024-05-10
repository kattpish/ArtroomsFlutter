import 'package:artrooms/ui/widgets/widget_chatroom_mentioned_user.dart';
import 'package:flutter/material.dart';
import 'package:sendbird_sdk/core/models/member.dart';

class ChatroomMessageMention extends StatelessWidget {
    final Null Function(Member member) onCancelReply;
    final List<Member> members;
  const ChatroomMessageMention({super.key, required this.onCancelReply, required this.members});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(0),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: WidgetChatroomMentionUser(
        member: members,
        onCancelReply: (Member member) {
          onCancelReply(member);
        },
      ),
    );
  }
}
