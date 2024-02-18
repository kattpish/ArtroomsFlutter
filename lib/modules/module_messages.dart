
import 'dart:math';

import 'package:sendbird_sdk/core/message/base_message.dart';

import '../beans/bean_message.dart';
import 'module_sendbird.dart';


List<MyMessage> loadMessages() {

  MySendBird mySendBird = MySendBird();

  mySendBird.loadMessages().then((List<BaseMessage> baseMessages) {

    baseMessages[0].message;

  });

  List<MyMessage> messages = [];

  messages = List.generate(12, (index) {
    int i = Random().nextInt(99) + 11;
    bool isMe = index < 11 ? (Random().nextInt(2) + 1) == 1 : false;
    return MyMessage.fromBaseMessageWithDetails(
      index: i,
      senderId: i.toString(),
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
