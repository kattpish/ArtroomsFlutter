import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:artrooms/beans/bean_notice.dart';
import 'package:artrooms/modules/module_memo.dart';
import 'package:artrooms/modules/module_notices.dart';
import 'package:artrooms/ui/screens/screen_photo_view.dart';
import 'package:artrooms/ui/widgets/widget_loader.dart';
import 'package:artrooms/utils/utils_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_size/flutter_keyboard_size.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:sendbird_sdk/core/channel/base/base_channel.dart';
import 'package:sendbird_sdk/core/message/base_message.dart';
import 'package:sendbird_sdk/core/models/member.dart';
import 'package:sendbird_sdk/handlers/channel_event_handler.dart';
import '../../beans/bean_chat.dart';
import '../../beans/bean_file.dart';
import '../../beans/bean_message.dart';
import '../../listeners/scroll_bouncing_physics.dart';
import '../../main.dart';
import '../../modules/module_media.dart';
import '../../modules/module_messages.dart';
import '../../utils/utils.dart';
import '../../utils/utils_screen.dart';
import '../theme/theme_colors.dart';
import '../widgets/widget_chatroom_attachment_selected.dart';
import '../widgets/widget_chatroom_date_pin.dart';
import '../widgets/widget_chatroom_empty.dart';
import '../widgets/widget_chatroom_message_date_pin.dart';
import '../widgets/widget_chatroom_message_drawer_btn.dart';
import '../widgets/widget_chatroom_message_input.dart';
import '../widgets/widget_chatroom_message_me.dart';
import '../widgets/widget_chatroom_message_mention.dart';
import '../widgets/widget_chatroom_message_other.dart';
import '../widgets/widget_chatroom_message_reply_textfield.dart';
import '../widgets/widget_chatroom_notice_pin.dart';
import '../widgets/widget_media.dart';
import '../widgets/widget_ui_notify.dart';

class ScreenChatroom extends StatefulWidget {
  final DataChat dataChat;
  final double widthRatio;
  final Function(DataMessage newMessage)? onMessageSent;
  final VoidCallback? onBackPressed;

  const ScreenChatroom({
    super.key,
    required this.dataChat,
    this.widthRatio = 1.0,
    this.onMessageSent,
    this.onBackPressed,
  });

  @override
  State<StatefulWidget> createState() {
    return _ScreenChatroomState();
  }
}

