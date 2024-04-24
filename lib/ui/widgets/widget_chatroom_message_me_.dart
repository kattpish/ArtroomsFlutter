import 'package:artrooms/beans/bean_message.dart';
import 'package:artrooms/ui/widgets/widget_chatroom_message_attachment_file.dart';
import 'package:artrooms/ui/widgets/widget_chatroom_message_attachment_photos.dart';
import 'package:artrooms/ui/widgets/widget_chatroom_message_reply.dart';
import 'package:artrooms/ui/widgets/widget_chatroom_message_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';

import '../theme/theme_colors.dart';

class ChatroomMessageMe extends StatelessWidget {
  final int index;
  final State state;
  final DataMessage message;
  final List<DataMessage> listMessages;
  final bool isLast;
  final bool isPreviousSame;
  final bool isNextSame;
  final bool isPreviousSameDateTime;
  final bool isNextSameTime;
  final double screenWidth;
  final Null Function() onReplyClick;
  final Null Function(int index) onReplySelect;
  const ChatroomMessageMe({super.key, required this.index, required this.state, required this.message, required this.listMessages, required this.isLast, required this.isPreviousSame, required this.isNextSame, required this.isPreviousSameDateTime, required this.isNextSameTime, required this.screenWidth, required this.onReplyClick, required this.onReplySelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: isLast ? 9 : 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if(message.content.isNotEmpty)
            Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 1.2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if(((isPreviousSameDateTime && !isNextSameTime) || (!isPreviousSameDateTime && !isNextSameTime)) && message.content.isNotEmpty)
                        Text(
                          message.getTime(),
                          style: const TextStyle(
                            color: colorMainGrey300,
                            fontSize: 10,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w400,
                            height: 0.15,
                            letterSpacing: -0.20,
                          ),
                        ),
                      const SizedBox(width: 8),
                      FocusedMenuHolder(
                        onPressed: () {},
                        menuWidth: screenWidth / 2,
                        menuItems: [
                          FocusedMenuItem(
                              trailingIcon:
                              const Icon(
                                Icons.reply,
                                color:
                                colorMainGrey500,
                              ),
                              title: const Text("답장"),
                              onPressed: () {
                                onReplyClick();
                              }),
                          FocusedMenuItem(
                              trailingIcon:
                              const Icon(
                                Icons.copy,
                                color:
                                colorMainGrey500,
                                textDirection: TextDirection.ltr,
                              ),
                              title: const Text("복사"),
                              onPressed:
                                  () async {
                                await Clipboard.setData(
                                    ClipboardData(text: message.content)
                                );
                              }
                          ),
                        ],
                        blurSize: 0.0,
                        menuOffset: 10.0,
                        bottomOffsetHeight:
                        80.0,
                        menuBoxDecoration:
                        const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15.0))
                        ),
                        child: Container(
                          constraints:
                          BoxConstraints(maxWidth: screenWidth * 0.55),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: colorPrimaryBlue,
                            borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(24),
                                topRight: Radius.circular(isPreviousSameDateTime ? 24 : 2),
                                bottomLeft: const Radius.circular(24),
                                bottomRight: const Radius.circular(24)
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildReply(index,message, true, (index){
                                onReplySelect(index);
                              }),
                              Container(
                                padding: const EdgeInsets.only(bottom: 2),
                                constraints: BoxConstraints(
                                  maxWidth: screenWidth * 0.55,
                                ),
                                child: WidgetChatroomMessageText(
                                  message: message.content,
                                  color: Colors.white,
                                  colorMention: const Color(0xFFD9E8FF),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          Stack(
            children: [
              Container(
                alignment: Alignment.topRight,
                child: buildAttachment(context, state, message, screenWidth,),
              ),
              Container(
                  alignment: Alignment.topRight,
                  margin: const EdgeInsets.only(top: 4),
                  child: buildImageAttachments(context, message, listMessages, screenWidth,)),
            ],
          ),
        ],
      ),
    );
  }
}
