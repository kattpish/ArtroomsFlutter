import 'package:artrooms/beans/bean_focusedMenuItem.dart';
import 'package:artrooms/beans/bean_message.dart';
import 'package:artrooms/ui/widgets/widget_chatroom_message_attachment_file.dart';
import 'package:artrooms/ui/widgets/widget_chatroom_message_attachment_photos.dart';
import 'package:artrooms/ui/widgets/widget_chatroom_message_reply.dart';
import 'package:artrooms/ui/widgets/widget_chatroom_message_text.dart';
import 'package:artrooms/ui/widgets/widget_focused_menu_holder.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/utils_media.dart';
import '../theme/theme_colors.dart';

class ChatroomMessageOther extends StatefulWidget {
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

  const ChatroomMessageOther(
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
  State<ChatroomMessageOther> createState() => _ChatroomMessageOtherState();
}

class _ChatroomMessageOtherState extends State<ChatroomMessageOther> {
  Color activeColor= colorMainGrey200;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 0,
          bottom: widget.isLast ? 9 : (widget.isNextSame && widget.isNextSameTime ? 0 : 9)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!widget.isPreviousSame || !widget.isPreviousSameDateTime)
                InkWell(
                  onTap: () {},
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor: widget.isPreviousSame
                          ? Colors.transparent
                          : colorMainGrey200,
                      child: CachedNetworkImage(
                        imageUrl: widget.message.profilePictureUrl,
                        cacheManager: customCacheManager,
                        fit: BoxFit.cover,
                        fadeInDuration: const Duration(milliseconds: 100),
                        fadeOutDuration: const Duration(milliseconds: 100),
                        placeholder: (context, url) {
                          return Image.asset(
                            widget.message.isArtrooms
                                ? 'assets/images/chats/chat_artrooms.png'
                                : 'assets/images/chats/placeholder_photo.png',
                            fit: BoxFit.cover,
                          );
                        },
                        errorWidget: (context, url, error) {
                          return Image.asset(
                            widget.message.isArtrooms
                                ? 'assets/images/chats/chat_artrooms.png'
                                : 'assets/images/chats/placeholder_photo.png',
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                  ),
                )
              else
                const SizedBox(width: 34),
              const SizedBox(width: 6),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                        left: widget.isPreviousSame && widget.isPreviousSameDateTime ? 0 : 4,
                        top: widget.isPreviousSame & widget.isPreviousSameDateTime ? 0 : 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!widget.isPreviousSame || !widget.isPreviousSameDateTime)
                          SizedBox(
                            child: Text(
                              widget.message.getName(),
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
                        const SizedBox(height: 8),
                        if (widget.message.content.isNotEmpty)
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
                                      await Clipboard.setData(
                                          ClipboardData(text: widget.message.content));
                                    })
                              ],
                              blurSize: 0.0,
                              menuOffset: 10.0,
                              bottomOffsetHeight: 80.0,
                              menuBoxDecoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.0))),
                             activeColor: colorMainGrey400,
                              child: Container(
                                constraints: const BoxConstraints(
                                    minHeight: 40, minWidth: 46),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(
                                        widget.isPreviousSameDateTime ? 20 : 2),
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
                                        maxWidth: widget.screenWidth * 0.55,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          buildReply(widget.index, widget.message, false,
                                              (index) {
                                            widget.onReplySelect(index);
                                          }),
                                          WidgetChatroomMessageText(
                                            message: widget.message.content,
                                            color: const Color(0xFF1F1F1F),
                                            colorMention: const Color(0xFF6385FF),
                                          ),
                                        ],
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
                  if (((widget.isPreviousSameDateTime && !widget.isNextSameTime) ||
                          (!widget.isPreviousSameDateTime && !widget.isNextSameTime)) &&
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
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ],
          ),
          Container(
            alignment: Alignment.topLeft,
            margin: const EdgeInsets.only(left: 38),
            child: buildAttachment(
              context,
              widget.state,
              widget.message,
              widget.screenWidth,
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            child: buildImageAttachments(
                context, widget.message, widget.listMessages, widget.screenWidth),
          ),
        ],
      ),
    );
  }

  void isActive(){
    setState(() {
      activeColor = colorMainGrey600;
    });
  }
}
