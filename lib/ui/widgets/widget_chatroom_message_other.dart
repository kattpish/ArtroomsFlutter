
import 'package:artrooms/ui/widgets/widget_chatroom_message_attachment_file.dart';
import 'package:artrooms/ui/widgets/widget_chatroom_message_attachment_photos.dart';
import 'package:artrooms/ui/widgets/widget_chatroom_message_reply.dart';
import 'package:artrooms/ui/widgets/widget_chatroom_message_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';

import '../../beans/bean_message.dart';
import '../theme/theme_colors.dart';


Widget buildOtherMessageBubble(
    BuildContext context,
    int index,
    State state,
    DataMessage message,
    bool isLast,
    bool isPreviousSame,
    bool isNextSame,
    bool isPreviousSameDateTime,
    bool isNextSameTime,
    double screenWidth,
    Null Function() onReplyClick,
Null Function(int index) onReplySelect
    ) {
  return Container(
    margin: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 0,
        bottom: isLast ? 9 : (isNextSame ? 0 : 9)),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {},
              child: Visibility(
                visible: !isPreviousSame,
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: CircleAvatar(
                    radius: 15,
                    backgroundColor: isPreviousSame
                        ? Colors.transparent
                        : colorMainGrey200,
                    child: FadeInImage.assetNetwork(
                      placeholder: message.isArtrooms
                          ? 'assets/images/chats/chat_artrooms.png'
                          : 'assets/images/chats/placeholder_photo.png',
                      image: message.profilePictureUrl,
                      fit: BoxFit.cover,
                      fadeInDuration: const Duration(milliseconds: 100),
                      fadeOutDuration: const Duration(milliseconds: 100),
                      imageErrorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          message.isArtrooms
                              ? 'assets/images/chats/chat_artrooms.png'
                              : 'assets/images/chats/placeholder_photo.png',
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 6),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  margin: EdgeInsets.only(
                      left: isPreviousSame ? 34 : 4,
                      top: isPreviousSame ? 0 : 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Visibility(
                        visible: !isPreviousSame,
                        child: SizedBox(
                          child: Text(
                            message.getName(),
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                              color: Color(0xFF393939),
                              fontSize: 14,
                              fontFamily: 'SUIT',
                              fontWeight: FontWeight.w600,
                              height: 0.07,
                              letterSpacing: -0.28,
                            ),
                            maxLines: 1,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Visibility(
                        visible: message.content.isNotEmpty,
                        child: FocusedMenuHolder(
                          onPressed: () {},
                          menuWidth:
                          MediaQuery.of(
                              context)
                              .size
                              .width /
                              2,
                          menuItems: [
                            FocusedMenuItem(
                                trailingIcon:
                                const Icon(
                                  Icons.reply,
                                  color:
                                  colorMainGrey500,
                                ),
                                title: const Text(
                                    "답장"),
                                onPressed: () {
                                  onReplyClick();
                                }),
                            FocusedMenuItem(
                                trailingIcon:
                                const Icon(
                                  Icons.copy,
                                  color:
                                  colorMainGrey500,
                                ),
                                title: const Text(
                                    "복사"),
                                onPressed:
                                    () async {
                                  await Clipboard.setData(
                                      ClipboardData(
                                          text: message
                                              .content));
                                })
                          ],
                          blurSize: 0.0,
                          menuOffset: 10.0,
                          bottomOffsetHeight:
                          80.0,
                          menuBoxDecoration:
                          const BoxDecoration(
                              borderRadius: BorderRadius
                                  .all(Radius
                                  .circular(
                                  15.0))),
                          child: Container(
                            constraints: const BoxConstraints(
                                minHeight: 40, minWidth: 46),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                              color: colorMainGrey200,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(
                                    isPreviousSameDateTime ? 20 : 2),
                                topRight: const Radius.circular(20),
                                bottomLeft: const Radius.circular(20),
                                bottomRight: const Radius.circular(20),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(bottom: 2),
                                  constraints: BoxConstraints(
                                    maxWidth: screenWidth * 0.55,
                                  ),
                                  child: WidgetChatroomMessageText(
                                    message: message.content,
                                    color: const Color(0xFF1F1F1F),
                                    colorMention: colorPrimaryPurple,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: ((isPreviousSameDateTime && !isNextSameTime) ||
                      (!isPreviousSameDateTime && !isNextSameTime)) &&
                      message.content.isNotEmpty,
                  child: Text(
                    message.getTime(),
                    style: const TextStyle(
                      color: colorMainGrey300,
                      fontSize: 10,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w400,
                      height: 0.15,
                      letterSpacing: -0.20,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
        Container(
          alignment: Alignment.topLeft,
          margin: const EdgeInsets.only(left: 38),
          child: buildAttachment(context, state, message, screenWidth,),
        ),
        Container(
          alignment: Alignment.topLeft,
          child: buildImageAttachments(context, message, screenWidth),
        ),
      ],
    ),
  );
}