
import 'dart:math';

import '../beans/bean_message.dart';


List<MyMessage> loadMessages() {

  List<MyMessage> messages = [];

  messages = List.generate(12, (index) {
    int i = Random().nextInt(99) + 11;
    bool isMe = index < 11 ? (Random().nextInt(2) + 1) == 1 : false;
    return MyMessage(
      senderId: i,
      senderName: 'User $i',
      content: 'This is message ${index + 1}',
      timestamp: '12:0$index PM',
      attachment: index == 11 ? '-' : '',
      imageAttachments: index == 11 ? ["", "", ""] : [],
      isMe: isMe,
    );
  });

  return messages;
}
