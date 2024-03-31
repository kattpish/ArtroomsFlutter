import 'dart:async';
import 'dart:io';

import 'package:artrooms/beans/bean_notice.dart';
import 'package:artrooms/modules/module_notices.dart';
import 'package:artrooms/ui/screens/screen_chatroom_drawer.dart';
import 'package:artrooms/ui/widgets/widget_loader.dart';
import 'package:artrooms/utils/utils_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:sendbird_sdk/core/models/member.dart';
import '../../beans/bean_chat.dart';
import '../../beans/bean_file.dart';
import '../../beans/bean_message.dart';
import '../../listeners/scroll_bouncing_physics.dart';
import '../../main.dart';
import '../../modules/module_messages.dart';
import '../../utils/utils.dart';
import '../../utils/utils_screen.dart';
import '../theme/theme_colors.dart';
import '../widgets/widget_chatroom_attachment_selected.dart';
import '../widgets/widget_chatroom_empty.dart';
import '../widgets/widget_chatroom_message_input.dart';
import '../widgets/widget_chatroom_message_me.dart';
import '../widgets/widget_chatroom_message_mention.dart';
import '../widgets/widget_chatroom_message_other.dart';
import '../widgets/widget_chatroom_message_pin.dart';
import '../widgets/widget_chatroom_message_reply_textfield.dart';
import '../widgets/widget_chatroom_notice_pin.dart';
import '../widgets/widget_media.dart';
import '../widgets/widget_ui_notify.dart';

class ScreenChatroom extends StatefulWidget {

  final DataChat dataChat;
  final double widthRatio;
  final VoidCallback? onBackPressed;

  const ScreenChatroom(
      {super.key,
        required this.dataChat,
        this.widthRatio = 1.0,
        this.onBackPressed});

  @override
  State<StatefulWidget> createState() {
    return _ScreenChatroomState();
  }
}

class _ScreenChatroomState extends State<ScreenChatroom> with SingleTickerProviderStateMixin {

  bool _isLoading = true;
  bool _isLoadMore = false;
  bool _isButtonDisabled = true;
  bool _isHideNotice = false;
  bool _isExpandNotice = false;
  bool _showAttachment = false;
  bool _showAttachmentFull = false;
  bool _listReachedTop = false;
  bool _listReachedBottom = false;

  final List<DataMessage> _listMessages = [];
  final ScrollController _scrollController = ScrollController();
  final ScrollController _scrollControllerAttachment1 = ScrollController();
  final ScrollController _scrollControllerAttachment2 = ScrollController();
  final TextEditingController _messageController = TextEditingController();
  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener = ItemPositionsListener.create();
  final FocusNode _messageFocusNode = FocusNode();

  late final ModuleMessages _moduleMessages;
  final ModuleNotice _moduleNotice = ModuleNotice();
  DataNotice _dataNotice = DataNotice();

  double _boxHeight = 320.0;
  final double _boxHeightMin = 320.0;
  double _dragStartY = 0.0;
  double _screenWidth = 0;
  double _screenHeight = 0;

  int _crossAxisCount = 2;
  final double _crossAxisSpacing = 8;
  final double _mainAxisSpacing = 8;
  int _firstVisibleItemIndex = -1;

  Timer? _scrollTimer;
  String _currentDate = '';
  bool _showDateContainer = false;
  final Map<int, GlobalKey> _itemKeys = {};

  late Widget attachmentPicker;
  late Timer _timer;

  late AnimationController _animationController;
  DataMessage? _replyMessage;
  bool _isMentioning = false;

  int _pickerType = 1;
  int _selectedImages = 0;
  int _selectedMedia = 0;
  bool _selectMode = true;
  final List<FileItem> _filesImages = [];
  final List<FileItem> _filesMedia = [];

