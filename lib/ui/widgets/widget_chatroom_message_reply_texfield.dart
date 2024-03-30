
import 'package:artrooms/ui/widgets/widget_chatroom_message_reply.dart';
import 'package:flutter/cupertino.dart';

import '../../beans/bean_message.dart';


Widget buildReplyForTextField(DataMessage? replyMessage, VoidCallback cancelReply) {
  return Container(
      padding: const EdgeInsets.all(8),
      child: WidgetChatroomMessageReply(
        message: replyMessage!,
        onCancelReply: cancelReply,
        key: null,
      ));
}
