import 'dart:async';
import 'dart:io';

import 'package:artrooms/beans/bean_notice.dart';
import 'package:artrooms/listeners/scroll_noglow_behavior.dart';
import 'package:artrooms/modules/module_notices.dart';
import 'package:artrooms/ui/screens/screen_photo_view.dart';
import 'package:artrooms/ui/widgets/widget_loader.dart';
import 'package:artrooms/utils/utils_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:rich_text_editor_controller/rich_text_editor_controller.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:sendbird_sdk/core/channel/base/base_channel.dart';
import 'package:sendbird_sdk/core/message/base_message.dart';
import 'package:sendbird_sdk/core/models/member.dart';
import 'package:sendbird_sdk/handlers/channel_event_handler.dart';
import '../../beans/bean_chat.dart';
import '../../beans/bean_file.dart';
import '../../beans/bean_message.dart';
import '../../listeners/scroll_bouncing_physics_fast.dart';
import '../../main.dart';
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

class _ScreenChatroomState extends State<ScreenChatroom> with SingleTickerProviderStateMixin, ChannelEventHandler {

  bool _isLoading = true;
  bool _isLoadMore = false;
  bool _isButtonDisabled = true;
  bool _isHideNotice = false;
  bool _isExpandNotice = false;
  bool _listReachedTop = false;
  bool _listReachedBottom = false;

  final List<DataMessage> _listMessages = [];
  List<Member> _listMembers = [];
  List<Member> _listMembersAll = [];
  final ScrollController _scrollControllerAttachment = ScrollController();
  final TextEditingController _messageController = TextEditingController();
  final RichTextEditorController _richTextEditorController = RichTextEditorController();
  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener = ItemPositionsListener.create();
  final FocusNode _messageFocusNode = FocusNode();

  late final ModuleMessages _moduleMessages;
  final ModuleNotice _moduleNotice = ModuleNotice();
  DataNotice _dataNotice = DataNotice();

  bool _showAttachment = false;
  double _bottomSheetHeight = 0;
  double _bottomSheetHeightMin = 0;
  double _bottomSheetHeightMax = 0;
  double _dragStartY = 0.0;
  double _screenWidth = 0;
  double _screenHeight = 0;
  late Widget attachmentPicker;

  late Timer _timer;
  Timer? _scrollTimer;
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

  @override
  void initState() {
    super.initState();
    _messageController.addListener(_doCheckEnableButton);
    _scrollControllerAttachment.addListener(_scrollListenerAttachment);
    _itemPositionsListener.itemPositions.addListener(_doHandleScroll);
    _moduleMessages = ModuleMessages(widget.dataChat.id);

    _moduleMessages.init(this);

    _doLoadMessages();
    _doLoadNotice();

    _timer = Timer.periodic(Duration(seconds: timeSecRefreshChat), (timer) {
      _doLoadMessagesNew();
    });

    _messageFocusNode.addListener(() {
      if (_messageFocusNode.hasFocus) {
        _doAttachmentPickerClose();
      }
    });

  }

