import 'dart:async';
import 'dart:isolate';

import 'package:artrooms/beans/bean_message.dart';
import 'package:artrooms/main.dart';
import 'package:artrooms/ui/screens/screen_chatroom.dart';
import 'package:artrooms/ui/screens/screen_login.dart';
import 'package:artrooms/ui/screens/screen_profile.dart';
import 'package:artrooms/utils/utils.dart';
import 'package:artrooms/utils/utils_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../beans/bean_chat.dart';
import '../../listeners/scroll_bouncing_physics.dart';
import '../../modules/module_chats.dart';
import '../../utils/utils_permissions.dart';
import '../../utils/utils_screen.dart';
import '../theme/theme_colors.dart';
import '../widgets/widget_chatroom_message_pin.dart';
import '../widgets/widget_chats_empty.dart';
import '../widgets/widget_chats_exit.dart';
import '../widgets/widget_chats_row.dart';
import '../widgets/widget_loader.dart';
import '../widgets/widget_ui_notify.dart';

class ScreenChats extends StatefulWidget {
  const ScreenChats({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ScreenChatsState();
  }
}

class _ScreenChatsState extends State<ScreenChats> with WidgetsBindingObserver {
  bool _isLoading = true;
  bool _isSearching = false;
  bool _autofocus = false;
  final List<DataChat> _listChats = [];
  final List<DataChat> _listChatsAll = [];
  final TextEditingController _searchController = TextEditingController();

  String _selectChatId = "";
  bool _isLoadingChatroom = false;
  final Map<String, ScreenChatroom> _listScreenChatrooms = {};
  final ModuleChat _chatModule = ModuleChat();

  late ReceivePort receivePort;

