
import 'dart:async';

import 'package:artrooms/beans/bean_notice.dart';
import 'package:artrooms/modules/module_notices.dart';
import 'package:artrooms/ui/screens/screen_chatroom_drawer.dart';
import 'package:artrooms/ui/widgets/widget_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../beans/bean_chat.dart';
import '../../beans/bean_file.dart';
import '../../beans/bean_message.dart';
import '../../data/module_datastore.dart';
import '../../modules/module_messages.dart';
import '../../utils/utils.dart';
import '../../utils/utils_screen.dart';
import '../theme/theme_colors.dart';
import '../widgets/widget_media.dart';


class MyScreenChatroom extends StatefulWidget {

  final MyChat chat;
  final double widthRatio;
  final VoidCallback? onBackPressed;

  const MyScreenChatroom({super.key, required this.chat, this.widthRatio = 1.0, this.onBackPressed});

  @override
  State<StatefulWidget> createState() {
    return _MyScreenChatroomState();
  }

}

class _MyScreenChatroomState extends State<MyScreenChatroom> with SingleTickerProviderStateMixin {

  bool _isLoading = true;
  bool _isLoadMore = false;
  bool _isButtonDisabled = true;
  bool _isHideNotice = false;
  bool _isExpandNotice = false;
  bool _showAttachment = false;
  bool _showAttachmentFull = false;
  bool _listReachedTop = false;
  bool _listReachedBottom = false;

  final List<MyMessage> listMessages = [];
  final ScrollController _scrollController = ScrollController();
  final ScrollController _scrollControllerAttachment1 = ScrollController();
  final ScrollController _scrollControllerAttachment2 = ScrollController();
  final TextEditingController _messageController = TextEditingController();

  late final ModuleMessages moduleMessages;
  ModuleNotice moduleNotice = ModuleNotice();
  DBStore dbStore = DBStore();
  DataNotice dataNotice = DataNotice();

  double _boxHeight = 320.0;
  final double _boxHeightMin = 320.0;
  double _dragStartY = 0.0;
  double screenWidth = 0;
  double screenHeight = 0;

  int crossAxisCount = 2;
  double crossAxisSpacing = 8;
  double mainAxisSpacing = 8;

  Timer? _scrollTimer;
  String _currentDate = '';
  bool _showDateContainer = false;
  Map<int, GlobalKey> itemKeys = {};

