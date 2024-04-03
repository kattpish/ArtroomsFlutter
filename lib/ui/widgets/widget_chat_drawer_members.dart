
import 'package:flutter/cupertino.dart';
import 'package:sendbird_sdk/core/models/user.dart';


Widget widgetChatDrawerMembers(BuildContext context, List<User> listMembers) {
  return Column(
    children: [
      for(User member in listMembers)
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13.76),
                    ),
                  ),
                  child: FadeInImage.assetNetwork(
                    placeholder: (member.nickname == "artrooms" || member.nickname == "artroom") ? 'assets/images/chats/chat_artrooms.png' : 'assets/images/chats/placeholder_photo.png',
                    image: member.profileUrl != null ? member.profileUrl.toString() : "",
                    fit: BoxFit.cover,
                    fadeInDuration: const Duration(milliseconds: 100),
                    fadeOutDuration: const Duration(milliseconds: 100),
                    imageErrorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        (member.nickname == "artrooms" || member.nickname == "artroom") ? 'assets/images/chats/chat_artrooms.png' : 'assets/images/chats/placeholder_photo.png',
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  member.nickname,
                  style: const TextStyle(
                    color: Color(0xFF393939),
                    fontSize: 16,
                    fontFamily: 'SUIT',
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.32,
                  ),
                ),
              ]
          ),
        ),
    ],
  );
}
