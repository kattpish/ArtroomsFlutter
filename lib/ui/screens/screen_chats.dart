// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sendbird_sdk/sendbird_sdk.dart';

import 'package:artrooms/beans/bean_message.dart';
import 'package:artrooms/main.dart';
import 'package:artrooms/ui/screens/screen_chatroom.dart';
import 'package:artrooms/ui/screens/screen_login.dart';
import 'package:artrooms/ui/screens/screen_profile.dart';
import 'package:artrooms/utils/debouncer.dart';
import 'package:artrooms/utils/utils.dart';
import 'package:artrooms/utils/utils_notifications.dart';

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
  final bool reInit;
  const ScreenChats({
    Key? key,
    this.reInit = false,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ScreenChatsState();
  }
}

class _ScreenChatsState extends State<ScreenChats> with WidgetsBindingObserver {
  bool _reInit = false;
  bool _isLoading = false;
  bool _isSearching = false;
  bool _autofocus = false;
  final List<DataChat> _listChats = [];
  final List<DataChat> _listChatsAll = [];
  final TextEditingController _searchController = TextEditingController();

  String _selectChatId = "";
  String _openedChatId = "";
  bool _isLoadingChatroom = false;
  final Map<String, ScreenChatroom> _listScreenChatrooms = {};
  final ModuleChat _chatModule = ModuleChat();

  final _debouncer = Debouncer(milliseconds: 100);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    FlutterAppBadger.removeBadge();

    _reInit = widget.reInit;

    addState(this);

    if (!dbStore.isLoggedIn()) {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) {
        return const ScreenLogin();
      }));
      return;
    }

    _requestPermissionAndLoadChat();

    _searchController.addListener(() {
      _debouncer.run(() {
        _doSearchChats(_searchController.text, true);
      });
    });
  }

  void _requestPermissionAndLoadChat() async {
    await requestPermissions(context);

    _doLoadChats();
  }

  @override
  void dispose() {
    _searchController.dispose();
    removeState(this);

    for (DataChat dataChat in _listChatsAll) {
      _chatModule.removeChannelEventHandler(dataChat.groupChannel!);
    }

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      _doLoadChats();
    }

    FlutterAppBadger.removeBadge();
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
      setState(() {
        _openedChatId = dataChat.id;
      });

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return ScreenChatroom(
          dataChat: dataChat,
          onMessageSent: (DataMessage newMessage) {
            onMessageSent(newMessage);
          },
          onBackPressed: () {
            Navigator.of(context).pop();
            setState(() {
              _openedChatId = "";
            });
          },
        );
      }));
    }
  }

  Future<void> _openChatFromNotification(String chatId) async {
    DataChat? dataChat =
        _listChatsAll.firstWhereOrNull((element) => element.id == chatId);

    if (dataChat != null) {
      Future.delayed(const Duration(milliseconds: 500), () {
        _doSelectChat(context, dataChat);
      });
    }
  }

  Future<void> _doLoadChats() async {
    await moduleSendBird.init(
      onNotificationSelected: (String chatId) {
        _openChatFromNotification(chatId);
      },
      reInit: _reInit,
    );

    if (_isLoading) {
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
            _chatModule.addChannelEventHandler(dataChat.groupChannel!,
                CustomChannelEventHandler(
              callback: (channel) {
                if (channel is GroupChannel) {
                  setState(() {
                    final newDataChat = DataChat.fromGroupChannel(channel);

                    int index = _listChats
                        .indexWhere((c) => c.id == channel.channelUrl);
                    if (index != -1) {
                      _listChats[index] = newDataChat;
                    }

                    int indexAll = _listChatsAll
                        .indexWhere((c) => c.id == channel.channelUrl);
                    if (indexAll != -1) {
                      _listChatsAll[indexAll] = newDataChat;
                    }

                    if (channel.lastMessage != null) {
                      _showNotif(newDataChat, channel.lastMessage!);
                    }
                  });
                }
              },
            ));
          }
        })
        .catchError((e) {})
        .whenComplete(() {
          setState(() {
            _isLoading = false;
            _reInit = false;
          });
        });
  }

  void _showNotif(DataChat newDataChat, BaseMessage message) {
    if (newDataChat.id != _openedChatId) {
      showNotificationMessage(
          newDataChat, DataMessage.fromBaseMessage(message));
    }
  }

  void _doSearchChats(String query, bool showLoader) {
    if (showLoader && query.isNotEmpty) {
      setState(() {
        _isSearching = true;
      });
    }

    List<DataChat> filtered = query.isEmpty
        ? _listChatsAll
        : _listChatsAll.where((chat) {
            return chat.name.toLowerCase().contains(query.toLowerCase()) ||
                chat.lastMessage.content
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                (chat.creator?.nickname ?? "")
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                (chat.groupChannel != null &&
                    chat.groupChannel!.members
                        .where((member) =>
                            member.nickname
                                .toLowerCase()
                                .contains(query.toLowerCase()) ||
                            member.userId
                                .toLowerCase()
                                .contains(query.toLowerCase()))
                        .isNotEmpty);
          }).toList();

    setState(() {
      _listChats.clear();
      _listChats.addAll(filtered);
      _isSearching = false;
      _isLoading = false;
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
