
import 'dart:math';

import '../beans/bean_message.dart';


List<MyMessage> loadMessages() {

  List<MyMessage> messages = [];

  messages = List.generate(12, (index) {
    int i = Random().nextInt(99) + 11;
    bool isMe = (Random().nextInt(2) + 1) == 1;
    return MyMessage(
      senderId: i,
      senderName: 'User $i',
      content: 'This is message ${index + 1}',
      timestamp: '12:00 PM',
      attachment: '-',
      isMe: isMe,
    );
  });

  return messages;
}
