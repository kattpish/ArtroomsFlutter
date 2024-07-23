
import 'dart:ui';

import 'package:artrooms/beans/bean_chatting_artist_profile.dart';
import 'package:artrooms/beans/bean_memo.dart';
import 'package:artrooms/beans/bean_message.dart';
import 'package:artrooms/beans/bean_notice.dart';
import 'package:artrooms/modules/module_messages.dart';
import 'package:artrooms/modules/module_notices.dart';
import 'package:artrooms/ui/screens/screen_chatroom_files.dart';
import 'package:artrooms/ui/screens/screen_chatroom_photos.dart';
import 'package:artrooms/ui/screens/screen_memo.dart';
import 'package:artrooms/ui/screens/screen_notices.dart';
import 'package:flutter/material.dart';
import 'package:sendbird_sdk/core/models/user.dart';
import '../../beans/bean_chat.dart';
import '../../listeners/scroll_bouncing_physics.dart';
import '../../main.dart';
import '../../modules/module_memo.dart';
import '../theme/theme_colors.dart';
import '../widgets/widget_chat_drawer_attachments.dart';
import '../widgets/widget_chat_drawer_exit.dart';
import '../widgets/widget_chat_drawer_members.dart';
import '../widgets/widget_loader.dart';
import '../widgets/widget_ui_notify.dart';


class ScreenChatroomDrawer extends StatefulWidget {

  final DataChat dataChat;
  final VoidCallback onExit;

  const ScreenChatroomDrawer({super.key, required this.dataChat, required this.onExit});

  @override
  State<StatefulWidget> createState() {
    return _ScreenChatroomDrawerState();
  }

}

class _ScreenChatroomDrawerState extends State<ScreenChatroomDrawer> {

  int _loaded = 0;
  bool _isLoadingArtist = true;
  final ModuleNotice moduleNotice = ModuleNotice();
  final TextEditingController _memoController = TextEditingController();
  final TextEditingController _noticeController = TextEditingController();

  List<User> _listMembers = [];
  List<DataMessage> _listAttachmentsImages = [];
  late final ModuleMessages _moduleMessages;
  ArtistProfile _artistProfile = ArtistProfile();
  DataMemo _dataMemo = DataMemo();
  final ModuleMemo _moduleMemo = ModuleMemo();
  DataNotice _dataNotice = DataNotice();

  @override
  void initState() {
    super.initState();
    _moduleMessages = ModuleMessages(widget.dataChat);
    _doLoadMemo();
    _doLoadNotice();
    _doLoadMembers();
    _doLoadAttachments();
  }

