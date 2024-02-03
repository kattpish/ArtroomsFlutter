import 'package:artrooms/modules/module_chats.dart';
import 'package:artrooms/ui/screens/screen_chatroom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../beans/bean_chat.dart';
import '../../utils/utils.dart';
import '../theme/theme_colors.dart';
import '../widgets/widget_loader.dart';


class MyChatsScreen extends StatefulWidget {

  const MyChatsScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MyChatsScreenState();
  }

}

class _MyChatsScreenState extends State<MyChatsScreen> {

  bool isLoading = true;
  bool isSearching = false;
  final List<MyChat> chats = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        isLoading = false;
        chats.addAll(loadChats());
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    searchController.addListener(() {
      searchChats(searchController.text);
    });

    return MaterialApp(
      title: 'Chats',
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            '채팅',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            PopupMenuButton<String>(
              onSelected: _onSelectMenuItem,
              itemBuilder: (BuildContext context) {
                return {'Refresh', 'Settings'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
              icon: const Icon(Icons.more_vert, color: Colors.grey),
            ),
          ],
        ),
        body: isLoading ? const MyLoader() : Column(
          children: [
            Visibility(
              visible: isSearching || chats.isNotEmpty || searchController.text.isNotEmpty,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: '',
                    suffixIcon: !isSearching ? Icon(
                        Icons.search,
                        size: 30,
                        color: searchController.text.isNotEmpty ? colorPrimaryPurple : Colors.grey
                    ) : Container(
                      width: 20,
                      height: 20,
                      padding: const EdgeInsets.all(15.0),
                      child: const CircularProgressIndicator(
                        color: colorPrimaryPurple,
                        strokeWidth: 2,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  onChanged: (value) {},
                ),
              ),
            ),
            Expanded(
              child: (chats.isNotEmpty && !isSearching)
                  ? ListView.builder(
                itemCount: chats.length,
                itemBuilder: (context, index) {
                  return Container(
                    key: Key(chats[index].id),
                    child: buildListTile(context, index),
                  );
                },
              )
                  : buildNoChats(context),
            ),
          ],
        ),
      ),
    );
  }

  Slidable buildListTile(BuildContext context, int index) {
    return Slidable(
      key: const ValueKey(0),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            flex: 1,
            onPressed: _onClickOption1,
            backgroundColor: colorMainGrey300,
            foregroundColor: Colors.white,
            icon: Icons.notifications,
          ),
          SlidableAction(
            flex: 1,
            onPressed: _onClickOption2,
            backgroundColor: colorPrimaryPurple,
            foregroundColor: Colors.white,
            icon: Icons.send_to_mobile,
          ),
        ],
      ),

      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(chats[index].profilePictureUrl),
        ),
        title: Text(chats[index].name),
        subtitle: Text(chats[index].lastMessage),
        trailing: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              formatChatDateString(chats[index].date),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: colorPrimaryPurple,
                shape: BoxShape.circle,
              ),
              child: Text(
                chats[index].unreadMessages.toString(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return MyScreenChatroom(chat: chats[index]);
          }));
        },
      ),
    );
  }

  Widget buildNoChats(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/icons/chat_blue.png',
            width: 80.0,
            height: 80.0,
          ),
          const SizedBox(height: 20),
          const Text(
            '채팅방이 없어요',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            '아트룸즈 홈페이지에서 상담신청을 하시거나\n라이브 클래스가 개설되면 채팅방이 개설됩니다',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.0,
              color: colorMainGrey700,
            ),
          ),
        ],
      ),
    );
  }

  void _onClickOption1(BuildContext context) {

  }

  void _onClickOption2(BuildContext context) {
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
                  )
                  ,
                ),
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
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {

                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: colorPrimaryPurple,
                    backgroundColor: colorPrimaryPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    minimumSize: const Size(double.infinity, 50), // Button size
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


  void _onSelectMenuItem(String value) {
    switch (value) {
      case 'Refresh':

        break;
      case 'Settings':

        break;
    }
  }

  void searchChats(String query) {

    setState(() {
      if(query.isNotEmpty) {
        isSearching = true;
      }
    });

    Future.delayed(const Duration(seconds: 1), () {
      List<MyChat> filtered = filterChats(query);

      setState(() {
        chats.clear();
        chats.addAll(filtered);
        isSearching = false;
        isLoading = false;
      });
    });

  }

}
