import 'package:artrooms/beans/bean_focusedMenuItem.dart';
import 'package:artrooms/beans/bean_message.dart';
import 'package:artrooms/ui/widgets/widget_chatroom_message_attachment_file.dart';
import 'package:artrooms/ui/widgets/widget_chatroom_message_attachment_photos.dart';
import 'package:artrooms/ui/widgets/widget_chatroom_message_reply.dart';
import 'package:artrooms/ui/widgets/widget_chatroom_message_text.dart';
import 'package:artrooms/ui/widgets/widget_focused_menu_holder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/theme_colors.dart';

class ChatroomMessageMe extends StatefulWidget {
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

  const ChatroomMessageMe(
      {super.key,
      required this.index,
      required this.state,
      required this.message,
      required this.listMessages,
      required this.isLast,
      required this.isPreviousSame,
      required this.isNextSame,
      required this.isPreviousSameDateTime,
      required this.isNextSameTime,
      required this.screenWidth,
      required this.onReplyClick,
      required this.onReplySelect});

  @override
  State<ChatroomMessageMe> createState() => _ChatroomMessageMeState();
}

class _ChatroomMessageMeState extends State<ChatroomMessageMe> {
  Color activeColor = colorPrimaryBlue;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          left: 16, right: 16, top: 0, bottom: widget.isLast ? 9 : 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (widget.message.content.isNotEmpty)
            Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 1.2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (((widget.isPreviousSameDateTime &&
                                  !widget.isNextSameTime) ||
                              (!widget.isPreviousSameDateTime &&
                                  !widget.isNextSameTime)) &&
                          widget.message.content.isNotEmpty)
                        Text(
                          widget.message.getTime(),
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
                      Container(
                        decoration: BoxDecoration(
                          color: activeColor,
                          borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(24),
                              topRight: Radius.circular(
                                  widget.isPreviousSameDateTime ? 24 : 2),
                              bottomLeft: const Radius.circular(24),
                              bottomRight: const Radius.circular(24)),
                        ),
                        child: FocusedMenuHolder(
                          onPressed: () {},
                          menuWidth: widget.screenWidth / 2,
                          menuItems: [
                            FocusedMenuItem(
                                trailingIcon: const ImageIcon(AssetImage(
                                    'assets/images/icons/icon_reply.png')),
                                title: const Text("답장"),
                                onPressed: () {
                                  widget.onReplyClick();
                                }),
                            FocusedMenuItem(
                                trailingIcon: const ImageIcon(AssetImage(
                                    'assets/images/icons/icon_copy.png')),
                                title: const Text("복사"),
                                onPressed: () async {
                                  await Clipboard.setData(ClipboardData(
                                      text: widget.message.content));
                                }),
                          ],
                          blurSize: 0.0,
                          menuOffset: 10.0,
                          bottomOffsetHeight: 80.0,
                          menuBoxDecoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0))),
                          activeColor: colorPrimaryBlue800,
                          child: Container(
                            constraints: BoxConstraints(
                                maxWidth: widget.screenWidth * 0.55),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(24),
                                  topRight: Radius.circular(
                                      widget.isPreviousSameDateTime ? 24 : 2),
                                  bottomLeft: const Radius.circular(24),
                                  bottomRight: const Radius.circular(24)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                buildReply(widget.index, widget.message, true,
                                    (index) {
                                  widget.onReplySelect(index);
                                }),
                                Container(
                                  padding: const EdgeInsets.only(bottom: 2),
                                  constraints: BoxConstraints(
                                    maxWidth: widget.screenWidth * 0.55,
                                  ),
                                  child: WidgetChatroomMessageText(
                                    message: widget.message.content,
                                    color: Colors.white,
                                    colorMention: const Color(0xFFD9E8FF),
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
              ],
            ),
          Stack(
            children: [
              Container(
                alignment: Alignment.topRight,
                child: buildAttachment(
                  context,
                  widget.state,
                  widget.message,
                  widget.screenWidth,
                ),
              ),
              Container(
                  alignment: Alignment.topRight,
                  margin: const EdgeInsets.only(top: 4),
                  child: buildImageAttachments(
                    context,
                    widget.message,
                    widget.listMessages,
                    widget.screenWidth,
                  )),
            ],
          ),
        ],
      ),
    );
  }

}