  @override
  void dispose() {
    _moduleMessages.removeChannelEventHandler();
    _messageController.dispose();
    _scrollControllerAttachment.dispose();
    _scrollTimer?.cancel();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    _screenWidth = MediaQuery.of(context).size.width * widget.widthRatio;
    _screenHeight = MediaQuery.of(context).size.height;
    _bottomSheetHeightMin = _screenHeight * 0.35;
    _bottomSheetHeightMax = _screenHeight * 0.95;

    attachmentPicker = _attachmentPicker(context, this);

    return WillPopScope(
      onWillPop: () async {
        if (_showAttachment) {
          if(_bottomSheetHeight > _bottomSheetHeightMin) {
            _doAttachmentPickerMin();
          }else {
            _doAttachmentPickerClose();
          }
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
                  elevation: 0.2,
                  toolbarHeight: 60,
                  backgroundColor: Colors.white,
                  actions: [
                    widgetChatroomMessageDrawerBtn(context, widget.dataChat),
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
                                    _doAttachmentPickerClose();
                                  },
                                  child: ScrollConfiguration(
                                    behavior: const ScrollBehavior().copyWith(overscroll: false),
                                    child: ScrollablePositionedList.builder(
                                      itemScrollController: _itemScrollController,
                                      itemPositionsListener: _itemPositionsListener,
                                      itemCount: _listMessages.length,
                                      // physics: const ScrollPhysicsBouncingFast(),
                                      reverse: true,
                                      itemBuilder: (context, index) {
                                        _itemKeys[index] = GlobalKey();
                                        final message = _listMessages[index];
                                        final isLast = index == 0;
                                        final messageNext = index > 0 ? _listMessages[index - 1] : DataMessage.empty();
                                        final messagePrevious = index < _listMessages.length - 1 ? _listMessages[index + 1] : DataMessage.empty();
                                        final isPreviousSame = messagePrevious.senderId == message.senderId;
                                        final isNextSame = messageNext.senderId == message.senderId;
                                        final isPreviousDate = messagePrevious.isSameDate(message);
                                        final isPreviousSameDateTime = isPreviousSame && messagePrevious.isSameDateTime(message);
                                        final isNextSameTime = isNextSame && messageNext.isSameTime(message);
                                        return Column(
                                          key: _itemKeys[index],
                                          children: [
                                            if(!isPreviousDate) widgetChatroomMessageDatePin(context, message.timestamp, index),
                                            message.isMe
                                                  ? buildMyMessageBubble(context, index, this, message, _listMessages, isLast, isPreviousSameDateTime, isNextSameTime, isPreviousSameDateTime, isNextSameTime, _screenWidth,
                                                      (){
                                                    _replyMessage = message;
                                                    _messageFocusNode.requestFocus();
                                                  }, (index){
                                                    _itemScrollController.scrollTo(index: 20,alignment: 0.5,duration: const Duration(seconds: 1));
                                                  })
                                                  : buildOtherMessageBubble(context, index, this, message, _listMessages, isLast, isPreviousSame, isNextSame, isPreviousSameDateTime, isNextSameTime, _screenWidth,
                                                      (){
                                                    _replyMessage = message;
                                                    _messageFocusNode.requestFocus();
                                                  }, (index){
                                                    _itemScrollController.scrollTo(index: 20,alignment: 0.5,duration: const Duration(seconds: 1));
                                                  }),
                                          ],
                                        );
                                      },
                                    ),
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
                            Visibility(
                              visible: !_isHideNotice,
                              child: AnimatedOpacity(
                                opacity: !_isHideNotice && _dataNotice.notice.isNotEmpty ? 1.0 : 0.0,
                                duration: const Duration(milliseconds: 500),
                                onEnd: () {
                                  setState(() {
                                    _isHideNotice = true;
                                  });
                                },
                                child: WidgetChatroomNoticePin(_dataNotice, _isExpandNotice,
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
                            ),
                            AnimatedOpacity(
                              opacity: _showDateContainer ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 500),
                              child: widgetChatroomDatePin(context, _currentDate),
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
                                fileItem.timeSelected = 0;
                              });
                              closeKeyboard(context);
                            }
                        ),
                      ),
                      _buildMessageInput(),
                      const SizedBox(height: 8),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeOut,
                        height: _bottomSheetHeight > _bottomSheetHeightMin ? _bottomSheetHeightMin : _bottomSheetHeight,
                        // child: attachmentPicker,
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible:  _showAttachment && _bottomSheetHeight > _bottomSheetHeightMin,
                child: Container(
                  color: Colors.black.withOpacity(0.4),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOut,
                height: _bottomSheetHeight,
                alignment: Alignment.bottomCenter,
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  body: Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if( _bottomSheetHeight > _bottomSheetHeightMin) {
                              _doAttachmentPickerMin();
                            }else {
                              _doAttachmentPickerClose();
                            }
                          });
                        },
                      ),
                      Container(
                          height: double.infinity,
                          margin: EdgeInsets.only(top: _bottomSheetHeight > _bottomSheetHeightMin ? 80 : 0),
                          color: Colors.white,
                          child: attachmentPicker
                      ),
                    ],
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
              members: _listMembers,
              onCancelReply: (Member member) {
                _doSelectMention(member);
              }
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(0.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (_showAttachment) {
                        _doAttachmentPickerClose();
                        _deselectPickedFiles(false);
                      } else {
                        _doAttachmentPickerMin();
                        _doLoadMedia(true);
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
                child: Column(
                  children: [
                    widgetChatroomMessageInput(_messageController, _richTextEditorController, _messageFocusNode,
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
          if (_bottomSheetHeight <= _bottomSheetHeightMin) {
            _doAttachmentPickerFull();
          } else {
            _doAttachmentPickerMin();
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
            Visibility(
              visible: _showAttachment && _bottomSheetHeight > _bottomSheetHeightMin,
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
                toolbarHeight: 60,
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
                            onTap: () {
                              _deselectPickedFiles(true);
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
                                  )
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
                          onTap: () {
                            _doDeselectPickedImages();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            child: const Text(
                                '선택 해제',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: colorMainGrey600,
                                  fontFamily: 'SUIT',
                                  fontWeight: FontWeight.w400,
                                  height: 0,
                                  letterSpacing: -0.32,
                                )
                            ),
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
                                )
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
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    decoration: BoxDecoration(
                      color: colorPrimaryPurple,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextButton(
                      onPressed: () {
                        state.setState(() async {
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
            Expanded(
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
                controller: _scrollControllerAttachment,
                physics: const ClampingScrollPhysics(),
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
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return ScreenPhotoView(images: _filesImages, initialIndex: index, isSelectMode: true,
                          onSelect: (bool isSelected, index, FileItem fileItem) {
                            _doCheckEnableButtonFile();
                          },);
                        }));
                      },
                      onLongPress: () {
                        state.setState(() {
                          if(!fileImage.isSelected) {
                            fileImage.isSelected = true;
                            fileImage.timeSelected = DateTime.now().millisecondsSinceEpoch;
                          }else {
                            fileImage.isSelected = false;
                            fileImage.timeSelected = 0;
                          }
                          closeKeyboard(context);
                        });
                        _doCheckEnableButtonFile();
                      },
                      child: Stack(
                        children: [
                          Image.file(
                            fileImage.getPreviewFile(),
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            top: 3,
                            right: 4,
                            child: Visibility(
                              visible: _selectMode,
                              child: GestureDetector(
                                onTap: () {
                                  state.setState(() {
                                    if(!fileImage.isSelected) {
                                      fileImage.isSelected = true;
                                      fileImage.timeSelected = DateTime.now().millisecondsSinceEpoch;
                                    }else {
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
          ],
        ),
      ),
    );
  }

  @override
  void onMessageReceived(BaseChannel channel, BaseMessage baseMessage) {

    DataMessage dataMessage = DataMessage.fromBaseMessage(baseMessage);

    if(!_listMessages.contains(dataMessage)) {
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
    if(_listMembersAll.isEmpty) {
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

      _moduleMessages.sendMessage(_messageController.text, _replyMessage).then((DataMessage myMessage) {
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
      _doAttachmentPickerClose();

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
      _doAttachmentPickerClose();

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
      fileItem.timeSelected = DateTime.now().millisecondsSinceEpoch;
      _filesImages.insert(0, fileItem);
    }
  }

  Future<void> _doProcessPickedFiles() async {
    _doDeselectPickedMedia();

    List<FileItem> fileItems = await doPickFiles();

    for(FileItem fileItem in fileItems) {
      _selectedMedia++;
      fileItem.isSelected = true;
      fileItem.timeSelected = DateTime.now().millisecondsSinceEpoch;
      _filesMedia.add(fileItem);
    }

    await _doSendMessageMedia();
  }

  Future<void> _doLoadMedia(isShow) async {

    moduleMedia.loadFileImages1(isShowSettings: isShow, onLoad: (FileItem fileItem) {
      if(mounted) {
        setState(() {
          if (!_filesImages.contains(fileItem)) {
            _filesImages.add(fileItem);
          }
        });
      }
    });

    for (FileItem fileItem in _filesImages) {
      if (!await fileItem.file.exists()) {
        setState(() {
          _filesImages.remove(fileItem);
        });
      }
    }

  }

  void _deselectPickedFiles(isClose) {
    _doDeselectPickedImages();
    _doDeselectPickedMedia();
    if(isClose) {
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
      _isMentioning = false;
    });
  }

  void _doFilterInputs(String text) {

    _doGetAllMembers();

    String textAfterCharacter = "";
    if (text.contains("@")) {
      textAfterCharacter = text.substring(text.lastIndexOf('@') + 1);
    }

    if (text.endsWith("@")) {
      if(_isMentioning == false) {
        setState(() {
          _isMentioning = true;
        });
      }
    }

    if(textAfterCharacter.isNotEmpty && !textAfterCharacter.contains(' ')){
      if(_isMentioning == false) {
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
        return member.nickname.toLowerCase()
            .substring(member.nickname.lastIndexOf('@') + 1)
            .contains(textAfterCharacter.toLowerCase());
      }).toList();
    });
  }

  void _doAttachmentPickerFull() {

    if(_bottomSheetHeight < _bottomSheetHeightMax) {
      _scrollControllerAttachment.animateTo(
        10,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    }

    setState(() {
      _showAttachment = true;
    });
    setState(() {
      _bottomSheetHeight = _bottomSheetHeightMax;
    });
  }

  void _doAttachmentPickerMin() {
    setState(() {
      _showAttachment = true;
    });
    setState(() {
      _bottomSheetHeight = _bottomSheetHeightMin;
    });
  }

  void _doAttachmentPickerClose() {
    setState(() {
      _showAttachment = false;
    });
    setState(() {
      _bottomSheetHeight = 0;
    });
  }

  void _doVerticalDragStart(DragStartDetails details) {
    _dragStartY = details.globalPosition.dy;
  }

  void _doVerticalDragUpdate(DragUpdateDetails details) {
    final newHeight = _bottomSheetHeight - details.globalPosition.dy + _dragStartY;
    bool isIncrease = newHeight > _bottomSheetHeight;

    setState(() {
      _bottomSheetHeight = newHeight.clamp(100.0, _bottomSheetHeightMax);
      _dragStartY = details.globalPosition.dy;

      if(isIncrease) {
        _doAttachmentPickerFull();
      }else {
        if (_bottomSheetHeight < _bottomSheetHeightMin) {
          _doAttachmentPickerClose();
      }else {
          _doAttachmentPickerMin();
        }
      }

    });

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

  void _scrollListenerAttachment() {

    if (_scrollControllerAttachment.offset == 0 &&
        _scrollControllerAttachment.position.minScrollExtent == 0 &&
        _scrollControllerAttachment.position.userScrollDirection == ScrollDirection.forward) {
      setState(() {
        _listReachedTop = true;
        _doAttachmentPickerMin();
      });
    } else if (_scrollControllerAttachment.offset <=
        _scrollControllerAttachment.position.minScrollExtent &&
        _scrollControllerAttachment.position.userScrollDirection == ScrollDirection.forward) {
      if (!_listReachedTop) {
        setState(() {
          _listReachedTop = true;
        });
      }
    } else if (_scrollControllerAttachment.offset <=
        _scrollControllerAttachment.position.minScrollExtent &&
        _scrollControllerAttachment.position.userScrollDirection == ScrollDirection.reverse) {
      if (_listReachedTop) {
        setState(() {
          _listReachedTop = false;
        });
      }
    } else if (_scrollControllerAttachment.offset >=
        _scrollControllerAttachment.position.maxScrollExtent &&
        !_scrollControllerAttachment.position.outOfRange) {
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
      } else {
        setState(() {
          _doAttachmentPickerFull();
        });
      }
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

      DataMessage firstVisibleMessage = _listMessages[firstVisibleItemIndex];

      setState(() {
        _showDateContainer = true;
        _currentDate = firstVisibleMessage.timestamp;
      });

      _scrollTimer = Timer(const Duration(milliseconds: 500), () {
        setState(() {
          _showDateContainer = false;
        });
      });

    }

    _doLoadMessages();
  }

}
