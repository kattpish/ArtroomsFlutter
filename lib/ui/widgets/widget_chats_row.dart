import 'package:artrooms/main.dart';
import 'package:artrooms/modules/module_notices.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sendbird_sdk/core/models/member.dart';

import '../../beans/bean_chat.dart';
import '../../utils/utils.dart';
import '../theme/theme_colors.dart';

class WidgetChatRow extends StatefulWidget {
  final BuildContext context;
  final int index;
  final DataChat dataChat;
  final Null Function() onClickOption1;
  final Null Function() onClickOption2;
  final Null Function() onSelectChat;

  const WidgetChatRow({
    Key? key,
    required this.context,
    required this.index,
    required this.dataChat,
    required this.onClickOption1,
    required this.onClickOption2,
    required this.onSelectChat,
  }) : super(key: key);

  @override
  _WidgetChatRowState createState() => _WidgetChatRowState();
}

class _WidgetChatRowState extends State<WidgetChatRow> {
  final myEmail = dbStore.getEmail();
  Member? opponentUser;
  Map<String, dynamic>? opponentProfile;
  String temp = "temp";
  String title = '-';
  String profilePictureUrl = '';

  @override
  void initState() {
    super.initState();
    setTitleAndDescription();
  }

  void getOpponentData() async {
    print('>><><><><><>><>getOpponentData ${widget.dataChat.creator}');
    final creatorUserId = widget.dataChat.creator?.userId;
    if (creatorUserId == null) return;
    ModuleNotice moduleNotice = ModuleNotice();

    opponentProfile =
        await moduleNotice.getArtistProfileInfoByEmail(email: creatorUserId);

    opponentProfile ??=
        await moduleNotice.getAdminProfileByEmail(email: creatorUserId);

    if (opponentProfile == null) return;
    setState(() {
      title = opponentProfile?['name'] ?? widget.dataChat.name;
      profilePictureUrl = opponentProfile?['profilePictureUrl'] ??
          widget.dataChat.profilePictureUrl;
    });
  }

  void setTitleAndDescription() {
    setState(() {
      title = widget.dataChat.name;
      profilePictureUrl = widget.dataChat.profilePictureUrl;
    });
    if (widget.dataChat.groupChannel!.memberCount <= 2) {
      getOpponentData();
    }
    // return;
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: const ValueKey(0),
      closeOnScroll: true,
      groupTag: 0,
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          CustomSlidableAction(
            flex: 1,
            autoClose: false,
            onPressed: (context) async {
              widget.onClickOption1();
              final controller = Slidable.of(context);
              await controller?.close(
                  duration: const Duration(milliseconds: 300));
            },
            backgroundColor: widget.dataChat.isNotification
                ? colorMainGrey200
                : colorMainGrey300,
            foregroundColor: Colors.white,
            child: Image.asset(
              'assets/images/icons/icon_bell.png',
              width: 24,
              height: 24,
              color: widget.dataChat.isNotification
                  ? colorPrimaryPurple
                  : Colors.white,
            ),
          ),
          CustomSlidableAction(
            flex: 1,
            autoClose: false,
            onPressed: (context) async {
              final controller = Slidable.of(context);
              controller?.close(duration: const Duration(milliseconds: 300));
              widget.onClickOption2();
            },
            backgroundColor: colorPrimaryBlue,
            foregroundColor: Colors.white,
            child: Image.asset(
              'assets/images/icons/icon_forward.png',
              width: 24,
              height: 24,
            ),
          ),
        ],
      ),
      child: InkWell(
        splashColor: Colors.transparent,
        child: ListTile(
          leading: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.transparent,
                    child: profilePictureUrl.isNotEmpty
                        ? FadeInImage.assetNetwork(
                            placeholder: widget.dataChat.isArtrooms
                                ? 'assets/images/chats/chat_artrooms.png'
                                : 'assets/images/chats/placeholder_photo.png',
                            image: profilePictureUrl,
                            fit: BoxFit.cover,
                            fadeInDuration: const Duration(milliseconds: 100),
                            fadeOutDuration: const Duration(milliseconds: 100),
                            imageErrorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                widget.dataChat.isArtrooms
                                    ? 'assets/images/chats/chat_artrooms.png'
                                    : 'assets/images/chats/placeholder_photo.png',
                                fit: BoxFit.cover,
                              );
                            },
                          )
                        : SizedBox.shrink(),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: Visibility(
                  visible: !widget.dataChat.isArtrooms,
                  child: Container(
                    padding: const EdgeInsets.all(2.0),
                    margin: const EdgeInsets.all(6.0),
                    decoration: const BoxDecoration(
                      color: colorPrimaryBlue,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.star,
                      size: 10,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          title: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF1F1F1F),
              fontSize: 15,
              fontFamily: 'SUIT',
              fontWeight: FontWeight.w700,
              height: 0,
              letterSpacing: -0.30,
            ),
          ),
          subtitle: Text(
            widget.dataChat.lastMessage.getSummary(),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF6B6B6B),
              fontSize: 13,
              fontFamily: 'SUIT',
              fontWeight: FontWeight.w400,
              height: 0,
              letterSpacing: -0.26,
            ),
          ),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                formatChatDateString(widget.dataChat.date),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF979797),
                  fontSize: 10,
                  fontFamily: 'SUIT',
                  fontWeight: FontWeight.w400,
                  height: 0,
                  letterSpacing: -0.20,
                ),
              ),
              Visibility(
                visible: widget.dataChat.unreadMessages > 0,
                child: Container(
                  margin: const EdgeInsets.only(right: 0),
                  height: 20,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  constraints: const BoxConstraints(minWidth: 20),
                  decoration: const BoxDecoration(
                    color: Color(0xFFe85e3d),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  child: Text(
                    widget.dataChat.unreadMessages >= 100
                        ? '+100'
                        : widget.dataChat.unreadMessages.toString(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontFamily: 'SUIT',
                      fontWeight: FontWeight.w700,
                      height: 0,
                      letterSpacing: -0.24,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          widget.onSelectChat();
        },
      ),
    );
  }
}
