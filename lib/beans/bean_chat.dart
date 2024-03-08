
import 'package:sendbird_sdk/sendbird_sdk.dart';
import '../utils/utils.dart';
import 'bean_message.dart';


class MyChat {

  final String id;
  final String name;
  final String lastMessage;
  final int unreadMessages;
  final String date;
  String role = "윰윰";
  String profilePictureUrl = "";

  MyChat({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.unreadMessages,
    required this.profilePictureUrl,
    required this.date,
  });

  factory MyChat.fromGroupChannel(GroupChannel channel) {

    final BaseMessage? lastBaseMessage = channel.lastMessage;
    String lastMessageText = '';
    String messageDate = '';

    if (lastBaseMessage != null) {
      MyMessage lastMessage = MyMessage.fromBaseMessage(lastBaseMessage);
      lastMessageText = lastMessage.getSummary();
      messageDate = formatDateTime(lastBaseMessage.createdAt);
    }

    final MyChat myChat = MyChat(
      id: channel.channelUrl,
      name: channel.name ?? "",
      lastMessage: lastMessageText,
      unreadMessages: channel.unreadMessageCount,
      profilePictureUrl: channel.coverUrl ?? '',
      date: messageDate,
    );

    if(myChat.name == "artrooms") {
      myChat.profilePictureUrl = "https://d2ous6lm13gwvv.cloudfront.net/image/2310190543464346_bc8443ee-ac3a-4306-adab-fd925492a358.jpg";
    }

    return myChat;
  }

}
