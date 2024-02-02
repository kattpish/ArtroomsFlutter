import 'package:artrooms/ui/screens/screen_chatroom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../beans/chat.dart';
import '../../utils/MyUtils.dart';

class MyChatListScreen extends StatelessWidget {

  MyChatListScreen({super.key});

  final List<Chat> chats = [
    Chat(
      id: '1',
      name: '아티스트 A',
      lastMessage: '안녕하세요! 오늘 프로젝트 어땠나요?',
      unreadMessages: 3,
      profilePictureUrl: 'https://via.placeholder.com/150',
      date: "2024-02-02 23:46",
    ),
    Chat(
      id: '2',
      name: '아티스트 B',
      lastMessage: '내일 미팅 준비 다 되셨나요?',
      unreadMessages: 1,
      profilePictureUrl: 'https://via.placeholder.com/150',
      date: "2024-02-01 23:46",
    ),
    Chat(
      id: '3',
      name: '아티스트 C',
      lastMessage: '프로젝트 마감일 확인 부탁드립니다.',
      unreadMessages: 5,
      profilePictureUrl: 'https://via.placeholder.com/150',
      date: "2024-01-16",
    ),
    Chat(
      id: '4',
      name: '아티스트 A',
      lastMessage: '안녕하세요! 오늘 프로젝트 어땠나요?',
      unreadMessages: 3,
      profilePictureUrl: 'https://via.placeholder.com/150',
      date: "2023-07-16",
    ),
    Chat(
      id: '5',
      name: '아티스트 B',
      lastMessage: '내일 미팅 준비 다 되셨나요?',
      unreadMessages: 1,
      profilePictureUrl: 'https://via.placeholder.com/150',
      date: "2023-07-16",
    ),
    Chat(
      id: '6',
      name: '아티스트 C',
      lastMessage: '프로젝트 마감일 확인 부탁드립니다.',
      unreadMessages: 5,
      profilePictureUrl: 'https://via.placeholder.com/150',
      date: "2023-07-16",
    ),
    Chat(
      id: '7',
      name: '아티스트 A',
      lastMessage: '안녕하세요! 오늘 프로젝트 어땠나요?',
      unreadMessages: 3,
      profilePictureUrl: 'https://via.placeholder.com/150',
      date: "2023-07-16",
    ),
    Chat(
      id: '8',
      name: '아티스트 B',
      lastMessage: '내일 미팅 준비 다 되셨나요?',
      unreadMessages: 1,
      profilePictureUrl: 'https://via.placeholder.com/150',
      date: "2023-07-16",
    ),
    Chat(
      id: '9',
      name: '아티스트 C',
      lastMessage: '프로젝트 마감일 확인 부탁드립니다.',
      unreadMessages: 5,
      profilePictureUrl: 'https://via.placeholder.com/150',
      date: "2023-07-16",
    ),
    Chat(
      id: '10',
      name: '아티스트 A',
      lastMessage: '안녕하세요! 오늘 프로젝트 어땠나요?',
      unreadMessages: 3,
      profilePictureUrl: 'https://via.placeholder.com/150',
      date: "2023-07-16",
    ),
    Chat(
      id: '11',
      name: '아티스트 B',
      lastMessage: '내일 미팅 준비 다 되셨나요?',
      unreadMessages: 1,
      profilePictureUrl: 'https://via.placeholder.com/150',
      date: "2023-07-16",
    ),
    Chat(
      id: '12',
      name: '아티스트 C',
      lastMessage: '프로젝트 마감일 확인 부탁드립니다.',
      unreadMessages: 5,
      profilePictureUrl: 'https://via.placeholder.com/150',
      date: "2023-07-16",
    ),
  ];

  @override
  Widget build(BuildContext context) {
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
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: '',
                  suffixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
            ),
            Expanded(
              child: chats.isNotEmpty
                  ? ListView.builder(
                itemCount: chats.length,
                itemBuilder: (context, index) {
                  return Container(
                    key: Key(chats[index].id),
                    child: buildListTile(context, index),
                  );
                },
              )
                  : const Center(
                child: Text('No chats found'),
              ),
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
        motion: ScrollMotion(),
        children: [
          SlidableAction(
            flex: 2,
            onPressed: doNothing,
            backgroundColor: Colors.grey,
            foregroundColor: Colors.white,
            icon: Icons.archive,
            label: '',
          ),
          SlidableAction(
            onPressed: doNothing,
            backgroundColor: Color(0xFF6A79FF),
            foregroundColor: Colors.white,
            icon: Icons.save,
            label: '',
          ),
        ],
      ),

      child:  ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(chats[index].profilePictureUrl),
        ),
        title: Text(chats[index].name),
        subtitle: Text(chats[index].lastMessage),
        trailing: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              formatChatDateString(chats[index].date),
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xFF6A79FF),
                shape: BoxShape.circle,
              ),
              child: Text(
                chats[index].unreadMessages.toString(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatDetailScreen(chat: chats[index]),
            ),
          );
        },
      ),
    );
  }

  void doNothing(BuildContext context) {}

  void _onSelectMenuItem(String value) {
    switch (value) {
      case 'Refresh':
      // TODO: Implement refresh action
        break;
      case 'Settings':
      // TODO: Implement settings action
        break;
    }
  }

}
