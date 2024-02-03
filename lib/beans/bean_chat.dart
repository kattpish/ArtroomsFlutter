
import 'bean_message.dart';


class MyChat {

  final String id;
  final String name;
  final String lastMessage;
  final int unreadMessages;
  final String profilePictureUrl;
  final String date;
  List<MyMessage> messages = [];

  MyChat({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.unreadMessages,
    required this.profilePictureUrl,
    required this.date,
  });

}
