
import '../beans/bean_chat.dart';


List<MyChat> loadChats() {

  final List<MyChat> chats = [
    MyChat(
      id: '1',
      name: '아티스트 A',
      lastMessage: '안녕하세요 선생님! 오늘 내주신 수업 과제는 지난주랑 같이 진행하면 될까요? 아니',
      unreadMessages: 3,
      profilePictureUrl: 'https://via.placeholder.com/150',
      date: "2024-02-02 23:46",
    ),
    MyChat(
      id: '2',
      name: '아티스트 B',
      lastMessage: '내일 미팅 준비 다 되셨나요?',
      unreadMessages: 1,
      profilePictureUrl: 'https://via.placeholder.com/150',
      date: "2024-02-01 23:46",
    ),
    MyChat(
      id: '3',
      name: '아티스트 C',
      lastMessage: '프로젝트 마감일 확인 부탁드립니다.',
      unreadMessages: 5,
      profilePictureUrl: 'https://via.placeholder.com/150',
      date: "2024-01-16",
    ),
    MyChat(
      id: '4',
      name: '아티스트 D',
      lastMessage: '안녕하세요! 오늘 프로젝트 어땠나요?',
      unreadMessages: 3,
      profilePictureUrl: 'https://via.placeholder.com/150',
      date: "2023-07-16",
    ),
    MyChat(
      id: '5',
      name: '아티스트 E',
      lastMessage: '내일 미팅 준비 다 되셨나요?',
      unreadMessages: 1,
      profilePictureUrl: 'https://via.placeholder.com/150',
      date: "2023-07-16",
    ),
    MyChat(
      id: '6',
      name: '아티스트 F',
      lastMessage: '프로젝트 마감일 확인 부탁드립니다.',
      unreadMessages: 5,
      profilePictureUrl: 'https://via.placeholder.com/150',
      date: "2023-07-16",
    ),
    MyChat(
      id: '7',
      name: '아티스트 G',
      lastMessage: '안녕하세요! 오늘 프로젝트 어땠나요?',
      unreadMessages: 3,
      profilePictureUrl: 'https://via.placeholder.com/150',
      date: "2023-07-16",
    ),
    MyChat(
      id: '8',
      name: '아티스트 H',
      lastMessage: '내일 미팅 준비 다 되셨나요?',
      unreadMessages: 1,
      profilePictureUrl: 'https://via.placeholder.com/150',
      date: "2023-07-16",
    ),
    MyChat(
      id: '9',
      name: '아티스트 I',
      lastMessage: '프로젝트 마감일 확인 부탁드립니다.',
      unreadMessages: 5,
      profilePictureUrl: 'https://via.placeholder.com/150',
      date: "2023-07-16",
    ),
    MyChat(
      id: '10',
      name: '아티스트 J',
      lastMessage: '안녕하세요! 오늘 프로젝트 어땠나요?',
      unreadMessages: 3,
      profilePictureUrl: 'https://via.placeholder.com/150',
      date: "2023-07-16",
    ),
    MyChat(
      id: '11',
      name: '아티스트 K',
      lastMessage: '내일 미팅 준비 다 되셨나요?',
      unreadMessages: 1,
      profilePictureUrl: 'https://via.placeholder.com/150',
      date: "2023-07-16",
    ),
    MyChat(
      id: '12',
      name: '아티스트 L',
      lastMessage: '프로젝트 마감일 확인 부탁드립니다.',
      unreadMessages: 5,
      profilePictureUrl: 'https://via.placeholder.com/150',
      date: "2023-07-16",
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