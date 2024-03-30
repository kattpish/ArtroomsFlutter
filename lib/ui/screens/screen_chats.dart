
import 'dart:async';

import 'package:artrooms/main.dart';
import 'package:artrooms/ui/screens/screen_chatroom.dart';
import 'package:artrooms/ui/screens/screen_login.dart';
import 'package:artrooms/ui/screens/screen_profile.dart';
import 'package:artrooms/utils/utils_notifications.dart';
import 'package:flutter/material.dart';

import '../../beans/bean_chat.dart';
import '../../modules/module_chats.dart';
import '../../data/module_datastore.dart';
import '../../utils/utils_permissions.dart';
import '../../utils/utils_screen.dart';
import '../theme/theme_colors.dart';
import '../widgets/widget_chats.dart';
import '../widgets/widget_chats_row.dart';
import '../widgets/widget_loader.dart';


class ScreenChats extends StatefulWidget {

  const ScreenChats({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ScreenChatsState();
  }

}

class _ScreenChatsState extends State<ScreenChats> with WidgetsBindingObserver  {

  bool _isLoading = false;
  bool _isSearching = false;
  final List<DataChat> _listChats = [];
  final List<DataChat> _listChatsAll = [];
  final TextEditingController _searchController = TextEditingController();
  late Timer _timer;

  String _selectChatId = "";
  bool _isLoadingChatroom = false;
  final Map<String, ScreenChatroom> _listScreenChatrooms = {};
  final ChatModule _chatModule = ChatModule();

  @override
  void initState() {
    super.initState();

    if(!DBStore().isLoggedIn()) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
        return const ScreenLogin();
      }));
      return;
    }
    requestPermissions(context);

    _loadChats();
    _timer = Timer.periodic(const Duration(seconds: 15), (timer) {
      _loadChats();
    });

    _searchController.addListener(() {
      _searchChats(_searchController.text);
    });

  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {

    if (state == AppLifecycleState.resumed) {
      _loadChats();
    }

  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 38,
          child: MaterialApp(
            title: 'Chats',
            home: Scaffold(
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
                actions: [
                  IconButton(
                      icon: const Icon(
                          Icons.more_vert,
                          color: colorMainGrey250
                      ),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return const ScreenProfile();
                        }));
                      }
                  ),
                ],
              ),
              body: _isLoading && _listChats.isEmpty
                  ? const WidgetLoader()
                  : Column(
                children: [
                  Visibility(
                    visible: _isSearching || _listChats.isNotEmpty || _searchController.text.isNotEmpty,
                    child: Container(
                      height: 44,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: '',
                          suffixIcon: !_isSearching
                              ? Icon(
                              Icons.search,
                              size: 30,
                              color: _searchController.text.isNotEmpty ? colorPrimaryBlue : colorMainGrey300
                          ) : Container(
                            width: 20,
                            height: 20,
                            padding: const EdgeInsets.all(15),
                            child: const CircularProgressIndicator(
                              color: colorPrimaryBlue,
                              strokeWidth: 2,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
                        ),
                        onChanged: (value) {},
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: (_listChats.isNotEmpty || _isSearching)
                        ? ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: _listChats.length,
                      itemBuilder: (context, index) {
                        DataChat dataChat = _listChats[index];
                        return Container(
                          key: Key(_listChats[index].id),
                          child: widgetChatRow(context, index, dataChat,
                            onClickOption1: () {
                              _onClickOption1(context, dataChat);
                            },
                            onClickOption2: () {
                              _onClickOption2(context, dataChat);
                            },
                            onSelectChat: () {
                              _onSelectChat(context, dataChat);
                            },
                          ),
                        );
                      },
                    )
                        : buildNoChats(context),
                  ),
                ],
              ),
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
              child: _listScreenChatrooms.containsKey(_selectChatId) && !_isLoadingChatroom
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
        )
      ],
    );
  }

  void _onClickOption1(BuildContext context, DataChat dataChat) {
    dbStore.toggleNotificationChat(dataChat);
    setState(() {
      dataChat.isNotification = dbStore.isNotificationChat(dataChat);
    });
  }

  void _onClickOption2(BuildContext context, DataChat dataChat) {
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
                  style: TextStyle(
                    color: Color(0xFF1F1F1F),
                    fontSize: 20,
                    fontFamily: 'SUIT',
                    fontWeight: FontWeight.w600,
                    height: 0,
                    letterSpacing: -0.40,
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  '대화 내용이 모두 삭제됩니다.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF6B6B6B),
                    fontSize: 16,
                    fontFamily: 'SUIT',
                    fontWeight: FontWeight.w400,
                    height: 0,
                    letterSpacing: -0.32,
                  ),
                ),
                const SizedBox(height: 50),
                Container(
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        moduleSendBird.leaveChannel(dataChat.id);
                        _listChats.remove(dataChat);
                      });
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
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
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'SUIT',
                        fontWeight: FontWeight.w700,
                        height: 0,
                        letterSpacing: -0.32,
                      ),
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

  void _onSelectChat(BuildContext context, DataChat dataChat) {

    _chatModule.markMessageAsRead(dataChat);

    if(dataChat.id == _selectChatId) return;

    if(isTablet(context)) {

      setState(() {
        _isLoadingChatroom = true;
      });

      if(_listScreenChatrooms.containsKey(dataChat.id)) {
        _listScreenChatrooms.remove(dataChat.id);
      }

      Future.delayed(const Duration(milliseconds: 100), () {

        if(!_listScreenChatrooms.containsKey(dataChat.id)) {

          ScreenChatroom screenChatroom = ScreenChatroom(
            chat: dataChat,
            widthRatio: 0.62,
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

    }else {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return ScreenChatroom(chat: dataChat);
      }));
    }
  }

  Future<void> _loadChats() async {

    if(_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    await _chatModule.getUserChats().then((List<DataChat> chats) {

      _listChats.clear();
      _listChatsAll.clear();

      setState(() {
        _listChats.addAll(chats);
        _listChatsAll.addAll(chats);
      });

      for(DataChat dataChat in chats) {
        if(dbStore.isNotificationChat(dataChat)) {
          showNotificationChat(dataChat);
        }
      }

    }).catchError((e) {

    }).whenComplete(() {

      setState(() {
        _isLoading = false;
      });

    });

  }

  void _searchChats(String query) {

    setState(() {
      if(query.isNotEmpty) {
        _isSearching = true;
      }
    });

    Future.delayed(const Duration(milliseconds: 100), () {

      List<DataChat> filtered = _listChatsAll.where((chat) {
        return chat.name.toLowerCase().contains(query.toLowerCase()) ||
            chat.lastMessage.content.toLowerCase().contains(query.toLowerCase());
      }).toList();

      setState(() {
        _listChats.clear();
        _listChats.addAll(filtered);
        _isSearching = false;
        _isLoading = false;
      });

    });

  }

}