  @override
  void initState() {
    super.initState();
    _messageController.addListener(_doCheckEnableButton);
    _scrollControllerAttachment1.addListener(_scrollListener1);
    _scrollControllerAttachment2.addListener(_scrollListener2);
    _itemPositionsListener.itemPositions.addListener(_doHandleScroll);
    _moduleMessages = ModuleMessages(widget.dataChat.id);

    _doLoadMessages();
    _doLoadNotice();
    _doLoadMedia();

    _timer = Timer.periodic(Duration(seconds: timeSecRefreshChat), (timer) {
      _doLoadMessagesNew();
    });

    _messageFocusNode.addListener(() {
      if (_messageFocusNode.hasFocus) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });

    _messageFocusNode.addListener(() {
      if (_messageFocusNode.hasFocus) {
        _doHideAttachmentPicker();
      }
    });

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    double interval = 0;
    Tween(begin: _boxHeight, end: _screenHeight)
        .animate(_animationController)
        .addListener(() {
      if (interval <= 0) {
        interval = (_screenHeight - _boxHeight) / 10;
      }

      setState(() {
        if (_boxHeight < _screenHeight) {
          _boxHeight += interval;
        }
        if (_boxHeight > _screenHeight) {
          _boxHeight = _screenHeight;
        }
      });

      if (_boxHeight == _screenHeight) {
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
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    _screenWidth = MediaQuery.of(context).size.width * widget.widthRatio;
    _screenHeight = MediaQuery.of(context).size.height;
    _crossAxisCount = isTablet(context) ? 4 : 2;

    attachmentPicker = _attachmentPicker(context, this);

    return WillPopScope(
      onWillPop: () async {
        if (_showAttachment) {
          setState(() {
            _showAttachment = false;
          });
          return false;
        } else if (_showAttachmentFull) {
          setState(() {
            _doAttachmentPickerMin();
          });
          return false;
        }
        if (widget.onBackPressed != null) {
          widget.onBackPressed!.call();
          return false;
        } else {
          return true;
        }
      },
      child: Builder(builder: (context) {
        return SafeArea(
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
                      if (widget.onBackPressed != null) {
                        widget.onBackPressed!.call();
                      } else {
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                  title: Text(
                    widget.dataChat.name,
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
                            )),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                                return ScreenChatroomDrawer(
                                  dataChat: widget.dataChat,
                                );
                              }));
                        },
                      ),
                    ),
                  ],
                ),
                backgroundColor: Colors.white,
                body: WidgetUiNotify(
                  dataChat: widget.dataChat,
                  child: Column(
                    children: [
                      Expanded(
                        child: _isLoading
                            ? const WidgetLoader()
                            : Stack(
                          alignment: AlignmentDirectional.topCenter,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 0),
                              child: _listMessages.isNotEmpty ? GestureDetector(
                                  onTap: () {
                                    closeKeyboard(context);
                                  },
                                  child: ScrollablePositionedList.builder(
                                    itemScrollController: _itemScrollController,
                                    itemPositionsListener: _itemPositionsListener,
                                    itemCount: _listMessages.length,
                                    physics: const ScrollPhysicsBouncing(),
                                    reverse: true,
                                    itemBuilder: (context, index) {
                                      _itemKeys[index] = GlobalKey();
                                      final message = _listMessages[index];
                                      final isLast = index == 0;
                                      final messageNext = index > 0
                                          ? _listMessages[index - 1]
                                          : DataMessage.empty();
                                      final messagePrevious =
                                      index < _listMessages.length - 1
                                          ? _listMessages[index + 1]
                                          : DataMessage.empty();
                                      final isPreviousSame =
                                          messagePrevious.senderId ==
                                              message.senderId;
                                      final isNextSame =
                                          messageNext.senderId ==
                                              message.senderId;
                                      final isPreviousDate =
                                          messagePrevious.getDate() ==
                                              message.getDate();
                                      final isPreviousSameDateTime =
                                          isPreviousSame &&
                                              messagePrevious
                                                  .getDateTime() ==
                                                  message.getDateTime();
                                      final isNextSameTime = isNextSame &&
                                          messageNext.getDateTime() ==
                                              message.getDateTime();
                                      return Column(
                                        key: _itemKeys[index],
                                        children: [
                                          Visibility(
                                            visible: !isPreviousDate,
                                            child: Container(
                                              width: 145,
                                              height: 31,
                                              margin: EdgeInsets.only(
                                                  left: 16,
                                                  right: 16,
                                                  top:
                                                  index == 0 ? 4 : 16,
                                                  bottom:
                                                  index == 0 ? 4 : 8),
                                              padding: const EdgeInsets
                                                  .symmetric(
                                                  horizontal: 12,
                                                  vertical: 4),
                                              alignment: Alignment.center,
                                              decoration: ShapeDecoration(
                                                color: const Color(
                                                    0xFFF9F9F9),
                                                shape:
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(20),
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisSize:
                                                MainAxisSize.min,
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .start,
                                                crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .center,
                                                children: [
                                                  Text(
                                                    formatDateLastMessage(
                                                        message
                                                            .timestamp),
                                                    style:
                                                    const TextStyle(
                                                      color: Color(
                                                          0xFF7D7D7D),
                                                      fontSize: 12,
                                                      fontFamily: 'SUIT',
                                                      fontWeight:
                                                      FontWeight.w400,
                                                      height: 0,
                                                      letterSpacing:
                                                      -0.24,
                                                    ),
                                                    maxLines: 1,
                                                    overflow: TextOverflow
                                                        .ellipsis,
                                                    textAlign:
                                                    TextAlign.center,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          FocusedMenuHolder(
                                              onPressed: () {},
                                              menuWidth:
                                              MediaQuery.of(context)
                                                  .size
                                                  .width /
                                                  3,
                                              menuItems: [
                                                FocusedMenuItem(
                                                    trailingIcon:
                                                    const Icon(
                                                        Icons.reply,
                                                      color: colorMainGrey500,
                                                    ),
                                                    title: const Text(
                                                        "답장"),
                                                    onPressed: () {
                                                      _replyMessage =
                                                          message;
                                                      _messageFocusNode
                                                          .requestFocus();
                                                    }),
                                                FocusedMenuItem(
                                                    trailingIcon:
                                                    const Icon(Icons.copy,
                                                      color: colorMainGrey500,
                                                    ),
                                                    title: const Text(
                                                        "복사"),
                                                    onPressed: () async {
                                                      await Clipboard.setData(
                                                          ClipboardData(
                                                              text: message
                                                                  .content));
                                                    })
                                              ],
                                              blurSize: 0.0,
                                              menuOffset: 10.0,
                                              bottomOffsetHeight: 80.0,
                                              menuBoxDecoration:
                                              const BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.all(
                                                      Radius.circular(
                                                          15.0))),
                                              child: Container(
                                                child: message.isMe
                                                    ? buildMyMessageBubble(context, this, message, isLast, isPreviousSameDateTime, isNextSameTime, _screenWidth)
                                                    : buildOtherMessageBubble(context, this, message, isLast, isPreviousSame, isNextSame, isPreviousSameDateTime, isNextSameTime, _screenWidth),
                                              ))
                                        ],
                                      );
                                    },
                                  )
                              )
                                  : widgetChatroomEmpty(context),
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
                              opacity: !_isHideNotice &&
                                  _dataNotice.notice.isNotEmpty
                                  ? 1.0
                                  : 0.0,
                              duration: const Duration(milliseconds: 500),
                              child: buildNoticePin(context, _dataNotice, _isExpandNotice, _isHideNotice,
                                  onToggle:() {
                                    setState(() {
                                      _isExpandNotice = !_isExpandNotice;
                                      closeKeyboard(context);
                                    });
                                  },
                                  onHide:() {
                                    setState(() {
                                      _isHideNotice = true;
                                      dbStore.setNoticeHide(_dataNotice, _isHideNotice);
                                    });
                                  }
                              ),
                            ),
                            AnimatedOpacity(
                              opacity: _showDateContainer ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 500),
                              child: Container(
                                width: 145,
                                height: 31,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 2),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 4),
                                alignment: Alignment.center,
                                decoration: ShapeDecoration(
                                  color: const Color(0xFFF9F9F9),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                  MainAxisAlignment.start,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
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
                        child: attachmentSelected(context, _filesImages,
                            onRemove:(FileItem fileItem) {
                              setState(() {
                                fileItem.isSelected = false;
                              });
                              closeKeyboard(context);
                            }
                        ),
                      ),
                      _buildMessageInput(),
                      const SizedBox(height: 8),
                      Visibility(
                        visible: _showAttachment,
                        child:
                        SizedBox(height: _boxHeight, child: attachmentPicker),
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: _showAttachmentFull,
                child: Scaffold(
                  backgroundColor: Colors.black.withOpacity(0.4),
                  body: Container(
                    height: double.infinity,
                    alignment: Alignment.bottomCenter,
                    child: Stack(
                      children: [
                        Expanded(child: InkWell(
                          onTap: () {
                            setState(() {
                              _doAttachmentPickerMin();
                            });
                          },
                        )),
                        SizedBox(
                          height: double.infinity,
                          child: Container(
                              height: _boxHeight,
                              margin: const EdgeInsets.only(top: 80),
                              padding: const EdgeInsets.only(top: 16),
                              color: Colors.white,
                              child: attachmentPicker),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildMessageInput() {
    final isReplying = _replyMessage != null;
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 3.0),
      child: Column(
        children: [
          if (isReplying) buildReplyForTextField(_replyMessage, _doCancelReply),
          if (_isMentioning) buildMentions(
              members: _doGetAllMembers(),
              onCancelReply: (Member member) {
                _doSelectMention(member);
              }
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(0.0),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      if (_showAttachmentFull) {
                        _doAttachmentPickerMin();
                      } else if (_showAttachment) {
                        _doAttachmentPickerClose();
                        _deselectPickedFiles(false);
                      } else {
                        _doAttachmentPickerMin();
                        _doLoadMedia();
                      }
                      closeKeyboard(context);
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      _showAttachment
                          ? 'assets/images/icons/icon_times.png'
                          : 'assets/images/icons/icon_plus.png',
                      width: 24,
                      height: 24,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                  child: Column(children: [
                    widgetChatroomMessageInput(_messageController, _messageFocusNode,
                        onChanged: (String text) {
                          if (text.endsWith("@")) {
                            setState(() {
                              _isMentioning = !_isMentioning;
                            });
                          }
                          if (text.endsWith(" ")) {
                            setState(() {
                              _isMentioning = false;
                            });
                          }
                        }
                    ),
                  ])),
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.all(0.0),
                child: InkWell(
                  onTap: () {
                    _doSendMessage();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      'assets/images/icons/icon_send.png',
                      width: 24,
                      height: 24,
                      color: _isButtonDisabled
                          ? colorMainGrey250
                          : colorPrimaryBlue,
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _attachmentPicker(BuildContext context, State<StatefulWidget> state) {
    return Container(
      height: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GestureDetector(
        onVerticalDragStart: _doVerticalDragStart,
        onVerticalDragUpdate: _doVerticalDragUpdate,
        onTap: () {
          if (_showAttachment) {
            state.setState(() {
              _showAttachment = false;
              _showAttachmentFull = true;
            });
          } else {
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
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    height: 44,
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    decoration: BoxDecoration(
                      color: colorPrimaryPurple,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextButton(
                      onPressed: () {
                        state.setState(() async {
                          _pickerType = 1;
                          closeKeyboard(context);
                          await _doProcessCameraResult();
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
                          Text('카메라',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w500,
                                height: 0,
                                letterSpacing: -0.32,
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 4,
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    height: 44,
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    decoration: BoxDecoration(
                      color: colorPrimaryBlue,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextButton(
                      onPressed: () {
                        state.setState(() async {
                          // type = 2;
                          closeKeyboard(context);
                          await _doProcessPickedFiles();
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
                          Text('파일',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w500,
                                height: 0,
                                letterSpacing: -0.32,
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            Visibility(
              visible: _pickerType == 1,
              child: Expanded(
                child: _filesImages.isEmpty
                    ? const Center(
                  child: SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(
                      color: Color(0xFF6A79FF),
                      strokeWidth: 3,
                    ),
                  ),
                )
                    : GridView.builder(
                  controller: _scrollControllerAttachment1,
                  padding: const EdgeInsets.only(bottom: 24),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isTablet(context) ? 6 : 3,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    childAspectRatio: 1,
                  ),
                  itemCount: _filesImages.length,
                  itemBuilder: (context, index) {
                    var fileImage = _filesImages[index];
                    return Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: InkWell(
                        onTap: () {
                          doOpenPhotoView(context,
                              fileImage: fileImage.file,
                              fileName: fileImage.name);
                        },
                        onLongPress: () {
                          state.setState(() {
                            fileImage.isSelected = !fileImage.isSelected;
                            closeKeyboard(context);
                          });
                          _doCheckEnableButtonFile();
                        },
                        child: Stack(
                          children: [
                            Image.file(
                              fileImage.file,
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
                                      fileImage.isSelected =
                                      !fileImage.isSelected;
                                      _doCheckEnableButtonFile();
                                      closeKeyboard(context);
                                    });
                                  },
                                  child: Container(
                                    width: 26,
                                    height: 26,
                                    decoration: BoxDecoration(
                                      color: fileImage.isSelected
                                          ? colorPrimaryBlue
                                          : colorMainGrey200
                                          .withAlpha(150),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: fileImage.isSelected
                                            ? colorPrimaryBlue
                                            : const Color(0xFFE3E3E3),
                                        width: 1,
                                      ),
                                    ),
                                    child: fileImage.isSelected
                                        ? const Icon(Icons.check,
                                        size: 16, color: Colors.white)
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
              visible: _pickerType == 2,
              child: Expanded(
                child: _filesMedia.isEmpty
                    ? const Center(
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(
                      color: Color(0xFF6A79FF),
                      strokeWidth: 3,
                    ),
                  ),
                )
                    : GridView.builder(
                  controller: _scrollControllerAttachment2,
                  padding: const EdgeInsets.only(
                      left: 8, top: 8, right: 8, bottom: 24),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: _crossAxisCount,
                    crossAxisSpacing: _crossAxisSpacing,
                    mainAxisSpacing: _mainAxisSpacing,
                    childAspectRatio: (_screenWidth / _crossAxisCount -
                        _crossAxisSpacing) /
                        197,
                  ),
                  itemCount: _filesMedia.length,
                  itemBuilder: (context, index) {
                    var fileMedia = _filesMedia[index];
                    return Card(
                      elevation: 0,
                      color: Colors.white,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            fileMedia.isSelected = !fileMedia.isSelected;
                            _doCheckEnableButtonFile();
                            closeKeyboard(context);
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.0),
                            border: Border.all(
                              color: colorMainGrey200,
                              width: 1.0,
                            ),
                          ),
                          child: Stack(
                            children: [
                              Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 24),
                                  Image.asset(
                                    fileMedia.isSelected
                                        ? 'assets/images/icons/icon_file_selected.png'
                                        : 'assets/images/icons/icon_file.png',
                                    width: 30,
                                    height: 30,
                                  ),
                                  const SizedBox(height: 4),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
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
                                    color: fileMedia.isSelected
                                        ? colorPrimaryBlue
                                        : Colors.transparent,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: fileMedia.isSelected
                                          ? colorPrimaryBlue
                                          : const Color(0xFFE3E3E3),
                                      width: 1,
                                    ),
                                  ),
                                  child: fileMedia.isSelected
                                      ? const Icon(Icons.check,
                                      size: 16, color: Colors.white)
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

  void _doAttachmentPickerFull() {
    setState(() {
      _boxHeight = _boxHeightMin;
      _showAttachmentFull = true;
      _showAttachment = false;
    });
  }

  void _doAttachmentPickerMin() {
    setState(() {
      _boxHeight = _boxHeightMin;
      _showAttachment = true;
      _showAttachmentFull = false;
    });
  }

  void _doAttachmentPickerClose() {
    setState(() {
      _boxHeight = _boxHeightMin;
      _showAttachment = false;
      _showAttachmentFull = false;
    });
  }

  void _doVerticalDragStart(DragStartDetails details) {
    _dragStartY = details.globalPosition.dy;
  }

  void _doVerticalDragUpdate(DragUpdateDetails details) {
    final newHeight = _boxHeight - details.globalPosition.dy + _dragStartY;

    setState(() {
      _boxHeight = newHeight.clamp(100.0, _screenHeight);
      _dragStartY = details.globalPosition.dy;

      if (_boxHeight < _screenHeight - 100 && _boxHeight > _screenHeight - 200) {
        if (kDebugMode) {
          print("_onVerticalDragUpdate-1");
        }
        _doAttachmentPickerMin();
      } else if (_boxHeight > _boxHeightMin + 160) {
        if (kDebugMode) {
          print("_onVerticalDragUpdate-2");
        }
        _showAttachment = false;
        if (!_showAttachmentFull) {
          _showAttachmentFull = true;
          _boxHeight = _screenHeight;
        }
      } else if (_boxHeight < _boxHeightMin - 160) {
        if (kDebugMode) {
          print("_onVerticalDragUpdate-3");
        }
        _doAttachmentPickerClose();
      }
    });
  }

  void _scrollListener1() {
    if (kDebugMode) {
      print("_scrollController-offset: ${_scrollControllerAttachment1.offset}");
      print("_scrollController-minScrollExtent: ${_scrollControllerAttachment1.position.minScrollExtent}");
      print("_scrollController-userScrollDirection: ${_scrollControllerAttachment1.position.userScrollDirection}");
    }

    if (_scrollControllerAttachment1.offset == 0 &&
        _scrollControllerAttachment1.position.minScrollExtent == 0 &&
        _scrollControllerAttachment1.position.userScrollDirection == ScrollDirection.forward) {
      if (kDebugMode) {
        print("_scrollController-1");
      }
      setState(() {
        _listReachedTop = true;
        _doAttachmentPickerMin();
        _animationController.stop();
      });
    } else if (_scrollControllerAttachment1.offset <=
        _scrollControllerAttachment1.position.minScrollExtent &&
        _scrollControllerAttachment1.position.userScrollDirection == ScrollDirection.forward) {
      if (kDebugMode) {
        print("_scrollController-2");
      }
      if (!_listReachedTop) {
        setState(() {
          _listReachedTop = true;
        });
      }
    } else if (_scrollControllerAttachment1.offset <=
        _scrollControllerAttachment1.position.minScrollExtent &&
        _scrollControllerAttachment1.position.userScrollDirection == ScrollDirection.reverse) {
      if (kDebugMode) {
        print("_scrollController-3");
      }
      if (_listReachedTop) {
        setState(() {
          _listReachedTop = false;
        });
      }
    } else if (_scrollControllerAttachment1.offset >=
        _scrollControllerAttachment1.position.maxScrollExtent &&
        !_scrollControllerAttachment1.position.outOfRange) {
      if (kDebugMode) {
        print("_scrollController-4");
      }
      if (!_listReachedBottom) {
        setState(() {
          _listReachedBottom = true;
        });
      }
    } else {
      if (kDebugMode) {
        print("_scrollController-5");
      }
      if (_listReachedBottom) {
        if (kDebugMode) {
          print("_scrollController-5_1");
        }
        setState(() {
          _listReachedBottom = false;
        });
      } else {
        if (kDebugMode) {
          print("_scrollController-5_2");
        }
        setState(() {
          _showAttachment = false;
          _showAttachmentFull = true;
        });
        _doAnimateHeight();
        closeKeyboard(context);
      }
    }
  }

  void _scrollListener2() {
    if (kDebugMode) {
      print("_scrollController-offset: ${_scrollControllerAttachment2.offset}");
    }
    if (kDebugMode) {
      print("_scrollController-minScrollExtent: ${_scrollControllerAttachment2.position.minScrollExtent}");
    }
    if (kDebugMode) {
      print("_scrollController-userScrollDirection: ${_scrollControllerAttachment2.position.userScrollDirection}");
    }

    if (_scrollControllerAttachment2.offset == 0 &&
        _scrollControllerAttachment2.position.minScrollExtent == 0 &&
        _scrollControllerAttachment2.position.userScrollDirection == ScrollDirection.forward) {
      if (kDebugMode) {
        print("_scrollController-1");
      }
      setState(() {
        _listReachedTop = true;
        _doAttachmentPickerMin();
        _animationController.stop();
      });
    } else if (_scrollControllerAttachment2.offset <=
        _scrollControllerAttachment2.position.minScrollExtent &&
        _scrollControllerAttachment2.position.userScrollDirection == ScrollDirection.forward) {
      if (kDebugMode) {
        print("_scrollController-2");
      }
      if (!_listReachedTop) {
        setState(() {
          _listReachedTop = true;
        });
      }
    } else if (_scrollControllerAttachment2.offset <=
        _scrollControllerAttachment2.position.minScrollExtent &&
        _scrollControllerAttachment2.position.userScrollDirection == ScrollDirection.reverse) {
      if (kDebugMode) {
        print("_scrollController-3");
      }
      if (_listReachedTop) {
        setState(() {
          _listReachedTop = false;
        });
      }
    } else if (_scrollControllerAttachment2.offset >=
        _scrollControllerAttachment2.position.maxScrollExtent &&
        !_scrollControllerAttachment2.position.outOfRange) {
      if (kDebugMode) {
        print("_scrollController-4");
      }
      if (!_listReachedBottom) {
        setState(() {
          _listReachedBottom = true;
        });
      }
    } else {
      if (kDebugMode) {
        print("_scrollController-5");
      }
      if (_listReachedBottom) {
        if (kDebugMode) {
          print("_scrollController-5_1");
        }
        setState(() {
          _listReachedBottom = false;
        });
      } else {
        if (kDebugMode) {
          print("_scrollController-5_2");
        }
        setState(() {
          _showAttachment = false;
          _showAttachmentFull = true;
        });
        _doAnimateHeight();
        closeKeyboard(context);
      }
    }
  }

  void _doAnimateHeight() {
    if (_animationController.isAnimating && _boxHeight > _screenHeight) {
      _animationController.stop();
    } else {
      _animationController.forward(from: 0.0);
    }
  }

  void _doHandleScroll() {

    final visiblePositions = _itemPositionsListener.itemPositions.value
        .where((ItemPosition position) {
      return position.itemTrailingEdge > 0;
    });
    if (visiblePositions.isEmpty) return;

    final firstVisibleItemIndex = visiblePositions
        .reduce((ItemPosition max, ItemPosition position) {
      return position.itemTrailingEdge > max.itemTrailingEdge ? position : max;
    }).index;

    if(_firstVisibleItemIndex == -1) {
      _firstVisibleItemIndex = firstVisibleItemIndex;
      return;
    }else if(_firstVisibleItemIndex == firstVisibleItemIndex) {
      return;
    }

    _firstVisibleItemIndex = firstVisibleItemIndex;

    if (_scrollTimer?.isActive ?? false) _scrollTimer?.cancel();

    if(_listMessages.isNotEmpty) {

      var firstVisibleMessage = _listMessages[firstVisibleItemIndex];

      setState(() {
        _showDateContainer = true;
        _currentDate = formatDateLastMessage(firstVisibleMessage.timestamp);
      });

      _scrollTimer = Timer(const Duration(milliseconds: 500), () {
        setState(() {
          _showDateContainer = false;
        });
      });

    }

    _doLoadMessages();
  }

  Future<void> _doLoadMessages() async {
    if (_moduleMessages.isLoading()) return;

    if (!_isLoadMore) {
      setState(() {
        // _isLoadMore = listMessages.isNotEmpty;
      });
    }

    _moduleMessages.getMessagesMore().then((List<DataMessage> messages) {
      setState(() {
        _listMessages.addAll(messages);
      });

      for (DataMessage message in messages) {
        showNotificationMessage(context, widget.dataChat, message);
      }

    }).catchError((e) {

    }
    ).whenComplete(() {
      if(mounted) {
        setState(() {
          _isLoading = false;
          _isLoadMore = false;
        });
      }
    });
  }

  Future<void> _doLoadMessagesNew() async {
    if (_moduleMessages.isLoading()) return;

    _moduleMessages.getMessagesNew().then((List<DataMessage> messages) {

      for (DataMessage message in messages) {
        if(!_listMessages.contains(message)) {
          _listMessages.insert(0, message);
          showNotificationMessage(context, widget.dataChat, message);
        }
      }

    });
  }

  void _doLoadNotice() {
    _moduleNotice.getNotices(widget.dataChat.id).then((List<DataNotice> listNotices) {
      setState(() {
        for (DataNotice notice in listNotices) {
          if (notice.noticeable) {
            _dataNotice = notice;
            _isHideNotice = dbStore.isNoticeHide(_dataNotice);
            break;
          }
        }
      });
    })
        .catchError((e) {})
        .whenComplete(() {});
  }

  void _doCheckEnableButton() {
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

  List<Member> _doGetAllMembers() {
    return _moduleMessages.getGroupChannel().members;
  }

  Future<void> _doSendMessage() async {
    if (!_isButtonDisabled) {

      _doSendMessageText();

      setState(() {
        _showAttachment = false;
        _showAttachmentFull = false;
      });

      await _doSendMessageImages();

      await _doSendMessageMedia();

      _deselectPickedFiles(false);
      _doCancelReply();
    }
  }

  void _doSendMessageText() {

    if (_messageController.text.isNotEmpty) {
      _moduleMessages
          .sendMessage(_messageController.text, _replyMessage)
          .then((DataMessage myMessage) {
        setState(() {
          _listMessages.insert(0, myMessage);
          _messageController.clear();
        });

        Future.delayed(const Duration(milliseconds: 100), () {
          _doScrollToBottom();
        });
      });
    }

  }

  Future<void> _doSendMessageImages() async {

    if (_selectedImages > 0) {
      DataMessage myMessage1 = _moduleMessages.preSendMessageImage(_filesImages);
      int index = myMessage1.index;

      setState(() {
        _listMessages.insert(0, myMessage1);
      });

      Future.delayed(const Duration(milliseconds: 100), () {
        _doScrollToBottom();
      });

      myMessage1 = await _moduleMessages.sendMessageImages(_filesImages);
      myMessage1.isSending = false;

      for (int i = 0; i < _listMessages.length; i++) {
        DataMessage myMessage = _listMessages[i];
        if (myMessage.index == index) {
          setState(() {
            _listMessages[i] = myMessage1;
          });
          break;
        }
      }
    }

  }

  Future<void> _doSendMessageMedia() async {

    if (_selectedMedia > 0) {
      List<int> index = [];

      List<DataMessage> myMessages = await _moduleMessages.preSendMessageMedia(_filesMedia);

      for (DataMessage myMessage1 in myMessages) {
        setState(() {
          _listMessages.insert(0, myMessage1);
        });
        index.add(myMessage1.index);
      }

      Future.delayed(const Duration(milliseconds: 100), () {
        _doScrollToBottom();
      });

      myMessages = await _moduleMessages.sendMessageMedia(_filesMedia);

      for (int j = 0; j < _listMessages.length; j++) {
        DataMessage myMessage = _listMessages[j];

        for (int i = 0; i < myMessages.length; i++) {
          DataMessage myMessage1 = myMessages[i];
          myMessage1.isSending = false;
          if (myMessage.index == index[i]) {
            setState(() {
              _listMessages[j] = myMessage1;
            });
            break;
          }
        }
      }
    }

  }

  Future<void> _doProcessCameraResult() async {
    File? file = await doPickImageWithCamera();

    if(file != null) {
      _selectedImages++;
      FileItem fileItem = FileItem(file: file, path: file.path);
      fileItem.isSelected = true;
      _filesImages.insert(0, fileItem);
    }
  }

  Future<void> _doProcessPickedFiles() async {
    _doAttachmentPickerClose();
    _doDeselectPickedMedia();

    List<FileItem> fileItems = await doPickFiles();

    for(FileItem fileItem in fileItems) {
      _selectedMedia++;
      fileItem.isSelected = true;
      _filesMedia.add(fileItem);
    }

    await _doSendMessageMedia();
  }

  void _doLoadMedia() {
    _filesImages.clear();
    _filesMedia.clear();

    moduleMedia.init();

    moduleMedia.loadFileImages().then((List<FileItem> listImages) {
      setState(() {
        _filesImages.addAll(listImages);
      });
    });

    moduleMedia.loadFilesMedia().then((List<FileItem> listMedia) {
      setState(() {
        _filesMedia.addAll(listMedia);
      });
    });
  }

  void _doHideAttachmentPicker() {
    _showAttachment = false;
    _showAttachmentFull = false;
  }

  void _doScrollToBottom() {
    _itemScrollController.jumpTo(index: 0);
  }

  void _doCheckEnableButtonFile() {
    _selectedImages = 0;
    _selectedMedia = 0;

    for (FileItem fileImage in _filesImages) {
      if (fileImage.isSelected) {
        setState(() {
          _selectedImages++;
        });
      }
    }
    for (FileItem fileMedia in _filesMedia) {
      if (fileMedia.isSelected) {
        setState(() {
          _selectedMedia++;
        });
      }
    }

    if (_selectedImages + _selectedMedia > 0) {
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

  void _deselectPickedFiles(isClose) {
    _doDeselectPickedImages();
    _doDeselectPickedMedia();
  }

  void _doDeselectPickedImages() {
    setState(() {
      _selectedImages = 0;
    });

    for (FileItem fileImage in _filesImages) {
      setState(() {
        fileImage.isSelected = false;
      });
    }
  }

  void _doDeselectPickedMedia() {
    setState(() {
      _selectedMedia = 0;
    });

    for (FileItem fileMedia in _filesMedia) {
      setState(() {
        fileMedia.isSelected = false;
      });
    }
  }

  void _doCancelReply() {
    setState(() {
      _replyMessage = null;
    });
  }

  void _doCancelMention() {
    setState(() {
      _replyMessage = null;
    });
  }

  void _doSelectMention(Member member) {
    _messageController.text = "${_messageController.text}${member.nickname} ";
    setState(() {
      _isMentioning = false;
    });
  }

}
