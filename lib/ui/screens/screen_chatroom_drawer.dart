
import 'package:artrooms/beans/bean_message.dart';
import 'package:artrooms/beans/bean_notice.dart';
import 'package:artrooms/modules/module_messages.dart';
import 'package:artrooms/modules/module_notices.dart';
import 'package:artrooms/ui/screens/screen_chatroom_file.dart';
import 'package:artrooms/ui/screens/screen_chatroom_photo.dart';
import 'package:artrooms/ui/screens/screen_chats.dart';
import 'package:artrooms/ui/screens/screen_memo.dart';
import 'package:artrooms/ui/screens/screen_notices.dart';
import 'package:artrooms/ui/screens/screen_notifications_sounds.dart';
import 'package:flutter/material.dart';
import 'package:sendbird_sdk/core/models/user.dart';

import '../../beans/bean_chat.dart';
import '../../main.dart';
import '../theme/theme_colors.dart';
import '../widgets/widget_chat_drawer_attachments.dart';
import '../widgets/widget_chat_drawer_members.dart';
import '../widgets/widget_loader.dart';


class ScreenChatroomDrawer extends StatefulWidget {

  final DataChat dataChat;

  const ScreenChatroomDrawer({super.key, required this.dataChat});

  @override
  State<StatefulWidget> createState() {
    return _ScreenChatroomDrawerState();
  }

}

class _ScreenChatroomDrawerState extends State<ScreenChatroomDrawer> {

  bool _isLoading = true;
  DataNotice _dataNotice = DataNotice();
  final ModuleNotice moduleNotice = ModuleNotice();
  final TextEditingController _memoController = TextEditingController();
  final TextEditingController _noticeController = TextEditingController();

  List<User> _listMembers = [];
  List<DataMessage> _listAttachmentsImages = [];
  late final ModuleMessages _moduleMessages;

  @override
  void initState() {
    super.initState();
    _moduleMessages = ModuleMessages(widget.dataChat.id);
    _loadMemo();
    _loadNotice();
    _loadMembers();
    _loadAttachments();
  }

  @override
  void dispose() {
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
        actions: [
          Container(
            height: 24.0,
            width: 24.0,
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            padding: const EdgeInsets.all(4.0),
            decoration: const BoxDecoration(
                color: colorMainGrey200,
                shape: BoxShape.circle
            ),
            child: InkWell(
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
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
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
                                  placeholder: widget.dataChat.isArtrooms ? 'assets/images/chats/chat_artrooms.png' : 'assets/images/chats/placeholder_chat.png',
                                  image: widget.dataChat.profilePictureUrl,
                                  fit: BoxFit.cover,
                                  fadeInDuration: const Duration(milliseconds: 100),
                                  fadeOutDuration: const Duration(milliseconds: 100),
                                  imageErrorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      widget.dataChat.isArtrooms ? 'assets/images/chats/chat_artrooms.png' : 'assets/images/chats/placeholder_chat.png',
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
                                )
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
                              child: const Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '주중피드백',
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
                                          '간단히 가능',
                                          style: TextStyle(
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
                                  SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('수업상담',
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
                                        '불가능',
                                        style: TextStyle(
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
                                  SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('채팅가능시간',
                                        style: TextStyle(
                                          color: colorMainGrey400,
                                          fontSize: 14,
                                          fontFamily: 'SUIT',
                                          fontWeight: FontWeight.w400,
                                          height: 0,
                                          letterSpacing: -0.28,
                                        ),
                                      ),
                                      Text('월 화 수',
                                        style: TextStyle(
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
                                  SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('평균응답시간',
                                        style: TextStyle(
                                          color: colorMainGrey400,
                                          fontSize: 14,
                                          fontFamily: 'SUIT',
                                          fontWeight: FontWeight.w400,
                                          height: 0,
                                          letterSpacing: -0.28,
                                        ),
                                      ),
                                      Text(' 11시~20시',
                                        style: TextStyle(
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
                                  SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('평균응답시간',
                                        style: TextStyle(
                                          color: colorMainGrey400,
                                          fontSize: 14,
                                          fontFamily: 'SUIT',
                                          fontWeight: FontWeight.w400,
                                          height: 0,
                                          letterSpacing: -0.28,
                                        ),
                                      ),
                                      Text('하루 이내',
                                        style: TextStyle(
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
                              )
                          ),
                        ),
                        const SizedBox(height: 8),
                        Column(
                          children:[
                            ListTile(
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
                                  return ScreenMemo(dataChat: widget.dataChat,);
                                }));
                                _loadMemo();
                              },
                            ),
                            Container(
                              height: 82,
                              margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
                              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 0.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(color: const Color(0xFFF3F3F3), width: 1.0,),
                              ),
                              child: TextFormField(
                                controller: _memoController,
                                decoration: InputDecoration(
                                  hintText: '메모가 없습니다.',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                                minLines: 2,
                                maxLines: 2,
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
                            ListTile(
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
                            Container(
                              height: 82,
                              margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
                              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 0.0),
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
                                ),
                                minLines: 2,
                                maxLines: 2,
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
                                ListTile(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0.0),
                                  title: const Text(
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
                                  trailing: const Icon(
                                    Icons.chevron_right,
                                    color: Colors.black,
                                    size: 20,
                                  ),
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                                      return ScreenChatroomPhoto(dataChat: widget.dataChat,);
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
                            ListTile(
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
                                  return ScreenChatroomFile(dataChat: widget.dataChat,);
                                }));
                              },
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
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
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
                              icon: Image.asset('assets/images/icons/icon_forward.png', width: 24, height: 24, color: const Color(0xFFD9D9D9),),
                              onPressed: () {
                                _onClickOption1(context);
                              }
                          ),
                          IconButton(
                              icon: Image.asset('assets/images/icons/icon_bell.png', width: 24, height: 24, color: const Color(0xFFD9D9D9),),
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) {
                                  return const ScreenNotificationsSounds();
                                }));
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
                visible: _isLoading,
                child: const WidgetLoaderPage()
            ),
          ],
        ),
      ),
    );
  }

  void _onClickOption1(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: const BoxDecoration(
                      color: colorMainGrey200,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.close,
                        size: 16,
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.all(4),
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  '채팅방 나가기',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                const Text(
                  '대화 내용이 모두 삭제됩니다.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: () {
                    moduleSendBird.leaveChannel(widget.dataChat.id);
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
                      return const ScreenChats();
                    }));
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: colorPrimaryBlue,
                    backgroundColor: colorPrimaryBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text(
                    '확인',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _loadMemo() {
    setState(() {
      _memoController.text = dbStore.getMemo(widget.dataChat).replaceAll("\n\n", "");
    });
  }

  void _loadNotice() {

    moduleNotice.getNotice(widget.dataChat.id).then((DataNotice notice) {

      setState(() {
        _dataNotice = notice;
        _noticeController.text = _dataNotice.notice.replaceAll("\n\n", "");
      });

    }).catchError((e) {

    }).whenComplete(() {

      setState(() {
        _isLoading = false;
      });

    });

  }

  Future<void> _loadMembers() async {
    List<User> members = await moduleSendBird.getGroupChannelMembers(widget.dataChat.id);
    setState(() {
      _listMembers = members;
    });
  }

  void _loadAttachments() async {
    List<DataMessage> attachmentsImages = await _moduleMessages.fetchAttachmentsImages();

    setState(() {
      _listAttachmentsImages = attachmentsImages;
    });
  }

}
