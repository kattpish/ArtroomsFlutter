
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
import 'package:artrooms/ui/widgets/widget_media.dart';
import 'package:flutter/material.dart';
import 'package:sendbird_sdk/core/models/user.dart';

import '../../beans/bean_chat.dart';
import '../../main.dart';
import '../theme/theme_colors.dart';
import '../widgets/widget_loader.dart';


class MyScreenChatroomDrawer extends StatefulWidget {

  final MyChat myChat;

  const MyScreenChatroomDrawer({super.key, required this.myChat});

  @override
  State<StatefulWidget> createState() {
    return _MyScreenChatroomDrawerState();
  }

}

class _MyScreenChatroomDrawerState extends State<MyScreenChatroomDrawer> {

  bool _isLoading = true;
  DataNotice dataNotice = DataNotice();
  final ModuleNotice moduleNotice = ModuleNotice();
  final TextEditingController _memoController = TextEditingController();
  final TextEditingController _noticeController = TextEditingController();

  late final ModuleMessages moduleMessages;

  List<User> listMembers = [];
  List<MyMessage> listAttachmentsImages = [];

  @override
  void initState() {
    super.initState();
    moduleMessages = ModuleMessages(widget.myChat.id);
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
        elevation: 0.5,
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
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
                                placeholder: 'assets/images/profile/profile_2.png',
                                image: widget.myChat.profilePictureUrl,
                                fit: BoxFit.cover,
                                fadeInDuration: const Duration(milliseconds: 100),
                                fadeOutDuration: const Duration(milliseconds: 100),
                                imageErrorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    'assets/images/profile/profile_2.png',
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
                                widget.myChat.name,
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
                                widget.myChat.role,
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
                      const SizedBox(height: 12),
                      Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16.0),
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
                      const SizedBox(height: 20),
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
                                return MyScreenMemo(myChat: widget.myChat,);
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
                                return MyScreenNotices(myChat: widget.myChat,);
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
                                    return MyScreenChatroomPhoto(myChat: widget.myChat,);
                                  }));
                                },
                              ),
                              Container(
                                  alignment: Alignment.topLeft,
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: buildAttachmentsImages(context, listAttachmentsImages)
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
                                return MyScreenChatroomFile(myChat: widget.myChat,);
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
                                  child: buildMembers(context, listMembers)
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
                margin: const EdgeInsets.only(bottom: 32),
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
                                return const MyScreenNotificationsSounds();
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
              child: const MyLoaderPage()
          ),
        ],
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
                    moduleSendBird.leaveChannel(widget.myChat.id);
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
                      return const MyScreenChats();
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

  Widget buildMembers(BuildContext context, List<User> listMembers) {
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
                      placeholder: 'assets/images/profile/placeholder.png',
                      image: member.profileUrl != null ? member.profileUrl.toString() : "",
                      fit: BoxFit.cover,
                      fadeInDuration: const Duration(milliseconds: 100),
                      fadeOutDuration: const Duration(milliseconds: 100),
                      imageErrorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/images/profile/placeholder.png',
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

  Widget buildAttachmentsImages(BuildContext context, List<MyMessage> listAttachmentsImages) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          for(MyMessage message in listAttachmentsImages)
              Container(
                margin: const EdgeInsets.only(right: 4),
                child: InkWell(
                  onTap: () {
                    viewPhoto(context, imageUrl:message.getImageUrl(), fileName:message.attachmentName);
                  },
                  child: Container(
                    width: 80,
                    height: 80,
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(width: 1, color: Color(0xFFF3F3F3)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: FadeInImage.assetNetwork(
                      placeholder: 'assets/images/profile/placeholder.png',
                      image: message.getImageUrl(),
                      fit: BoxFit.cover,
                      fadeInDuration: const Duration(milliseconds: 100),
                      fadeOutDuration: const Duration(milliseconds: 100),
                      imageErrorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/images/profile/placeholder.png',
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                ),
              ),
        ],
      ),
    );
  }

  void _loadMemo() {
    setState(() {
      _memoController.text = dbStore.getMemo(widget.myChat).replaceAll("\n\n", "");
    });
  }

  void _loadNotice() {

    moduleNotice.getNotice(widget.myChat.id).then((DataNotice notice) {

      setState(() {
        dataNotice = notice;
        _noticeController.text = dataNotice.notice.replaceAll("\n\n", "");
      });

    }).catchError((e) {

    }).whenComplete(() {

      setState(() {
        _isLoading = false;
      });

    });

  }

  Future<void> _loadMembers() async {
    List<User> members = await moduleSendBird.getGroupChannelMembers(widget.myChat.id);

    setState(() {
      listMembers = members;
    });
  }

  void _loadAttachments() async {
    List<MyMessage> attachmentsImages = await moduleMessages.fetchAttachmentsImages();

    setState(() {
      listAttachmentsImages = attachmentsImages;
    });
  }

}