  @override
  void initState() {
    super.initState();
    addState(this);

    if (!dbStore.isLoggedIn()) {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) {
        return const ScreenLogin();
      }));
      return;
    }

    requestPermissions(context);

    _doLoadChats();

    receivePort = ReceivePort();
    startIsolate();

    _searchController.addListener(() {
      _doSearchChats(_searchController.text, true);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    removeState(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 38,
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: const Text(
                '채팅',
                style: TextStyle(
                  color: colorMainGrey900,
                  fontSize: 20,
                  fontFamily: 'SUIT',
                  fontWeight: FontWeight.w700,
                  height: 0,
                  letterSpacing: -0.40,
                ),
              ),
              backgroundColor: Colors.white,
              toolbarHeight: 60,
              elevation: 0,
              scrolledUnderElevation: 0,
              actions: [
                IconButton(
                    icon: const Icon(Icons.more_vert, color: colorMainGrey250),
                    onPressed: () {
                      setState(() {
                        _autofocus = false;
                      });
                      closeKeyboard(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const ScreenProfile();
                      }));
                    }),
              ],
            ),
            body: Stack(
              children: [
                _isLoading && _listChats.isEmpty
                    ? const WidgetLoader()
                    : Column(
                        children: [
                          Visibility(
                            visible: _isSearching ||
                                _listChats.isNotEmpty ||
                                _searchController.text.isNotEmpty,
                            child: Container(
                              height: 44,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: TextField(
                                controller: _searchController,
                                autofocus: _autofocus,
                                decoration: InputDecoration(
                                  hintText: '',
                                  suffixIcon: const Icon(Icons.search,
                                      size: 30, color: colorMainGrey300),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 0),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _autofocus = true;
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: (_listChats.isNotEmpty || _isSearching)
                                ? LayoutBuilder(
                                    builder: (context, constraints) {
                                      return SlidableAutoCloseBehavior(
                                        child: StretchingOverscrollIndicator(
                                          axisDirection: AxisDirection.down,
                                          child: ScrollConfiguration(
                                            behavior: scrollBehavior,
                                            child: RefreshIndicator(
                                              onRefresh: _doLoadChats,
                                              child: ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: _listChats.length,
                                                itemBuilder: (context, index) {
                                                  DataChat dataChat =
                                                      _listChats[index];
                                                  return Container(
                                                    key: Key(
                                                        _listChats[index].id),
                                                    child: WidgetChatRow(
                                                      context: context,
                                                      index: index,
                                                      dataChat: dataChat,
                                                      onClickOption1: () {
                                                        _doToggleNotification(
                                                            context, dataChat);
                                                      },
                                                      onClickOption2: () {
                                                        widgetChatsExit(
                                                            context, dataChat,
                                                            onExit: (context) {
                                                          moduleSendBird
                                                              .leaveChannel(
                                                                  dataChat.id);
                                                          setState(() {
                                                            _listChats.remove(
                                                                dataChat);
                                                          });
                                                        });
                                                      },
                                                      onSelectChat: () {
                                                        _doSelectChat(
                                                            context, dataChat);
                                                      },
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : widgetChatsEmpty(context),
                          ),
                        ],
                      ),
                widgetChatMessagePin(context, this, onSelectChat: () {
                  _doSelectChat(context, dataChatPin);
                }),
              ],
            ),
          ),
        ),
        Visibility(
          visible: _selectChatId.isNotEmpty || _isLoadingChatroom,
          child: Expanded(
            flex: 62,
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  left: BorderSide(width: 2, color: Color(0xFFF3F3F3)),
                ),
              ),
              child: _listScreenChatrooms.containsKey(_selectChatId) &&
                      !_isLoadingChatroom
                  ? _listScreenChatrooms[_selectChatId]!
                  : Center(
                      child: Container(
                        width: 40,
                        height: 40,
                        margin: const EdgeInsets.only(bottom: 20),
                        child: const CircularProgressIndicator(
                          color: colorPrimaryBlue,
                          strokeWidth: 2,
                        ),
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }

  void _doToggleNotification(BuildContext context, DataChat dataChat) {
    dbStore.toggleNotificationChat(dataChat);
    setState(() {
      dataChat.isNotification = dbStore.isNotificationChat(dataChat);
    });
  }

  void _doSelectChat(BuildContext context, DataChat dataChat) {
    setState(() {
      _autofocus = false;
    });
    closeKeyboard(context);

    _chatModule.markMessageAsRead(dataChat);
    setState(() {
      dataChat.unreadMessages = 0;
    });

    if (dataChat.id == _selectChatId) return;

    if (isTablet(context)) {
      setState(() {
        _isLoadingChatroom = true;
      });

      if (_listScreenChatrooms.containsKey(dataChat.id)) {
        _listScreenChatrooms.remove(dataChat.id);
      }

      Future.delayed(const Duration(milliseconds: 100), () {
        if (!_listScreenChatrooms.containsKey(dataChat.id)) {
          ScreenChatroom screenChatroom = ScreenChatroom(
            dataChat: dataChat,
            widthRatio: 0.62,
            onMessageSent: (DataMessage newMessage) {
              onMessageSent(newMessage);
            },
            onBackPressed: () {
              setState(() {
                _selectChatId = "";
              });
            },
          );

          _listScreenChatrooms[dataChat.id] = screenChatroom;
        }

        setState(() {
          _selectChatId = dataChat.id;
          _isLoadingChatroom = false;
        });
      });
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return ScreenChatroom(
          dataChat: dataChat,
          onMessageSent: (DataMessage newMessage) {
            onMessageSent(newMessage);
          },
        );
      }));
    }
  }

  Future<void> _doLoadChats() async {
    if (!moduleSendBird.isInitialized()) {
      await moduleSendBird.init();
    } else if (_isLoading) {
      return;
    }

    if (_searchController.text.isEmpty) {
      setState(() {
        _isLoading = true;
      });
    }

    await _chatModule
        .getUserChats()
        .then((List<DataChat> chats) {
          _listChats.clear();
          _listChatsAll.clear();

          if (kDebugMode) {
            print('chats ${chats[0].creator}');
          }

          if (_searchController.text.isNotEmpty) {
            _listChats.addAll(chats);
          } else {
            setState(() {
              _listChats.addAll(chats);
            });
          }

          setState(() {
            _listChatsAll.addAll(chats);
          });

          if (_searchController.text.isNotEmpty) {
            _doSearchChats(_searchController.text, false);
          }

          for (DataChat dataChat in chats) {
            if (dbStore.isNotificationChat(dataChat)) {
              showNotificationChat(dataChat);
            }
          }
        })
        .catchError((e) {})
        .whenComplete(() {
          setState(() {
            _isLoading = false;
          });
        });
  }

  void startIsolate() async {
    await Isolate.spawn(timerEntryPoint, receivePort.sendPort);
    receivePort.listen((data) {
      if (data == 'loadChats') {
        _doLoadChats();
      }
    });
  }

  static void timerEntryPoint(SendPort sendPort) {
    Timer.periodic(Duration(seconds: timeSecRefreshChat), (timer) {
      sendPort.send('loadChats');
    });
  }

  void updateChatList() {
    _doLoadChats();
  }

  void _doSearchChats(String query, bool showLoader) {
    if (showLoader && query.isNotEmpty) {
      setState(() {
        _isSearching = true;
      });
    }

    Future.delayed(const Duration(milliseconds: 100), () {
      List<DataChat> filtered = _listChatsAll.where((chat) {
        return chat.name.toLowerCase().contains(query.toLowerCase()) ||
            chat.lastMessage.content
                .toLowerCase()
                .contains(query.toLowerCase());
      }).toList();

      setState(() {
        _listChats.clear();
        _listChats.addAll(filtered);
        _isSearching = false;
        _isLoading = false;
      });
    });
  }

  void onMessageSent(DataMessage newMessage) {
    for (DataChat dataChat in _listChatsAll) {
      if (dataChat.id == newMessage.channelUrl) {
        setState(() {
          dataChat.lastMessage = newMessage;
          _doLoadChats();
        });
        break;
      }
    }

    for (DataChat dataChat in _listChats) {
      if (dataChat.id == newMessage.channelUrl) {
        setState(() {
          dataChat.lastMessage = newMessage;
          _doLoadChats();
        });
        break;
      }
    }
  }
}