  @override
  void dispose() {
    removeState(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          '채팅방 서랍',
          style: TextStyle(
            color: colorMainGrey900,
            fontSize: 18,
            fontFamily: 'SUIT',
            fontWeight: FontWeight.w700,
            height: 0,
            letterSpacing: -0.36,
          ),
        ),
        toolbarHeight: 60,
        leadingWidth: 0,
        leading: const SizedBox.shrink(),
        actions: [
          Container(
            height: 24.0,
            width: 24.0,
            margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
            padding: const EdgeInsets.all(4.0),
            decoration: const BoxDecoration(
                color: colorMainGrey200,
                shape: BoxShape.circle
            ),
            child: InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 16,
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          )
        ],
        elevation: 0.2,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
      ),
      body: WidgetUiNotify(
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: ScrollConfiguration(
                      behavior: scrollBehavior,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Container(
                                  width: 64,
                                  height: 64,
                                  margin: const EdgeInsets.only(left: 16.0),
                                  clipBehavior: Clip.antiAlias,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: CircleAvatar(
                                    radius: 32,
                                    child: FadeInImage.assetNetwork(
                                      placeholder: widget.dataChat.isArtrooms ? 'assets/images/chats/chat_artrooms.png' : 'assets/images/chats/placeholder_photo.png',
                                      image: widget.dataChat.profilePictureUrl,
                                      fit: BoxFit.cover,
                                      fadeInDuration: const Duration(milliseconds: 100),
                                      fadeOutDuration: const Duration(milliseconds: 100),
                                      imageErrorBuilder: (context, error, stackTrace) {
                                        return Image.asset(
                                          widget.dataChat.isArtrooms ? 'assets/images/chats/chat_artrooms.png' : 'assets/images/chats/placeholder_photo.png',
                                          fit: BoxFit.cover,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.dataChat.name,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color: colorMainGrey900,
                                        fontWeight: FontWeight.w800,
                                        fontFamily: 'SUIT',
                                        height: 0,
                                        letterSpacing: -0.36,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      widget.dataChat.nameKr,
                                      style: const TextStyle(
                                        color: Color(0xFF565656),
                                        fontSize: 14,
                                        fontFamily: 'SUIT',
                                        fontWeight: FontWeight.w600,
                                        height: 0,
                                        letterSpacing: -0.28,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Visibility(
                              visible: !widget.dataChat.isArtrooms,
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                                padding: const EdgeInsets.all(20.0),
                                decoration: BoxDecoration(
                                  color: colorMainGrey100,
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                child:  Stack(
                                  children: [
                                    Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              '주중 피드백',
                                              style: TextStyle(
                                                color: colorMainGrey400,
                                                fontSize: 14,
                                                fontFamily: 'SUIT',
                                                fontWeight: FontWeight.w400,
                                                height: 0,
                                                letterSpacing: -0.28,
                                              ),
                                            ),
                                            Text(
                                                _artistProfile.feedback.isNotEmpty ? _artistProfile.feedback : '-',
                                                style: const TextStyle(
                                                  color: colorMainGrey800,
                                                  fontSize: 14,
                                                  fontFamily: 'SUIT',
                                                  fontWeight: FontWeight.w400,
                                                  height: 0,
                                                  letterSpacing: -0.28,
                                                )
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              '수업상담',
                                              style: TextStyle(
                                                color: colorMainGrey400,
                                                fontSize: 14,
                                                fontFamily: 'SUIT',
                                                fontWeight: FontWeight.w400,
                                                height: 0,
                                                letterSpacing: -0.28,
                                              ),
                                            ),
                                            Text(
                                              _artistProfile.classAdvice.isNotEmpty ? _artistProfile.classAdvice : '-',
                                              style: const TextStyle(
                                                color: colorMainGrey800,
                                                fontSize: 14,
                                                fontFamily: 'SUIT',
                                                fontWeight: FontWeight.w400,
                                                height: 0,
                                                letterSpacing: -0.28,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              '채팅 가능 요일',
                                              style: TextStyle(
                                                color: colorMainGrey400,
                                                fontSize: 14,
                                                fontFamily: 'SUIT',
                                                fontWeight: FontWeight.w400,
                                                height: 0,
                                                letterSpacing: -0.28,
                                              ),
                                            ),
                                            Text(
                                              _artistProfile.ableDay.isNotEmpty ? _artistProfile.ableDay : '-',
                                              style: const TextStyle(
                                                color: colorMainGrey800,
                                                fontSize: 14,
                                                fontFamily: 'SUIT',
                                                fontWeight: FontWeight.w400,
                                                height: 0,
                                                letterSpacing: -0.28,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              '채팅 가능 시간',
                                              style: TextStyle(
                                                color: colorMainGrey400,
                                                fontSize: 14,
                                                fontFamily: 'SUIT',
                                                fontWeight: FontWeight.w400,
                                                height: 0,
                                                letterSpacing: -0.28,
                                              ),
                                            ),
                                            Text(
                                              _artistProfile.ableTime.isNotEmpty ? _artistProfile.ableTime : '-',
                                              style: const TextStyle(
                                                color: colorMainGrey800,
                                                fontSize: 14,
                                                fontFamily: 'SUIT',
                                                fontWeight: FontWeight.w400,
                                                height: 0,
                                                letterSpacing: -0.28,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              '평균 응답 시간',
                                              style: TextStyle(
                                                color: colorMainGrey400,
                                                fontSize: 14,
                                                fontFamily: 'SUIT',
                                                fontWeight: FontWeight.w400,
                                                height: 0,
                                                letterSpacing: -0.28,
                                              ),
                                            ),
                                            Text(
                                              _artistProfile.replyTime.isNotEmpty ? _artistProfile.replyTime : '-',
                                              style: const TextStyle(
                                                color: colorMainGrey800,
                                                fontSize: 14,
                                                fontFamily: 'SUIT',
                                                fontWeight: FontWeight.w400,
                                                height: 0,
                                                letterSpacing: -0.28,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Visibility(
                                      visible: _loaded > 3 && _isLoadingArtist,
                                      child: const Center(
                                        child: SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            color: Color(0xFF6A79FF),
                                            strokeWidth: 3,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Column(
                              children:[
                                GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  child: ListTile(
                                    title: const Text(
                                      '메모',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: colorMainGrey900,
                                        fontFamily: 'SUIT',
                                        fontWeight: FontWeight.w600,
                                        height: 0,
                                        letterSpacing: -0.32,
                                      ),
                                    ),
                                    trailing: const Icon(
                                      Icons.chevron_right,
                                      color: Colors.black,
                                      size: 20,
                                    ),
                                    onTap: () async {
                                      await Navigator.push(context, MaterialPageRoute(builder: (context) {
                                        return ScreenMemo(dataChat: widget.dataChat, dataMemo: _dataMemo, onUpdateMemo: (dataMemo) {
                                          setState(() {
                                            _dataMemo = dataMemo;
                                          });
                                          dbStore.saveMemo(widget.dataChat, _dataMemo.memo);
                                          _doLoadMemo();
                                        },);
                                      }));
                                    },
                                  ),
                                ),
                                Container(
                                  height: 82,
                                  margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
                                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(color: const Color(0xFFF3F3F3), width: 1.0,),
                                  ),
                                  child: TextFormField(
                                    controller: _memoController,
                                    decoration: InputDecoration(
                                      hintText: _dataMemo.memo,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8.0),
                                        borderSide: BorderSide.none,
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0),
                                    ),
                                    minLines: 4,
                                    maxLines: null,
                                    readOnly: true,
                                    keyboardType: TextInputType.multiline,
                                    style: const TextStyle(
                                      color: colorMainGrey900,
                                      fontSize: 16,
                                      fontFamily: 'SUIT',
                                      fontWeight: FontWeight.w300,
                                      letterSpacing: -0.32,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 16),
                            Column(
                              children:[
                                GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  child: ListTile(
                                    title: const Text(
                                      '공지',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: colorMainGrey900,
                                        fontFamily: 'SUIT',
                                        fontWeight: FontWeight.w600,
                                        height: 0,
                                        letterSpacing: -0.32,
                                      ),
                                    ),
                                    trailing: const Icon(
                                      Icons.chevron_right,
                                      color: Colors.black,
                                      size: 20,
                                    ),
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                                        return ScreenNotices(dataChat: widget.dataChat,);
                                      }));
                                    },
                                  ),
                                ),
                                Container(
                                  height: 82,
                                  margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
                                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(color: const Color(0xFFF3F3F3), width: 1.0,),
                                  ),
                                  child: TextFormField(
                                    controller: _noticeController,
                                    decoration: InputDecoration(
                                      hintText: '공지가 없습니다.',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                        borderSide: BorderSide.none,
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0),
                                    ),
                                    minLines: 4,
                                    maxLines: null,
                                    readOnly: true,
                                    keyboardType: TextInputType.multiline,
                                    style: const TextStyle(
                                      color: Color(0xFF979797),
                                      fontSize: 16,
                                      fontFamily: 'SUIT',
                                      fontWeight: FontWeight.w300,
                                      letterSpacing: -0.32,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 16),
                            Column(
                              children:[
                                Column(
                                  children: [
                                    GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      child: const ListTile(
                                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0.0),
                                        title: Text(
                                          '이미지',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: colorMainGrey900,
                                            fontFamily: 'SUIT',
                                            fontWeight: FontWeight.w600,
                                            height: 0,
                                            letterSpacing: -0.32,
                                          ),
                                        ),
                                        trailing: Icon(
                                          Icons.chevron_right,
                                          color: Colors.black,
                                          size: 20,
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                                          return ScreenChatroomPhotos(dataChat: widget.dataChat,);
                                        }));
                                      },
                                    ),
                                    Container(
                                        alignment: Alignment.topLeft,
                                        padding: const EdgeInsets.symmetric(horizontal: 16),
                                        child: widgetChatDrawerAttachments(context, _listAttachmentsImages)
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0.0),
                                    title: const Text(
                                      '파일',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: colorMainGrey900,
                                        fontFamily: 'SUIT',
                                        fontWeight: FontWeight.w600,
                                        height: 0,
                                        letterSpacing: -0.32,
                                      ),
                                    ),
                                    trailing: const Icon(
                                      Icons.chevron_right,
                                      color: Colors.black,
                                      size: 20,
                                    ),
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                                        return ScreenChatroomFiles(dataChat: widget.dataChat,);
                                      }));
                                    },
                                  ),
                                ),
                                const Divider(
                                  thickness: 2,
                                  color: colorMainGrey150,
                                ),
                                Column(
                                  children: [
                                    ListTile(
                                      title: const Text(
                                        '대화상대',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: colorMainGrey900,
                                          fontFamily: 'SUIT',
                                          fontWeight: FontWeight.w600,
                                          height: 0,
                                          letterSpacing: -0.32,
                                        ),
                                      ),
                                      onTap: () {

                                      },
                                    ),
                                    Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 16),
                                        child: widgetChatDrawerMembers(context, _listMembers)
                                    ),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 16, left: 4, right: 4),
                    child: Column(
                      children: [
                        const Divider(
                          thickness: 2,
                          color: colorMainGrey150,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                                icon: Image.asset('assets/images/icons/icon_forward.png', width: 24, height: 24, color: const Color(0xFF6A79FF),),
                                onPressed: () {
                                  widgetChatDrawerExit(context, widget.dataChat,
                                      onExit: () {
                                        _doExitChat();
                                      }
                                  );
                                }
                            ),
                            IconButton(
                                icon: Image.asset('assets/images/icons/icon_bell.png',
                                  width: 24, height: 24,
                                  color: widget.dataChat.isNotification ? const Color(0xFF6A79FF) : colorMainGrey250,
                                ),
                                onPressed: () {
                                  _doToggleNotification(context, widget.dataChat);
                                }
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Visibility(
                visible: _loaded < 3,
                child: const WidgetLoader(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _doLoadMemo() {
    setState(() {
      _memoController.text = dbStore.getMemo(widget.dataChat).replaceAll("\n\n", "");
      _dataMemo.memo = _memoController.text;
      _loaded++;
    });
  }

  void _doLoadNotice() {

    moduleNotice.getNotice(widget.dataChat.id).then((DataNotice notice) {

      setState(() {
        _dataNotice = notice;
        _noticeController.text = _dataNotice.notice.replaceAll("\n\n", "");
      });

    }).catchError((e) {

    }).whenComplete(() {
      setState(() {
        _loaded++;
      });
      _loadMemoAndArtistProfile();
    });

  }

  Future<void> _doLoadMembers() async {
    List<User> members = await moduleSendBird.getGroupChannelMembers(widget.dataChat.id);
    setState(() {
      _listMembers = members;
      _loaded++;
    });
  }

  void _doLoadAttachments() async {
    List<DataMessage> attachmentsImages = await _moduleMessages.fetchAttachmentsImages();
    setState(() {
      _listAttachmentsImages = attachmentsImages;
      _loaded++;
    });
  }

  void _doExitChat() {
    moduleSendBird.leaveChannel(widget.dataChat.id);
    widget.onExit();
    Navigator.of(context).pop();
  }

  void _doToggleNotification(BuildContext context, DataChat dataChat) {
    dbStore.toggleNotificationChat(dataChat);
    setState(() {
      dataChat.isNotification = dbStore.isNotificationChat(dataChat);
    });
  }

  void _loadMemoAndArtistProfile() async{
    _artistProfile = await moduleNotice.getArtistProfileInfo(artistId: _dataNotice.artistId);
    DataMemo? dataMemo = await _moduleMemo.getMemo(url: _dataNotice.url);
    if(dataMemo != null) {
      _dataMemo = dataMemo;
    }
    setState(() {
      _isLoadingArtist = false;
      _loaded++;
    });
  }

}