class _ScreenChatroomState extends State<ScreenChatroom>
    with SingleTickerProviderStateMixin, ChannelEventHandler {
  bool _isLoading = true;
  bool _isLoadMore = false;
  bool _isSending = false;
  bool _isButtonDisabled = true;
  bool _isHideNotice = false;
  bool _isExpandNotice = false;

  final List<DataMessage> _listMessages = [];
  List<Member> _listMembers = [];
  List<Member> _listMembersAll = [];
  final TextEditingController _messageController = TextEditingController();
  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();
  final DraggableScrollableController _draggableScrollableController =
      DraggableScrollableController();
  final FocusNode _messageFocusNode = FocusNode();

  late final ModuleMessages _moduleMessages;
  final ModuleNotice _moduleNotice = ModuleNotice();
  final ModuleMemo _moduleMemo = ModuleMemo();
  DataNotice _dataNotice = DataNotice();
  final ModuleMedia _moduleMedia = ModuleMedia();

  bool _showAttachment = false;
  double _bottomSheetHeight = 0;
  double _bottomSheetHeightMin = dbStore.getKeyboardHeight();
  double _bottomSheetHeightMax = 0;
  double _screenWidth = 0;
  double _screenHeight = 0;
  final double _appBarHeight = 60;
  final List<double> _bottomSheetHeightMins = [];

  late ReceivePort receivePort;
  Timer? _timerScroll;
  int _currentDate = 0;
  int _firstVisibleItemIndex = -1;
  bool _showDateContainer = false;
  final Map<int, GlobalKey> _itemKeys = {};

  DataMessage? _replyMessage;
  bool _isMentioning = false;

  int _selectedImages = 0;
  int _selectedMedia = 0;
  bool _selectMode = true;
  final List<FileItem> _filesImages = [];
  final List<FileItem> _filesMedia = [];
  String title = "";
  Map<String, dynamic>? user;
  List<Member> _mentionedUsers = [];
  List<String> _mentionedUserIds = [];

  @override
  void initState() {
    super.initState();
    _messageController.addListener(_doCheckEnableButton);
    // _itemPositionsListener.itemPositions.addListener(_doHandleScroll);
    _moduleMessages = ModuleMessages(widget.dataChat.id);

    _moduleMessages.init(this);
    setTitle();
    _doLoadMessages();
    _doLoadNotice();

    receivePort = ReceivePort();
    startIsolate();

    _messageFocusNode.addListener(() {
      if (_messageFocusNode.hasFocus) {
        _doAttachmentPickerClose();
      }
    });
  }

  Future<void> setTitle() async {
    if (widget.dataChat.groupChannel!.memberCount > 2) {
      setState(() {
        title = widget.dataChat.name;
      });
    } else {
      final creatorEmail = widget.dataChat.creator?.userId;
      if (creatorEmail == null) return;
      user =
          await _moduleNotice.getArtistProfileInfoByEmail(email: creatorEmail);
      if (user == null) {
        user = await _moduleNotice.getAdminProfileByEmail(email: creatorEmail);
      }
      setState(() {
        title = user!['name'];
      });
    }
  }

  @override
  void dispose() {
    _moduleMessages.removeChannelEventHandler();
    _messageController.dispose();
    _timerScroll?.cancel();
    receivePort.close();
    removeState(this);
    dbStore.saveKeyboardHeight(_bottomSheetHeightMin);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_screenWidth == 0 || _screenHeight == 0) {
      _screenWidth = MediaQuery.of(context).size.width * widget.widthRatio;
      _screenHeight = MediaQuery.of(context).size.height;
    }
    if (_bottomSheetHeightMin == 0) {
      _bottomSheetHeightMin = _screenHeight * 0.35;
    }
    if (_bottomSheetHeightMax == 0) {
      _bottomSheetHeightMax = _screenHeight;
    }

    return WillPopScope(
      onWillPop: () async {
        if (_showAttachment) {
          _doAttachmentPickerClose();
          return false;
        }
        if (widget.onBackPressed != null) {
          widget.onBackPressed!.call();
          return false;
        } else {
          return true;
        }
      },
      child: Builder(builder: (_) {
        return SafeArea(
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              KeyboardSizeProvider(
                child: Scaffold(
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
                      title,
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
                    elevation: 0.0,
                    scrolledUnderElevation: 0,
                    toolbarHeight: _appBarHeight,
                    backgroundColor: Colors.white,
                    actions: [
                      widgetChatroomMessageDrawerBtn(context, widget.dataChat,
                          _moduleNotice, _dataNotice, _moduleMemo, onExit: () {
                        Navigator.of(context).pop();
                      }),
                    ],
                  ),
                  backgroundColor: Colors.white,
                  body: WidgetUiNotify(
                    dataChat: widget.dataChat,
                    child:
                        Consumer<ScreenHeight>(builder: (context, res, child) {
                      if (res.isOpen) {
                        _bottomSheetHeightMins.add(res.keyboardHeight);
                        _bottomSheetHeightMin = _bottomSheetHeightMins.reduce(
                            (value, element) =>
                                element > value ? element : value);
                      } else {
                        _bottomSheetHeightMins.clear();
                      }
                      return Column(
                        children: [
                          Expanded(
                            child: _buildMessageBox(),
                          ),
                          Visibility(
                            visible: _showAttachment,
                            child: attachmentSelected(context, _filesImages,
                                onRemove: (FileItem fileItem) {
                              setState(() {
                                fileItem.isSelected = false;
                                fileItem.timeSelected = 0;
                              });
                              closeKeyboard(context);
                            }),
                          ),
                          _buildMessageInput(),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 0),
                            curve: Curves.easeOut,
                            height: _bottomSheetHeight >= _bottomSheetHeightMin
                                ? _bottomSheetHeightMin - 14
                                : _bottomSheetHeight,
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ),
              Visibility(
                visible: _showAttachment &&
                    _bottomSheetHeight > _bottomSheetHeightMin + _appBarHeight,
                child: Container(
                  color: Colors.black.withOpacity(
                      0.4 * (_bottomSheetHeight / _bottomSheetHeightMax)),
                  child: GestureDetector(
                    onTap: () {
                      if (_bottomSheetHeight > _bottomSheetHeightMin) {
                        _doAttachmentPickerMin();
                      }
                    },
                  ),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 0),
                curve: Curves.easeOut,
                height: _showAttachment ? _screenHeight : 0,
                alignment: Alignment.bottomCenter,
                child: Stack(
                  children: [
                    NotificationListener<DraggableScrollableNotification>(
                      onNotification:
                          (DraggableScrollableNotification dSNotification) {
                        setState(() {
                          _bottomSheetHeight =
                              _bottomSheetHeightMax * dSNotification.extent;
                        });
                        return true;
                      },
                      child: DraggableScrollableSheet(
                        initialChildSize: _bottomSheetHeightMin / _screenHeight,
                        minChildSize: _bottomSheetHeightMin / _screenHeight,
                        maxChildSize: (_bottomSheetHeightMax - _appBarHeight) /
                            _screenHeight,
                        expand: true,
                        snap: true,
                        controller: _draggableScrollableController,
                        builder: (BuildContext context,
                            ScrollController scrollController) {
                          return Scaffold(
                            backgroundColor: Colors.transparent,
                            body: Stack(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    _doAttachmentPickerMin();
                                  },
                                ),
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(16),
                                  ),
                                  child: Container(
                                    color: Colors.white,
                                    height: double.infinity,
                                    child: _attachmentPicker(scrollController),
                                  ),
                                ),
                                Visibility(
                                  visible: _selectedImages > 0,
                                  child: Positioned.fill(
                                    top: _bottomSheetHeightMax - 250,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                          colors: [
                                            Colors.black.withOpacity(0.8),
                                            Colors.transparent,
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                AnimatedPositioned(
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOut,
                                  right: 16,
                                  bottom: _selectedImages > 0 &&
                                          (_showAttachment &&
                                              _bottomSheetHeight >
                                                  (_bottomSheetHeightMax -
                                                      _appBarHeight -
                                                      5))
                                      ? 16
                                      : -100,
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () {
                                      _doSendMessageImages();
                                    },
                                    child: Container(
                                      height: 40,
                                      constraints:
                                          const BoxConstraints(minWidth: 106),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 8),
                                      decoration: ShapeDecoration(
                                        color: const Color(0xFF5667FF),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: Image.asset(
                                              'assets/images/icons/icon_send.png',
                                              width: 24,
                                              height: 24,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          const Text(
                                            '보내기',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontFamily: 'SUIT',
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: -0.32,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: _filesImages.isEmpty,
                                  child: const Center(
                                    child: SizedBox(
                                      width: 30,
                                      height: 30,
                                      child: CircularProgressIndicator(
                                        color: Color(0xFF6A79FF),
                                        strokeWidth: 3,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildMessageBox() {
    return _isLoading
        ? const WidgetLoader()
        : Stack(
            alignment: AlignmentDirectional.topCenter,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 0),
                child: _listMessages.isNotEmpty
                    ? GestureDetector(
                        onTap: () {
                          closeKeyboard(context);
                        },
                        child: StretchingOverscrollIndicator(
                          axisDirection: AxisDirection.up,
                          child: ScrollConfiguration(
                            behavior: scrollBehavior,
                            child: ScrollablePositionedList.builder(
                              itemScrollController: _itemScrollController,
                              itemPositionsListener: _itemPositionsListener,
                              itemCount: _listMessages.length,
                              reverse: true,
                              shrinkWrap: true,
                              minCacheExtent: 200,
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
                                    messageNext.senderId == message.senderId;
                                final isPreviousDate =
                                    messagePrevious.isSameDate(message);
                                final isPreviousSameDateTime = isPreviousSame &&
                                    messagePrevious.isSameDateTime(message);
                                final isNextSameTime = isNextSame &&
                                    messageNext.isSameTime(message);
                                return Column(
                                  key: _itemKeys[index],
                                  children: [
                                    if (!isPreviousDate)
                                      widgetChatroomMessageDatePin(
                                          context, message.timestamp, index),
                                    message.isMe
                                        ? chatroomMessageMe(
                                            context: context,
                                            index: index,
                                            state: this,
                                            message: message,
                                            listMessages: _listMessages,
                                            isLast: isLast,
                                            isPreviousSame: isPreviousSame,
                                            isNextSame: isNextSame,
                                            isPreviousSameDateTime:
                                                isPreviousSameDateTime,
                                            isNextSameTime: isNextSameTime,
                                            screenWidth: _screenWidth,
                                            onReplyClick: () {
                                              _replyMessage = message;
                                              _messageFocusNode.requestFocus();
                                            },
                                            onReplySelect: (id) {
                                              _doScrollToMessage(id);
                                            })
                                        : chatroomMessageOther(
                                            context: context,
                                            index: index,
                                            state: this,
                                            message: message,
                                            listMessages: _listMessages,
                                            isLast: isLast,
                                            isPreviousSame: isPreviousSame,
                                            isNextSame: isNextSame,
                                            isPreviousSameDateTime:
                                                isPreviousSameDateTime,
                                            isNextSameTime: isNextSameTime,
                                            screenWidth: _screenWidth,
                                            onReplyClick: () {
                                              _replyMessage = message;
                                              _messageFocusNode.requestFocus();
                                            },
                                            onReplySelect: (id) {
                                              _doScrollToMessage(id);
                                            }),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
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
              Visibility(
                visible: !_isHideNotice,
                child: AnimatedOpacity(
                  opacity: !_isHideNotice && _dataNotice.notice.isNotEmpty
                      ? 1.0
                      : 0.0,
                  duration: const Duration(milliseconds: 500),
                  onEnd: () {
                    setState(() {
                      _isHideNotice = true;
                    });
                  },
                  child: WidgetChatroomNoticePin(_dataNotice, _isExpandNotice,
                      onToggle: () {
                    setState(() {
                      _isExpandNotice = !_isExpandNotice;
                      closeKeyboard(context);
                    });
                  }, onHide: () {
                    setState(() {
                      _isHideNotice = true;
                      dbStore.setNoticeHide(_dataNotice, _isHideNotice);
                    });
                  }),
                ),
              ),
              AnimatedOpacity(
                opacity: _showDateContainer ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 500),
                child: widgetChatroomDatePin(context, _currentDate),
              ),
            ],
          );
  }

  Widget _buildMessageInput() {
    final isReplying = _replyMessage != null;
    return Container(
      color: Colors.white,
      padding:
          const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0, bottom: 8.0),
      child: Column(
        children: [
          if (isReplying) buildReplyForTextField(_replyMessage, _doCancelReply),
          if (_isMentioning)
            buildMentions(
                members: _listMembers,
                onCancelReply: (Member member) {
                  _doSelectMention(member);
                }),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(0.0),
                child: GestureDetector(
                  onTap: () {
                    if (_showAttachment) {
                      _doAttachmentPickerClose();
                      _deselectPickedFiles(false);
                    } else {
                      _doAttachmentPickerMin();
                      _doLoadMedia(true);
                      closeKeyboard(context);
                    }
                    // setState(() {
                    // });
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
                child: Column(
                  children: [
                    widgetChatroomMessageInput(
                      _messageController,
                      _messageFocusNode,
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
                        _doFilterInputs(text);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.all(0.0),
                child: InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    if (!_isSending) {
                      _doSendMessage();
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      'assets/images/icons/icon_send.png',
                      width: 24,
                      height: 24,
                      color: _isSending || _isButtonDisabled
                          ? colorMainGrey250
                          : colorPrimaryBlue,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _attachmentPicker(ScrollController scrollController) {
    return Container(
      height: double.maxFinite,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      color: Colors.white,
      child: StretchingOverscrollIndicator(
        axisDirection: AxisDirection.down,
        child: ScrollConfiguration(
          behavior: scrollBehavior,
          child: CustomScrollView(
            controller: scrollController,
            slivers: [
              SliverAppBar(
                pinned: true,
                floating: true,
                elevation: 0,
                leadingWidth: 0,
                scrolledUnderElevation: 0,
                toolbarHeight: _showAttachment &&
                        _bottomSheetHeight >
                            (_bottomSheetHeightMax - _appBarHeight - 5)
                    ? 140
                    : 80,
                leading: Container(),
                backgroundColor: Colors.transparent,
                flexibleSpace: Container(
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      Center(
                        child: Container(
                          height: 16,
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                            width: 40,
                            height: 5,
                            decoration: const BoxDecoration(
                              color: colorMainGrey250,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(24)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Visibility(
                        visible: _showAttachment &&
                            _bottomSheetHeight >
                                (_bottomSheetHeightMax - _appBarHeight - 5),
                        child: AppBar(
                          backgroundColor: Colors.white,
                          title: Text(
                            !_selectMode ? '이미지' : "$_selectedImages개 선택",
                            style: const TextStyle(
                              fontSize: 18,
                              color: colorMainGrey900,
                              fontFamily: 'SUIT',
                              fontWeight: FontWeight.w700,
                              height: 0,
                              letterSpacing: -0.36,
                            ),
                          ),
                          elevation: 0,
                          scrolledUnderElevation: 0,
                          toolbarHeight: _appBarHeight,
                          centerTitle: _selectMode,
                          leading: Row(
                            children: [
                              Visibility(
                                visible: !_selectMode,
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.arrow_back_ios,
                                    color: colorMainGrey250,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ),
                              Visibility(
                                visible: _selectMode,
                                child: Container(
                                  height: double.infinity,
                                  margin: const EdgeInsets.only(left: 8.0),
                                  child: Center(
                                    child: InkWell(
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () {
                                        _doDeselectPickedImages();
                                        _doAttachmentPickerMin();
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(8.0),
                                        child: const Text(
                                          '취소',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: colorMainGrey600,
                                            fontFamily: 'SUIT',
                                            fontWeight: FontWeight.w400,
                                            height: 0,
                                            letterSpacing: -0.32,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            Visibility(
                              visible: _selectMode,
                              child: Container(
                                height: double.infinity,
                                margin: const EdgeInsets.only(right: 8.0),
                                child: Center(
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () {
                                      _doDeselectPickedImages();
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      child: const Text('선택 해제',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: colorMainGrey600,
                                            fontFamily: 'SUIT',
                                            fontWeight: FontWeight.w400,
                                            height: 0,
                                            letterSpacing: -0.32,
                                          )),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: !_selectMode,
                              child: Container(
                                height: double.infinity,
                                margin: const EdgeInsets.only(left: 8.0),
                                child: Center(
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () {
                                      setState(() {
                                        _selectMode = true;
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      child: const Text(
                                        '선택',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: colorMainGrey600,
                                          fontFamily: 'SUIT',
                                          fontWeight: FontWeight.w400,
                                          height: 0,
                                          letterSpacing: -0.32,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              height: 44,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              decoration: BoxDecoration(
                                color: colorPrimaryPurple,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: TextButton(
                                onPressed: () async {
                                  closeKeyboard(context);
                                  await _doProcessCameraResult();
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              decoration: BoxDecoration(
                                color: colorPrimaryBlue,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: TextButton(
                                onPressed: () async {
                                  closeKeyboard(context);
                                  await _doProcessPickedFiles();
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
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.only(bottom: 12.0),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isTablet(context) ? 6 : 3,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    childAspectRatio: 1,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      var fileImage = _filesImages[index];
                      return Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return ScreenPhotoView(
                                images: _filesImages,
                                initialIndex: index,
                                isSelectMode: true,
                                onSelect: (bool isSelected, index,
                                    FileItem fileItem) {
                                  _doCheckEnableButtonFile();
                                },
                              );
                            }));
                          },
                          onLongPress: () {
                            setState(() {
                              if (!fileImage.isSelected) {
                                fileImage.isSelected = true;
                                fileImage.timeSelected =
                                    DateTime.now().millisecondsSinceEpoch;
                              } else {
                                fileImage.isSelected = false;
                                fileImage.timeSelected = 0;
                              }
                              closeKeyboard(context);
                            });
                            _doCheckEnableButtonFile();
                          },
                          child: Stack(
                            children: [
                              Container(
                                color: colorMainGrey200,
                                child: Image.file(
                                  fileImage.getPreviewFile(),
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.cover,
                                  cacheWidth: 200,
                                  cacheHeight: 200,
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Visibility(
                                  visible: _selectMode,
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () {
                                      setState(() {
                                        if (!fileImage.isSelected) {
                                          fileImage.isSelected = true;
                                          fileImage.timeSelected =
                                              DateTime.now()
                                                  .millisecondsSinceEpoch;
                                        } else {
                                          fileImage.isSelected = false;
                                          fileImage.timeSelected = 0;
                                        }
                                        _doCheckEnableButtonFile();
                                        closeKeyboard(context);
                                      });
                                    },
                                    child: Container(
                                      width: 26,
                                      height: 26,
                                      margin: const EdgeInsets.only(
                                          top: 8.0,
                                          right: 8,
                                          left: 16,
                                          bottom: 16),
                                      decoration: BoxDecoration(
                                        color: fileImage.isSelected
                                            ? colorPrimaryBlue
                                            : colorMainGrey200.withAlpha(150),
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
                    childCount: _filesImages.length,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void onMessageReceived(BaseChannel channel, BaseMessage baseMessage) {
    DataMessage dataMessage = DataMessage.fromBaseMessage(baseMessage);

    if (!_listMessages.contains(dataMessage)) {
      _listMessages.insert(0, dataMessage);
      showNotificationMessage(context, widget.dataChat, dataMessage);
    }
  }

  Future<void> _doLoadMessages() async {
    if (_moduleMessages.isLoading()) return;
    if (!_isLoadMore) {
      setState(() {
        // _isLoadMore = listMessages.isNotEmpty;
      });
    }
    _moduleMessages
        .getMessagesMore()
        .then((List<DataMessage> messages) {
          // print('_doLoadMessages ${messages.length}');
          setState(() {
            _listMessages.addAll(messages);
          });
          // print('_doLoadMessages LAST MESSAGE ${messages.last}');
          for (DataMessage message in messages) {
            showNotificationMessage(context, widget.dataChat, message);
          }
        })
        .catchError((e) {})
        .whenComplete(() {
          if (mounted) {
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
        if (!_listMessages.contains(message)) {
          _listMessages.insert(0, message);
          showNotificationMessage(context, widget.dataChat, message);
        }
      }
    });
  }

  void startIsolate() async {
    await Isolate.spawn(timerEntryPoint, receivePort.sendPort);
    receivePort.listen((data) {
      if (data == 'loadMessages') {
        _doLoadMessagesNew();
      }
    });
  }

  static void timerEntryPoint(SendPort sendPort) {
    Timer.periodic(Duration(seconds: timeSecRefreshChat), (timer) {
      sendPort.send('loadMessages');
    });
  }

  void _doLoadNotice() {
    _moduleNotice
        .getNotices(widget.dataChat.id)
        .then((List<DataNotice> listNotices) {
      setState(() {
        for (DataNotice notice in listNotices) {
          if (notice.noticeable && notice.notice.isNotEmpty) {
            _dataNotice = notice;
            _isHideNotice = dbStore.isNoticeHide(_dataNotice);
            break;
          }
        }
      });
    });
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
    if (_listMembersAll.isEmpty) {
      setState(() {
        _listMembersAll = _moduleMessages.getGroupChannel().members;
      });
    }
    _listMembers = _listMembersAll;
    return _listMembersAll;
  }

  Future<void> _doSendMessage() async {
    if (!_isButtonDisabled) {
      _doSendMessageText();

      _doAttachmentPickerClose();
      await _doSendMessageImages();
      await _doSendMessageMedia();

      _deselectPickedFiles(false);
      _doCancelReply();
      _doCancelMention();
    }
  }

  void _doSendMessageText() {
    if (_messageController.text.isNotEmpty) {
      setState(() {
        _isSending = true;
      });

      _moduleMessages
          .sendMessage(
        _messageController.text,
        _replyMessage,
        mentionedUserIds: _mentionedUserIds,
      )
          .then((DataMessage myMessage) {
        setState(() {
          _listMessages.insert(0, myMessage);
          _messageController.clear();
          _isSending = false;
          widget.onMessageSent?.call(myMessage);
          _mentionedUsers = [];
          _mentionedUserIds = [];
        });

        Future.delayed(const Duration(milliseconds: 100), () {
          _doScrollToBottom();
        });
      });
    }
  }

  Future<void> _doSendMessageImages() async {
    if (_selectedImages > 0) {
      setState(() {
        _isSending = true;
      });

      _doAttachmentPickerClose();

      DataMessage myMessage1 =
          _moduleMessages.preSendMessageImage(_filesImages);
      int index = myMessage1.index;

      setState(() {
        _listMessages.insert(0, myMessage1);
      });

      Future.delayed(const Duration(milliseconds: 100), () {
        _doScrollToBottom();
      });

      setState(() {
        _isSending = false;
      });

      myMessage1 = await _moduleMessages.sendMessageImages(_filesImages);
      myMessage1.isSending = false;
      _doDeselectPickedImages();

      for (int i = 0; i < _listMessages.length; i++) {
        print("hello ${_listMessages[i]}");
        DataMessage myMessage = _listMessages[i];
        if (myMessage.index == index) {
          setState(() {
            _listMessages[i] = myMessage1;
          });
          widget.onMessageSent?.call(myMessage1);
          break;
        }
      }
    }
  }

  Future<void> _doSendMessageMedia() async {
    if (_selectedMedia > 0) {
      setState(() {
        _isSending = true;
      });

      _doAttachmentPickerClose();

      List<int> index = [];

      List<DataMessage> myMessages =
          await _moduleMessages.preSendMessageMedia(_filesMedia);

      for (DataMessage myMessage1 in myMessages) {
        setState(() {
          _listMessages.insert(0, myMessage1);
        });
        index.add(myMessage1.index);
      }

      Future.delayed(const Duration(milliseconds: 100), () {
        _doScrollToBottom();
      });

      setState(() {
        _isSending = false;
      });

      myMessages = await _moduleMessages.sendMessageMedia(_filesMedia);
      _doDeselectPickedMedia();

      for (int j = 0; j < _listMessages.length; j++) {
        DataMessage myMessage = _listMessages[j];

        for (int i = 0; i < myMessages.length; i++) {
          DataMessage myMessage1 = myMessages[i];
          myMessage1.isSending = false;
          if (myMessage.index == index[i]) {
            setState(() {
              _listMessages[j] = myMessage1;
            });
            widget.onMessageSent?.call(myMessage1);
            break;
          }
        }
      }
    }
  }

  Future<void> _doProcessCameraResult() async {
    File? file = await doPickImageWithCamera();

    if (file != null) {
      _selectedImages++;
      FileItem fileItem = FileItem(file: file, path: file.path);
      fileItem.isSelected = true;
      fileItem.timeSelected = DateTime.now().millisecondsSinceEpoch;
      _filesImages.insert(0, fileItem);
    }
  }

  Future<void> _doProcessPickedFiles() async {
    _doDeselectPickedMedia();

    List<FileItem> fileItems = await doPickFiles();

    for (FileItem fileItem in fileItems) {
      _selectedMedia++;
      fileItem.isSelected = true;
      fileItem.timeSelected = DateTime.now().millisecondsSinceEpoch;
      _filesMedia.add(fileItem);
    }

    await _doSendMessageMedia();
  }

  Future<void> _doLoadMedia(isShow) async {
    _moduleMedia.loadFileImages1(
      isShowSettings: isShow,
      onLoad: (FileItem fileItem) {
        if (!mounted) {
          return;
        }
        if (_filesImages.contains(fileItem)) {
          return;
        }
        setState(() {
          _filesImages.add(fileItem);
        });
      },
    );

    for (FileItem fileItem in _filesImages) {
      if (await fileItem.file.exists()) {
        return;
      }
      setState(() {
        _filesImages.remove(fileItem);
      });
    }
  }

  void _deselectPickedFiles(isClose) {
    _doDeselectPickedImages();
    _doDeselectPickedMedia();
    if (isClose) {
      _doAttachmentPickerClose();
    }
  }

  void _doDeselectPickedImages() {
    setState(() {
      _selectedImages = 0;
    });

    for (FileItem fileImage in _filesImages) {
      setState(() {
        fileImage.isSelected = false;
        fileImage.timeSelected = 0;
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
        fileMedia.timeSelected = 0;
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
      _isMentioning = false;
    });
  }

  void _doSelectMention(Member member) {
    final newText = "${_messageController.text}${member.nickname} ";
    _messageController.text = newText;
    _messageController.selection = TextSelection.fromPosition(
      TextPosition(offset: newText.length),
    );
    setState(() {
      _mentionedUsers.add(member);
      _mentionedUserIds.add(member.userId);
      _isMentioning = false;
    });
    // TODO: 멘션 처리하기
  }

  void _doFilterInputs(String text) {
    _doGetAllMembers();

    String textAfterCharacter = "";
    if (text.contains("@")) {
      textAfterCharacter = text.substring(text.lastIndexOf('@') + 1);
    }

    if (text.endsWith("@")) {
      if (_isMentioning == false) {
        setState(() {
          _isMentioning = true;
        });
      }
    }

    if (textAfterCharacter.isNotEmpty && !textAfterCharacter.contains(' ')) {
      if (_isMentioning == false) {
        setState(() {
          _isMentioning = true;
        });
      }
      _doUpdateAllMemberByFilter(textAfterCharacter);
    }

    if (text.endsWith(" ") || text.isEmpty) {
      textAfterCharacter = "";
      setState(() {
        _isMentioning = false;
      });
    }
  }

  void _doUpdateAllMemberByFilter(String textAfterCharacter) {
    setState(() {
      _listMembers = _listMembersAll.where((member) {
        return member.nickname
            .toLowerCase()
            .substring(member.nickname.lastIndexOf('@') + 1)
            .contains(textAfterCharacter.toLowerCase());
      }).toList();
    });
  }

  void _doAttachmentPickerMin() {
    setState(() {
      _showAttachment = true;
      _bottomSheetHeight = _bottomSheetHeightMin;
    });
    // setState(() {
    // });
    _draggableScrollableController.reset();
  }

  void _doAttachmentPickerClose() {
    setState(() {
      _showAttachment = false;
    });
    setState(() {
      _bottomSheetHeight = 0;
    });
  }

  void _doScrollToBottom() {
    _itemScrollController.jumpTo(index: 0);
  }

  void _doScrollToMessage(int id) {
    _itemScrollController.scrollTo(
        index: _getMessageIndex(id),
        alignment: 0.5,
        duration: const Duration(milliseconds: 500));
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

  void _doHandleScroll() {
    final visiblePositions = _itemPositionsListener.itemPositions.value
        .where((ItemPosition position) {
      return position.itemTrailingEdge > 0;
    });
    if (visiblePositions.isEmpty) return;

    final firstVisibleItemIndex =
        visiblePositions.reduce((ItemPosition max, ItemPosition position) {
      return position.itemTrailingEdge > max.itemTrailingEdge ? position : max;
    }).index;

    if (_firstVisibleItemIndex == -1) {
      _firstVisibleItemIndex = firstVisibleItemIndex;
      return;
    } else if (_firstVisibleItemIndex == firstVisibleItemIndex) {
      return;
    }

    _firstVisibleItemIndex = firstVisibleItemIndex;

    if (_listMessages.isNotEmpty) {
      if (!_showDateContainer) {
        DataMessage firstVisibleMessage = _listMessages[firstVisibleItemIndex];

        setState(() {
          _showDateContainer = true;
          _currentDate = firstVisibleMessage.timestamp;
        });

        if (_timerScroll?.isActive ?? false) _timerScroll?.cancel();

        _timerScroll = Timer(const Duration(milliseconds: 500), () {
          setState(() {
            _showDateContainer = false;
          });
          _timerScroll?.cancel();
        });
      }
    }

    _doLoadMessages();
  }

  int _getMessageIndex(int id) {
    for (int i = 0; i < _listMessages.length; i++) {
      if (_listMessages[i].index == id) {
        return i < _listMessages.length ? i + 1 : i;
      }
    }
    return 0;
  }
}
