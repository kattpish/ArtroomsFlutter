
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sendbird_sdk/core/models/member.dart';

class MentionedUser extends StatelessWidget {
  final List<Member> member;
  final void Function(Member) onCancelReply;

  const MentionedUser({super.key,
    required this.member,
    required this.onCancelReply
  });

  @override
  Widget build(BuildContext context) =>
      SizedBox(
        height: min(200.0, 50.0 * member.length),
        child: Row(
            children: [
              Container(
                color: Colors.green,
                width: 4,
              ),
              const SizedBox(width: 8),
              Expanded(child: buildReplyMessage(member))
            ]),
      );

  Widget buildReplyMessage(List<Member> memberList) {
    return ListView.builder(itemCount: memberList.length,shrinkWrap: true,itemBuilder: (context,index){
      return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: (){
                onCancelReply(memberList[index]);
              },
              child: Row(
              children: [
                Expanded(
                  child: Text(
                    memberList[index].nickname,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
          ),
            ),
            const SizedBox(height: 8),
            const Text('', style: TextStyle(color: Colors.black54)),
          ]
      );}
      );
  }
}