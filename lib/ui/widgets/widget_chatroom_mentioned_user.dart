
import 'dart:math';

import 'package:artrooms/ui/theme/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:sendbird_sdk/core/models/member.dart';

import '../../listeners/scroll_bouncing_physics.dart';

class WidgetChatroomMentionUser extends StatelessWidget {

  final List<Member> member;
  final void Function(Member) onCancelReply;

  const WidgetChatroomMentionUser({super.key,
    required this.member,
    required this.onCancelReply
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
          children: [
            Container(
              color: colorPrimaryPurple,
              width: 0,
            ),
            const SizedBox(width: 8),
            Expanded(child: widgetChatroomMentionUsers(member))
          ]
      ),
    );
  }

  Widget widgetChatroomMentionUsers(List<Member> memberList) {
    return ListView.builder(
        itemCount: memberList.length,
        shrinkWrap: true,
        physics: const ScrollPhysicsBouncing(),
        itemBuilder: (context,index) {
          Member member = memberList[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: InkWell(
              onTap: () {
                onCancelReply(memberList[index]);
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: FadeInImage.assetNetwork(
                      placeholder: (member.nickname == "artrooms" || member.nickname == "artroom") ? 'assets/images/chats/chat_artrooms.png' : 'assets/images/chats/placeholder_chat.png',
                      image: member.profileUrl != null ? member.profileUrl.toString() : "",
                      fit: BoxFit.cover,
                      fadeInDuration: const Duration(milliseconds: 100),
                      fadeOutDuration: const Duration(milliseconds: 100),
                      imageErrorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          (member.nickname == "artrooms" || member.nickname == "artroom") ? 'assets/images/chats/chat_artrooms.png' : 'assets/images/chats/placeholder_chat.png',
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      memberList[index].nickname,
                      style: const TextStyle(
                        color: Color(0xFF393939),
                        fontSize: 15,
                        fontFamily: 'SUIT',
                        fontWeight: FontWeight.w600,
                        height: 0,
                        letterSpacing: -0.30,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );}
    );
  }
}