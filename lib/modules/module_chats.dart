
import '../beans/bean_chat.dart';


List<MyChat> loadChats() {

  final List<MyChat> chats = [
    MyChat(
      id: '1',
      name: '아티스트',
      lastMessage: '안녕하세요 선생님! 오늘 내주신 수업 과제는 지난주랑 같이 진행하면 될까요? 아니',
      unreadMessages: 3,
      profilePictureUrl: 'https://via.placeholder.com',
      date: "2024-02-06 23:46",
    ),
    MyChat(
      id: '2',
      name: '아티스트',
      lastMessage: '내일 미팅 준비 다 되셨나요?',
      unreadMessages: 1,
      profilePictureUrl: 'https://via.placeholder.com',
      date: "2024-02-04 23:46",
    ),
    // MyChat(
    //   id: '3',
    //   name: '아티스트',
    //   lastMessage: '프로젝트 마감일 확인 부탁드립니다.',
    //   unreadMessages: 5,
    //   profilePictureUrl: 'https://via.placeholder.com',
    //   date: "2024-01-16",
    // ),
    MyChat(
      id: '4',
      name: '아티스트',
      lastMessage: '안녕하세요! 오늘 프로젝트 어땠나요?',
      unreadMessages: 3,
      profilePictureUrl: 'https://via.placeholder.com',
      date: "2024-02-01 23:46",
    ),
    MyChat(
      id: '5',
      name: '아티스트',
      lastMessage: '내일 미팅 준비 다 되셨나요?',
      unreadMessages: 0,
      profilePictureUrl: 'https://via.placeholder.com',
      date: "2024-01-26 23:46",
    ),
    // MyChat(
    //   id: '6',
    //   name: '아티스트',
    //   lastMessage: '프로젝트 마감일 확인 부탁드립니다.',
    //   unreadMessages: 5,
    //   profilePictureUrl: 'https://via.placeholder.com',
    //   date: "2023-07-16",
    // ),
    // MyChat(
    //   id: '7',
    //   name: '아티스트',
    //   lastMessage: '안녕하세요! 오늘 프로젝트 어땠나요?',
    //   unreadMessages: 3,
    //   profilePictureUrl: 'https://via.placeholder.com',
    //   date: "2023-07-16",
    // ),
    MyChat(
      id: '8',
      name: '아티스트',
      lastMessage: '내일 미팅 준비 다 되셨나요?',
      unreadMessages: 8,
      profilePictureUrl: 'https://via.placeholder.com',
      date: "2024-01-25 23:46",
    ),
    // MyChat(
    //   id: '9',
    //   name: '아티스트',
    //   lastMessage: '프로젝트 마감일 확인 부탁드립니다.',
    //   unreadMessages: 5,
    //   profilePictureUrl: 'https://via.placeholder.com',
    //   date: "2023-07-16",
    // ),
    // MyChat(
    //   id: '10',
    //   name: '아티스트',
    //   lastMessage: '안녕하세요! 오늘 프로젝트 어땠나요?',
    //   unreadMessages: 2,
    //   profilePictureUrl: 'https://via.placeholder.com',
    //   date: "2023-07-16",
    // ),
    MyChat(
      id: '11',
      name: '아티스트',
      lastMessage: '내일 미팅 준비 다 되셨나요?',
      unreadMessages: 0,
      profilePictureUrl: 'https://via.placeholder.com',
      date: "2024-01-24 23:46",
    ),
    MyChat(
      id: '12',
      name: '아티스트',
      lastMessage: '프로젝트 마감일 확인 부탁드립니다.',
      unreadMessages: 0,
      profilePictureUrl: 'https://via.placeholder.com',
      date: "2024-01-20 23:46",
    ),
  ];

  return chats;

}

List<MyChat> filterChats(String query) {
  List<MyChat> filtered = loadChats().where((chat) {
    return chat.name.toLowerCase().contains(query.toLowerCase()) ||
        chat.lastMessage.toLowerCase().contains(query.toLowerCase());
  }).toList();
  return filtered;
}