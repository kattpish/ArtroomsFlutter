import 'package:sendbird_sdk/core/message/base_message.dart';
import 'package:sendbird_sdk/core/message/file_message.dart';

import '../main.dart';
import '../modules/module_sendbird.dart';
import '../utils/utils.dart';


class MyMessage {
  int index;
  String senderId;
  String senderName;
  String profilePictureUrl = "";
  String content;
  String timestamp;
  String attachment = "";
  List<String> imageAttachments = [];
  bool isMe;

  MyMessage.fromBaseMessageWithDetails({
    required this.index,
    required this.senderId,
    required this.senderName,
    required this.content,
    required this.timestamp,
    this.attachment = "",
    this.imageAttachments = const [],
    required this.isMe,
  });

  MyMessage.fromBaseMessage(BaseMessage baseMessage)
      : index = baseMessage.messageId,
        senderId = baseMessage.sender?.userId ?? "",
        senderName = baseMessage.sender?.nickname ?? "",
        content = baseMessage.message,
        timestamp = formatTimestamp(baseMessage.createdAt),
        isMe = baseMessage.sender?.userId.toString() == myDataStore.getUid(),
        attachment = "",
        imageAttachments = const [],
        profilePictureUrl = "" {

    if (baseMessage is FileMessage) {
      FileMessage fileMessage = baseMessage;
      // attachment = fileMessage.url;

      if (fileMessage.type.toString().startsWith('image/')) {
        // imageAttachments.add(fileMessage.url);
      }

    }
  }

  String getName() {
    return senderName.isNotEmpty ? senderName : senderId;
  }

}