  late Widget attachmentPicker;

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _messageController.addListener(_checkIfButtonShouldBeEnabled);
    _scrollController.addListener(_onScroll);
    _scrollControllerAttachment1.addListener(_scrollListener);
    _scrollControllerAttachment2.addListener(_scrollListener);
    moduleMessages = ModuleMessages(widget.chat.id);
    _loadMessages();
    _loadNotice();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    double interval = 0;
    Tween(begin: _boxHeight, end: screenHeight).animate(_animationController).addListener(() {

      if(interval <= 0) {
        interval = (screenHeight - _boxHeight) / 10;
      }

      setState(() {
        if(_boxHeight < screenHeight) {
          _boxHeight += interval;
        }
        if(_boxHeight > screenHeight) {
          _boxHeight = screenHeight;
        }
      });

      if(_boxHeight == screenHeight) {
        _animationController.stop();
      }

    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _scrollControllerAttachment1.dispose();
    _scrollControllerAttachment2.dispose();
    _scrollTimer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    screenWidth = MediaQuery.of(context).size.width * widget.widthRatio;
    screenHeight = MediaQuery.of(context).size.height;
    crossAxisCount = isTablet(context) ? 4 : 2;

    attachmentPicker = _attachmentPicker(context, this);

    return WillPopScope(
      onWillPop: () async {
        if(_showAttachment) {
          setState(() {
            _showAttachment = false;
          });
          return false;
        }else if(_showAttachmentFull) {
          setState(() {
            _showAttachmentFull = false;
          });
          return false;
        }
        if(widget.onBackPressed != null) {
          widget.onBackPressed!.call();
          return false;
        }else {
          return true;
        }
      },
      child: SafeArea(
        child: Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: colorMainGrey250,
                    size: 20,
                  ),
                  onPressed: () {
                    if(widget.onBackPressed != null) {
                      widget.onBackPressed!.call();
                    }else {
                      Navigator.of(context).pop();
                    }
                  },
                ),
                title: Text(
                  widget.chat.name,
                  style: const TextStyle(
                    color: colorMainGrey900,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    fontFamily: 'SUIT',
                    height: 0,
                    letterSpacing: -0.36,
                  ),
                ),
                centerTitle: true,
                elevation: 0.5,
                toolbarHeight: 60,
                backgroundColor: Colors.white,
                actions: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: InkWell(
                      child: Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset(
                            'assets/images/icons/icon_archive.png',
                            width: 24,
                            height: 24,
                          )
                      ),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return MyScreenChatroomDrawer(myChat: widget.chat,);
                        }));
                      },
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.white,
              body: Column(
                children: [
                  Expanded(
                    child: _isLoading
                        ? const MyLoader()
                        : Stack(
                      alignment: AlignmentDirectional.topCenter,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 0),
                          child: listMessages.isNotEmpty ? ListView.builder(
                            controller: _scrollController,
                            itemCount: listMessages.length,
                            reverse: true,
                            itemBuilder: (context, index) {
                              itemKeys[index] = GlobalKey();
                              final message = listMessages[index];
                              final messageNext = index > 0 ? listMessages[index - 1] : MyMessage.empty();
                              final messagePrevious = index < listMessages.length - 1 ? listMessages[index + 1] : MyMessage.empty();
                              final isPreviousSame = messagePrevious.senderId == message.senderId;
                              final isNextSame = messageNext.senderId == message.senderId;
                              final isPreviousDate = messagePrevious.getDate() == message.getDate();
                              final isPreviousSameDateTime = isPreviousSame && messagePrevious.getDateTime() == message.getDateTime();
                              final isNextSameTime = isNextSame && messageNext.getDateTime() == message.getDateTime();
                              return Column(
                                key: itemKeys[index],
                                children: [
                                  Visibility(
                                    visible: !isPreviousDate,
                                    child: Container(
                                      width: 145,
                                      height: 31,
                                      margin: EdgeInsets.only(left: 16, right: 16, top: index == 0 ? 4 : 16, bottom: index == 0 ? 4 : 8),
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                      alignment: Alignment.center,
                                      decoration: ShapeDecoration(
                                        color: const Color(0xFFF9F9F9),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            formatDateLastMessage(message.timestamp),
                                            style: const TextStyle(
                                              color: Color(0xFF7D7D7D),
                                              fontSize: 12,
                                              fontFamily: 'SUIT',
                                              fontWeight: FontWeight.w400,
                                              height: 0,
                                              letterSpacing: -0.24,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: message.isMe
                                        ? _buildMyMessageBubble(message, isPreviousSameDateTime, isNextSameTime)
                                        : _buildOtherMessageBubble(message, isPreviousSame, isNextSame, isPreviousSameDateTime, isNextSameTime),
                                  ),
                                ],
                              );
                            },
                          )
                              : buildNoChats(context),
                        ),
                        Visibility(
                          visible: _isLoadMore,
                          child: Container(
                            width: 12,
                            height: 12,
                            margin: const EdgeInsets.only(top: 2),
                            child: const CircularProgressIndicator(
                              color: Color(0xFF6A79FF),
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                        AnimatedOpacity(
                          opacity: !_isHideNotice && dataNotice.notice.isNotEmpty ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 500),
                          child: buildNoticePin(context),
                        ),
                        AnimatedOpacity(
                          opacity: _showDateContainer ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 500),
                          child: Container(
                            width: 145,
                            height: 31,
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            alignment: Alignment.center,
                            decoration: ShapeDecoration(
                              color: const Color(0xFFF9F9F9),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  _currentDate,
                                  style: const TextStyle(
                                    color: Color(0xFF7D7D7D),
                                    fontSize: 12,
                                    fontFamily: 'SUIT',
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                    letterSpacing: -0.24,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                      visible: _showAttachment,
                      child: _attachmentSelected(context)
                  ),
                  _buildMessageInput(),
                  const SizedBox(height: 8),
                  Visibility(
                    visible: _showAttachment,
                    child: SizedBox(
                        height: _boxHeight,
                        child: attachmentPicker
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: _showAttachmentFull,
              child: Scaffold(
                backgroundColor: Colors.black.withOpacity(0.4),
                body: Container(
                  height: double.infinity,
                  alignment: Alignment.bottomCenter,
                  child: Container(
                      height: _boxHeight,
                      margin: const EdgeInsets.only(top: 80),
                      padding: const EdgeInsets.only(top: 16),
                      color: Colors.white,
                      child: attachmentPicker
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 3.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(0.0),
            child: InkWell(
              onTap: () {
                setState(() {
                  _boxHeight = 320;
                  _showAttachment = !_showAttachment;
                  _deselectAll(false);
                  closeKeyboard(context);
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  _showAttachment ? 'assets/images/icons/icon_times.png' : 'assets/images/icons/icon_plus.png',
                  width: 24,
                  height: 24,
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: TextFormField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: '',
                border: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: const Color(0xFFF3F3F3),
              ),
              minLines: 1,
              maxLines: 4,
              style: const TextStyle(
                color: Color(0xFF111111),
                fontSize: 16,
                fontFamily: 'SUIT',
                fontWeight: FontWeight.w400,
                letterSpacing: -0.32,
              ),
            ),
          ),
          const SizedBox(width: 4),
          Container(
            padding: const EdgeInsets.all(0.0),
            child: InkWell(
              onTap: () {
                _sendMessage();
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/images/icons/icon_send.png',
                  width: 24,
                  height: 24,
                  color: _isButtonDisabled ? colorMainGrey250 : colorPrimaryBlue,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMyMessageBubble(MyMessage message, bool isPreviousSameDateTime, bool isNextSameTime) {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Visibility(
            visible: message.content.isNotEmpty,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Visibility(
                    visible: ((isPreviousSameDateTime && !isNextSameTime) || (!isPreviousSameDateTime && !isNextSameTime)) && message.content.isNotEmpty,
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
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    constraints: BoxConstraints(maxWidth: screenWidth * 0.55),
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    decoration: BoxDecoration(
                      color: colorPrimaryBlue,
                      borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(24),
                          topRight: Radius.circular(isPreviousSameDateTime ? 24 : 0),
                          bottomLeft: const Radius.circular(24),
                          bottomRight: const Radius.circular(24)
                      ),
                    ),
                    child: Text(
                      message.content,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
              child: _buildAttachment(message)
          ),
          Container(
              margin: const EdgeInsets.only(top: 4),
              child: _buildImageAttachments(message)
          ),
        ],
      ),
    );
  }

  Widget _buildOtherMessageBubble(MyMessage message, bool isPreviousSame, bool isNextSame, bool isPreviousSameDateTime, bool isNextSameTime) {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: isNextSame ? 0 : 9),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {

                },
                child: Visibility(
                  visible: !isPreviousSame,
                  child: CircleAvatar(
                    radius: 15,
                    backgroundColor: isPreviousSame ? Colors.transparent : colorMainGrey200,
                    child: FadeInImage.assetNetwork(
                      placeholder: 'assets/images/profile/placeholder.png',
                      image: message.profilePictureUrl,
                      fit: BoxFit.cover,
                      fadeInDuration: const Duration(milliseconds: 100),
                      fadeOutDuration: const Duration(milliseconds: 100),
                      imageErrorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/images/profile/profile_1.png',
                          fit: BoxFit.cover,
                        );
                      },
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
                        top: isPreviousSame ? 0 : 16
                    ),
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
                          child: Container(
                            constraints: const BoxConstraints(minHeight: 40, minWidth: 46),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                              color: colorMainGrey200,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(isPreviousSameDateTime ? 20 : 0),
                                topRight: const Radius.circular(20),
                                bottomLeft: const Radius.circular(20),
                                bottomRight: const Radius.circular(20),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Container(
                                  constraints: BoxConstraints(maxWidth: screenWidth * 0.55,),
                                  child: Text(
                                    message.content,
                                    style: const TextStyle(
                                      color: Color(0xFF1F1F1F),
                                      fontSize: 16,
                                      fontFamily: 'SUIT',
                                      fontWeight: FontWeight.w400,
                                      height: 0,
                                      letterSpacing: -0.32,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: ((isPreviousSameDateTime && !isNextSameTime) || (!isPreviousSameDateTime && !isNextSameTime)) && message.content.isNotEmpty,
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
            child: _buildAttachment(message),
          ),
          Container(
            child: _buildImageAttachments(message),
          ),
        ],
      ),
    );
  }

  Widget buildNoChats(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/icons/chat_gray.png',
            width: 54.0,
            height: 54.0,
          ),
          const SizedBox(height: 17),
          const Text(
            '대화내용이 없어요',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: colorMainGrey700,
              fontSize: 14,
              fontFamily: 'SUIT',
              fontWeight: FontWeight.w400,
              height: 0,
              letterSpacing: -0.28,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachment(MyMessage message) {
    if (message.attachmentUrl.isNotEmpty) {
      return Container(
        width: 216,
        margin: const EdgeInsets.symmetric(vertical: 0),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        constraints: BoxConstraints(maxWidth: screenWidth * 0.55),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFFE3E3E3), width: 1.0,),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.attachmentName,
              style: const TextStyle(
                color: colorMainGrey700,
                fontSize: 16,
                fontFamily: 'SUIT',
                fontWeight: FontWeight.w400,
                height: 0,
                letterSpacing: -0.32,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '${message.getAttachmentSize()} / ${message.getDate()}',
              style: const TextStyle(
                color: colorMainGrey400,
                fontSize: 14,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w400,
                height: 0,
                letterSpacing: -0.28,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              '만료',
              style: TextStyle(
                color: colorMainGrey400,
                fontSize: 14,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w400,
                height: 0,
                letterSpacing: -0.28,
              ),
            ),
          ],
        ),
      );
    }else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildImageAttachments(MyMessage message) {
    if (message.attachmentImages.isNotEmpty) {

      List<Widget> rows = [];
      int itemsPlaced = 0;
      int rowIndex = 1;
      final int itemCount = message.attachmentImages.length;

      while (itemsPlaced < itemCount) {
        int itemsInRow;

        if (itemCount == 4 && itemsPlaced == 0) {
          itemsInRow = 2;
        }else if (itemCount - itemsPlaced == 7 || itemCount - itemsPlaced == 8) {
          itemsInRow = rowIndex <= 2 ? 3 : 2;
        } else if (itemCount - itemsPlaced <= 3) {
          itemsInRow = itemCount - itemsPlaced;
        } else {
          itemsInRow = rowIndex % 2 == 0 ? 2 : 3;
        }

        double height;
        if(itemCount == 1) {
          height = 200;
        }else if(itemCount == 2) {
          height = 112;
        }else {
          height = 74;
        }

        rows.add(Container(
          margin: const EdgeInsets.only(bottom: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(itemsInRow, (index) {
              String attachment = message.attachmentImages[itemsPlaced];
              bool isLast = index == itemsInRow - 1;
              itemsPlaced++;
              return Expanded(
                child: Container(
                  height: height,
                  margin: EdgeInsets.only(right: isLast ? 0 : 2),
                  child: Container(
                    width: (screenWidth * 0.55) / (message.attachmentImages.length > 3 ? 3 : message.attachmentImages.length),
                    decoration: const BoxDecoration(
                      color: colorMainGrey200,
                    ),
                    child: InkWell(
                      onTap: () {
                        viewPhoto(context, imageUrl:attachment, fileName:message.attachmentName);
                      },
                      child: FadeInImage.assetNetwork(
                        placeholder: 'assets/images/chats/placeholder_photo.png',
                        image: attachment,
                        fit: BoxFit.cover,
                        fadeInDuration: const Duration(milliseconds: 100),
                        fadeOutDuration: const Duration(milliseconds: 100),
                        imageErrorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/images/chats/placeholder_photo.png',
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ));

      }

      return Row(
        textDirection: message.isMe ? TextDirection.rtl : TextDirection.ltr,
        mainAxisAlignment: message.isMe ? MainAxisAlignment.start : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            margin: EdgeInsets.only(left: message.isMe ? 0 : 40),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(24)
              ),
              child: Container(
                constraints: BoxConstraints(maxWidth: screenWidth * 0.55),
                alignment: message.isMe ? Alignment.topRight : Alignment.topLeft,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: Colors.white,
                ),
                child: Column(
                    children: rows
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
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
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      );

    }else {
      return const SizedBox.shrink();
    }
  }


  int type = 1;
  int _selected = 0;
  bool _selectMode = true;
  bool _isButtonFileDisabled = true;

  List<FileItem> filesImages = [
    FileItem(name: '', path: 'assets/images/photos/photo_1.png'),
    FileItem(name: '', path: 'assets/images/photos/photo_2.png'),
    FileItem(name: '', path: 'assets/images/photos/photo_3.png'),
    FileItem(name: '', path: 'assets/images/photos/photo_4.png'),
    FileItem(name: '', path: 'assets/images/photos/photo_1.png'),
    FileItem(name: '', path: 'assets/images/photos/photo_2.png'),
    FileItem(name: '', path: 'assets/images/photos/photo_3.png'),
    FileItem(name: '', path: 'assets/images/photos/photo_4.png'),
    FileItem(name: '', path: 'assets/images/photos/photo_1.png'),
    FileItem(name: '', path: 'assets/images/photos/photo_2.png'),
    FileItem(name: '', path: 'assets/images/photos/photo_3.png'),
    FileItem(name: '', path: 'assets/images/photos/photo_4.png'),
    FileItem(name: '', path: 'assets/images/photos/photo_1.png'),
    FileItem(name: '', path: 'assets/images/photos/photo_2.png'),
    FileItem(name: '', path: 'assets/images/photos/photo_3.png'),
    FileItem(name: '', path: 'assets/images/photos/photo_4.png'),
    FileItem(name: '', path: 'assets/images/photos/photo_1.png'),
    FileItem(name: '', path: 'assets/images/photos/photo_2.png'),
    FileItem(name: '', path: 'assets/images/photos/photo_3.png'),
    FileItem(name: '', path: 'assets/images/photos/photo_4.png'),
    FileItem(name: '', path: 'assets/images/photos/photo_1.png'),
    FileItem(name: '', path: 'assets/images/photos/photo_2.png'),
    FileItem(name: '', path: 'assets/images/photos/photo_3.png'),
    FileItem(name: '', path: 'assets/images/photos/photo_4.png'),
  ];

  List<FileItem> filesMedia = [
    FileItem(name: 'artrooms_img_file_final_1', date: '2022.08.16 만료'),
    FileItem(name: 'artrooms_img_file_final_2', date: '2022.08.16 만료'),
    FileItem(name: 'artrooms_img_file_final_1', date: '2022.08.16 만료'),
    FileItem(name: 'artrooms_img_file_final_2', date: '2022.08.16 만료'),
    FileItem(name: 'artrooms_img_file_final_1', date: '2022.08.16 만료'),
    FileItem(name: 'artrooms_img_file_final_2', date: '2022.08.16 만료'),
    FileItem(name: 'artrooms_img_file_final_1', date: '2022.08.16 만료'),
    FileItem(name: 'artrooms_img_file_final_2', date: '2022.08.16 만료'),
    FileItem(name: 'artrooms_img_file_final_1', date: '2022.08.16 만료'),
    FileItem(name: 'artrooms_img_file_final_2', date: '2022.08.16 만료'),
    FileItem(name: 'artrooms_img_file_final_1', date: '2022.08.16 만료'),
    FileItem(name: 'artrooms_img_file_final_2', date: '2022.08.16 만료'),
    FileItem(name: 'artrooms_img_file_final_1', date: '2022.08.16 만료'),
    FileItem(name: 'artrooms_img_file_final_2', date: '2022.08.16 만료'),
    FileItem(name: 'artrooms_img_file_final_1', date: '2022.08.16 만료'),
    FileItem(name: 'artrooms_img_file_final_2', date: '2022.08.16 만료'),
    FileItem(name: 'artrooms_img_file_final_1', date: '2022.08.16 만료'),
    FileItem(name: 'artrooms_img_file_final_2', date: '2022.08.16 만료'),
    FileItem(name: 'artrooms_img_file_final_1', date: '2022.08.16 만료'),
    FileItem(name: 'artrooms_img_file_final_2', date: '2022.08.16 만료'),
    FileItem(name: 'artrooms_img_file_final_1', date: '2022.08.16 만료'),
    FileItem(name: 'artrooms_img_file_final_2', date: '2022.08.16 만료'),
    FileItem(name: 'artrooms_img_file_final_1', date: '2022.08.16 만료'),
    FileItem(name: 'artrooms_img_file_final_2', date: '2022.08.16 만료'),
  ];

  Widget _attachmentPicker(BuildContext context, State<StatefulWidget> state) {
    return Container(
      height: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GestureDetector(
        onVerticalDragStart: _onVerticalDragStart,
        onVerticalDragUpdate: _onVerticalDragUpdate,
        onTap: () {
          if(_showAttachment) {
            state.setState(() {
              _showAttachment = false;
              _showAttachmentFull = true;
            });
          }else {
            setState(() {
              _showAttachmentFull = false;
            });
          }
          closeKeyboard(context);
        },
        child: Column(
          children: [
            Center(
              child: Container(
                height: 16,
                padding: const EdgeInsets.all(4.0),
                child: Container(
                  width: 40,
                  height: 5,
                  decoration: const BoxDecoration(
                    color: colorMainGrey250,
                    borderRadius: BorderRadius.all(Radius.circular(24)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10,),
            Row(
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    height: 44,
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    decoration: BoxDecoration(color: colorPrimaryPurple,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextButton(
                      onPressed: () {
                        state.setState(() {
                          type = 1;
                          closeKeyboard(context);
                        });
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 20,
                          ),
                          SizedBox(width: 6),
                          Text(
                              '카메라',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w500,
                                height: 0,
                                letterSpacing: -0.32,
                              )
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 4,),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    height: 44,
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    decoration: BoxDecoration(color: colorPrimaryBlue,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextButton(
                      onPressed: () {
                        state.setState(() {
                          type = 2;
                          closeKeyboard(context);
                        });
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.folder,
                            color: Colors.white,
                            size: 20,
                          ),
                          SizedBox(width: 6),
                          Text(
                              '파일',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w500,
                                height: 0,
                                letterSpacing: -0.32,
                              )
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12,),
            Visibility(
              visible: type == 1,
              child: Expanded(
                child: GridView.builder(
                  controller: _scrollControllerAttachment1,
                  padding: const EdgeInsets.only(bottom: 24),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isTablet(context) ? 6 : 3,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    childAspectRatio: 1,
                  ),
                  itemCount: filesImages.length,
                  itemBuilder: (context, index) {
                    var file = filesImages[index];
                    return Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: InkWell(
                        onTap: () {
                          viewPhoto(context, imagePath:file.path, fileName:file.name);
                        },
                        onLongPress: () {
                          state.setState(() {
                            file.isSelected = !file.isSelected;
                            closeKeyboard(context);
                          });
                          _checkIfFileShouldBeEnabled();
                        },
                        child: Stack(
                          children: [
                            Image.asset(
                              file.path,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              top: 3,
                              right: 4,
                              child: Visibility(
                                visible: _selectMode,
                                child: InkWell(
                                  onTap: () {
                                    state.setState(() {
                                      file.isSelected = !file.isSelected;
                                      _checkIfFileShouldBeEnabled();
                                      closeKeyboard(context);
                                    });
                                  },
                                  child: Container(
                                    width: 26,
                                    height: 26,
                                    decoration: BoxDecoration(
                                      color: file.isSelected ? colorPrimaryBlue : colorMainGrey200.withAlpha(150),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: file.isSelected ? colorPrimaryBlue : const Color(0xFFE3E3E3),
                                        width: 1,
                                      ),
                                    ),
                                    child: file.isSelected
                                        ? const Icon(Icons.check, size: 16, color: Colors.white)
                                        : Container(),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Visibility(
              visible: type == 2,
              child: Expanded(
                child: GridView.builder(
                  controller: _scrollControllerAttachment2,
                  padding: const EdgeInsets.only(left: 8, top: 8, right: 8, bottom: 24),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: crossAxisSpacing,
                    mainAxisSpacing: mainAxisSpacing,
                    childAspectRatio: (screenWidth / crossAxisCount - crossAxisSpacing) / 197,
                  ),
                  itemCount: filesMedia.length,
                  itemBuilder: (context, index) {
                    var fileMedia = filesMedia[index];
                    return Card(
                      elevation: 0,
                      color: Colors.white,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            // fileMedia.isSelected = !fileMedia.isSelected;
                            _checkIfFileButtonShouldBeEnabled();
                            closeKeyboard(context);
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.0),
                            border: Border.all(color: colorMainGrey200, width: 1.0,),
                          ),
                          child: Stack(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 24),
                                  Image.asset(
                                    fileMedia.isSelected ? 'assets/images/icons/icon_file_selected.png' : 'assets/images/icons/icon_file.png',
                                    width: 30,
                                    height: 30,
                                  ),
                                  const SizedBox(height: 4),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          fileMedia.name,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: colorMainGrey700,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          maxLines: 2,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          fileMedia.date,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Color(0xFF8F8F8F),
                                            fontWeight: FontWeight.w300,
                                          ),
                                          maxLines: 1,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Positioned(
                                top: 3,
                                right: 2,
                                child: Container(
                                  width: 26,
                                  height: 26,
                                  decoration: BoxDecoration(
                                    color: fileMedia.isSelected ? colorPrimaryBlue : Colors.transparent,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: fileMedia.isSelected ? colorPrimaryBlue : const Color(0xFFE3E3E3),
                                      width: 1,
                                    ),
                                  ),
                                  child: fileMedia.isSelected
                                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                                      : Container(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _attachmentSelected(BuildContext context) {

    List<FileItem> filesAttachment = [];

    for(FileItem fileImage in filesImages) {
      if(fileImage.isSelected) {
        filesAttachment.add(fileImage);
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            for(FileItem fileItem in filesAttachment)
              Container(
                margin: const EdgeInsets.only(right: 4, top: 4, bottom: 4),
                child: InkWell(
                  onTap: () {
                    viewPhoto(context, imagePath:fileItem.path, fileName:fileItem.name);
                  },
                  child: Stack(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        clipBehavior: Clip.antiAlias,
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(width: 1, color: Color(0xFFF3F3F3)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Image.asset(
                          fileItem.path,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: const BoxDecoration(
                            color: colorMainGrey400,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.close,
                              size: 12,
                              color: Colors.white,
                            ),
                            padding: const EdgeInsets.all(4),
                            constraints: const BoxConstraints(),
                            onPressed: () {
                              setState(() {
                                fileItem.isSelected = false;
                                closeKeyboard(context);
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildNoticePin(BuildContext context) {
    return Container(
      // width: 347,
      height: _isExpandNotice ? null : 36,
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
      constraints: BoxConstraints(minHeight: _isExpandNotice ? 50 : 36),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 10,
            offset: Offset(0, 0),
            spreadRadius: 0,
          )
        ],
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            _isExpandNotice = !_isExpandNotice;
            closeKeyboard(context);
          });
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SizedBox(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        padding: const EdgeInsets.only(
                          top: 2.55,
                          left: 1.64,
                          right: 1.77,
                          bottom: 2.46,
                        ),
                        clipBehavior: Clip.antiAlias,
                        decoration: const BoxDecoration(),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 16.5,
                              height: 15,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage("assets/images/icons/icon_notice.png"),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: SizedBox(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                alignment: _isExpandNotice ? Alignment.topLeft : Alignment.topLeft,
                                child: Text(
                                  dataNotice.notice,
                                  style: const TextStyle(
                                    color: Color(0xFF3A3A3A),
                                    fontSize: 14,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                    letterSpacing: -0.28,
                                  ),
                                  maxLines: _isExpandNotice ? 5 : 1,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Visibility(
                                visible: _isExpandNotice,
                                child: Container(
                                  width: double.infinity,
                                  height: 32,
                                  margin: const EdgeInsets.only(top: 10.0),
                                  padding: const EdgeInsets.only(bottom: 0.0),
                                  child: TextButton(
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      minimumSize: const Size(double.infinity, 48),
                                      foregroundColor: colorPrimaryBlue,
                                      backgroundColor: colorMainGrey200,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                    ),
                                    child: const Text(
                                      '다시 열지 않음',
                                      style: TextStyle(
                                        color: colorMainGrey900,
                                        fontSize: 13,
                                        fontFamily: 'Pretendard',
                                        fontWeight: FontWeight.w400,
                                        height: 0,
                                        letterSpacing: -0.26,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isHideNotice = true;
                                        dbStore.setNoticeHide(dataNotice, _isHideNotice);
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 20,
                        height: 20,
                        clipBehavior: Clip.antiAlias,
                        decoration: const BoxDecoration(color: Colors.white),
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(_isExpandNotice ? "assets/images/icons/icon_arrow_up.png" : "assets/images/icons/icon_arrow_down.png"),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onVerticalDragStart(DragStartDetails details) {
    _dragStartY = details.globalPosition.dy;
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    final newHeight = _boxHeight - details.globalPosition.dy + _dragStartY;

    setState(() {
      _boxHeight = newHeight.clamp(100.0, screenHeight);
      _dragStartY = details.globalPosition.dy;

      if(_boxHeight < screenHeight - 200 && _boxHeight > screenHeight - 300) {
        _showAttachment = false;
        _showAttachmentFull = false;
      }else if(_boxHeight > 320 + 160) {
        _showAttachment = false;
        if(!_showAttachmentFull) {
          _showAttachmentFull = true;
          _boxHeight = screenHeight;
        }
      }else if(_boxHeight < 320 - 160) {
        _showAttachment = false;
        _showAttachmentFull = false;
        _boxHeight = 320;
      }

    });

  }

  void _scrollListener() {

    print("_scrollController-offset: ${_scrollControllerAttachment1.offset}");
    print("_scrollController-minScrollExtent: ${_scrollControllerAttachment1.position.minScrollExtent}");
    print("_scrollController-userScrollDirection: ${_scrollControllerAttachment1.position.userScrollDirection}");

    if (_scrollControllerAttachment1.offset == 0 && _scrollControllerAttachment1.position.minScrollExtent == 0 && _scrollControllerAttachment1.position.userScrollDirection == ScrollDirection.forward) {
      setState(() {
        _listReachedTop = true;
        _showAttachment = true;
        _showAttachmentFull = false;
        _boxHeight = _boxHeightMin;
      });
    }else if (_scrollControllerAttachment1.offset <= _scrollControllerAttachment1.position.minScrollExtent && _scrollControllerAttachment1.position.userScrollDirection == ScrollDirection.forward) {
      if (!_listReachedTop) {
        setState(() {
          _listReachedTop = true;
        });
      }
    }else if (_scrollControllerAttachment1.offset <= _scrollControllerAttachment1.position.minScrollExtent && _scrollControllerAttachment1.position.userScrollDirection == ScrollDirection.reverse) {
      if (_listReachedTop) {
        setState(() {
          _listReachedTop = false;
        });
      }
    }else if (_scrollControllerAttachment1.offset >= _scrollControllerAttachment1.position.maxScrollExtent && !_scrollControllerAttachment1.position.outOfRange) {
      if (!_listReachedBottom) {
        setState(() {
          _listReachedBottom = true;
        });
      }
    } else {
      if (_listReachedBottom) {
        setState(() {
          _listReachedBottom = false;
        });
      }else {
        setState(() {
          _showAttachment = false;
          _showAttachmentFull = true;
        });
        animateHeight();
        closeKeyboard(context);
      }
    }
  }

  void animateHeight() {
    if (_animationController.isAnimating) {
      _animationController.stop();
    } else {
      _animationController.forward(from: 0.0);
    }
  }

  void _onScroll() {

    if (_scrollTimer?.isActive ?? false) _scrollTimer?.cancel();

    var firstVisibleItemIndex = _findFirstVisibleItem();

    if(listMessages.isNotEmpty) {
      var firstVisibleMessage = listMessages[firstVisibleItemIndex];

      setState(() {
        _showDateContainer = true;
        _currentDate = formatDateLastMessage(firstVisibleMessage.timestamp);
      });

      _scrollTimer = Timer(const Duration(seconds: 3), () {
        setState(() {
          _showDateContainer = false;
        });
      });
    }

    _loadMessages();

  }

  int _findFirstVisibleItem() {

    final scrollPosition = _scrollController.position.pixels;
    final viewportHeight = _scrollController.position.viewportDimension;

    for (int i = 0; i < itemKeys.length; i++) {
      final key = itemKeys[i];
      final RenderBox? box = key?.currentContext?.findRenderObject() as RenderBox?;

      if (box != null) {
        final position = box.localToGlobal(Offset.zero);
        if (position.dy < (scrollPosition + viewportHeight) && position.dy > scrollPosition) {
          return i;
        }
      }
    }

    return 0;
  }

  Future<void> _loadMessages() async {

    if(moduleMessages.isLoading()) return;

    if(!_isLoadMore) {
      setState(() {
        // _isLoadMore = listMessages.isNotEmpty;
      });
    }

    moduleMessages.getMessages().then((List<MyMessage> messages){

      setState(() {
        listMessages.addAll(messages);
      });

      if(_isLoading) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            _scrollController.jumpTo(0);
          }
        });
      }

    }).catchError((e) {

    }).whenComplete(() {
      setState(() {
        _isLoading = false;
        _isLoadMore = false;
      });
    });

  }

  void _loadNotice() {

    moduleNotice.getNotices(widget.chat.id).then((List<DataNotice> listNotices) {

      setState(() {

        for(DataNotice notice in listNotices) {
          dataNotice = notice;
        }

        _isHideNotice = dbStore.isNoticeHide(dataNotice);

      });

    }).catchError((e) {

    }).whenComplete(() {

    });

  }

  void _checkIfButtonShouldBeEnabled() {

    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        _isButtonDisabled = false;
      });
    } else {
      setState(() {
        _isButtonDisabled = true;
      });
    }

  }

  void _sendMessage() {

    if(!_isButtonDisabled) {

      if (_messageController.text.isNotEmpty) {

        moduleMessages.sendMessage(_messageController.text).then((
            MyMessage myMessage) {
          setState(() {
            listMessages.insert(0, myMessage);
            _messageController.clear();
          });

          Future.delayed(const Duration(milliseconds: 100), () {
            _scrollToBottom();
          });
        });

      }

      int selectedImages = 0;
      int selectedMedia = 0;

      MyMessage myMessage1 = MyMessage.fromBaseMessageWithDetails(
        index: 0,
        senderId: "",
        senderName: "",
        content: "",
        timestamp: 0,
        isMe: true,
      );
      for(FileItem fileItem in filesImages) {
        if(fileItem.isSelected) {
          selectedImages++;
          myMessage1.attachmentImages.add(fileItem.path);
        }
      }

      MyMessage myMessage2 = MyMessage.fromBaseMessageWithDetails(
        index: 0,
        senderId: "",
        senderName: "",
        content: "",
        timestamp: 0,
        isMe: true,
      );
      for(FileItem fileItem in filesMedia) {
        if(fileItem.isSelected) {
          selectedMedia++;
          myMessage2.attachmentUrl = fileItem.path;
        }
      }

      setState(() {

        if(selectedImages > 0) {
          listMessages.insert(0, myMessage1);
        }

        if(selectedMedia > 0) {
          listMessages.insert(0, myMessage2);
        }

      });

      setState(() {
        _showAttachment = false;
        _showAttachmentFull = false;
      });

      _deselectAll(false);
      closeKeyboard(context);

    }

  }

  void _scrollToBottom() {
    _scrollController.animateTo(0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _checkIfFileShouldBeEnabled() {

    _selected = 0;
    for(FileItem fileImage in filesImages) {
      if(fileImage.isSelected) {
        setState(() {
          _selected++;
        });
      }
    }
    for(FileItem fileMedia in filesMedia) {
      if(fileMedia.isSelected) {
        setState(() {
          _selected++;
        });
      }
    }

    if (_selected > 0) {
      setState(() {
        _selectMode = true;
        _isButtonDisabled = false;
      });
    } else {
      setState(() {
        _isButtonDisabled = true;
      });
    }

  }

  void _deselectAll(isClose) {

    setState(() {
      _selected = 0;
    });

    for(FileItem fileImage in filesImages) {
      setState(() {
        fileImage.isSelected = false;
      });
    }

    for(FileItem fileMedia in filesMedia) {
      setState(() {
        fileMedia.isSelected = false;
      });
    }

    if(isClose) {
      setState(() {
        _selectMode = false;
      });

      _checkIfFileShouldBeEnabled();
    }

  }

  void select() {

    if(!_isButtonDisabled) {
      Navigator.pop(context);
    }

  }

  void _checkIfFileButtonShouldBeEnabled() {

    int n = 0;
    for(FileItem fileImage in filesImages) {
      if(fileImage.isSelected) {
        n++;
      }
    }
    for(FileItem fileMedia in filesMedia) {
      if(fileMedia.isSelected) {
        n++;
      }
    }

    if (n > 0) {
      setState(() {
        _isButtonFileDisabled = false;
      });
    } else {
      setState(() {
        _isButtonFileDisabled = true;
      });
    }

  }

  void selectFiles() {

    if(!_isButtonFileDisabled) {
      Navigator.pop(context);
    }

  }

}
