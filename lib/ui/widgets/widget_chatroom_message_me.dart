
import 'package:artrooms/beans/bean_focusedMenuItem.dart';
import 'package:artrooms/ui/widgets/widget_chatroom_message_attachment_file.dart';
import 'package:artrooms/ui/widgets/widget_chatroom_message_attachment_photos.dart';
import 'package:artrooms/ui/widgets/widget_chatroom_message_reply.dart';
import 'package:artrooms/ui/widgets/widget_chatroom_message_text.dart';
import 'package:artrooms/ui/widgets/widget_focused_menu_holder.dart';
import 'package:artrooms/ui/widgets/wigdet_focus_hover.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../beans/bean_message.dart';
import '../theme/theme_colors.dart';


Widget buildMyMessageBubble(
    BuildContext context,
    int index,
    State state,
    DataMessage message,
    List<DataMessage> listMessages,
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
                          color: colorMainGrey150,
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
                            trailingIcon: const ImageIcon(AssetImage('assets/images/icons/icon_reply.png')),
                            title: const Text("답장"),
                            onPressed: () {
                              onReplyClick();
                            }),
                        FocusedMenuItem(
                            trailingIcon: const ImageIcon(AssetImage('assets/images/icons/icon_copy.png')),
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
                      blurBackgroundColor: Colors.transparent,
                      bottomOffsetHeight:
                      80.0,
                      activeColor: colorPrimaryBlue400,
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