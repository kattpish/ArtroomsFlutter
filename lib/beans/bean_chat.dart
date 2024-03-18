
import 'package:sendbird_sdk/sendbird_sdk.dart';
import '../utils/utils.dart';
import 'bean_message.dart';


class DataChat {

  final String id;
  final String name;
  final int unreadMessages;
  final String date;
  String role = "윰윰";
  String profilePictureUrl = "";
  MyMessage lastMessage = MyMessage.empty();

  DataChat({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.unreadMessages,
    required this.profilePictureUrl,
    required this.date,
  });

  factory DataChat.fromGroupChannel(GroupChannel channel) {

    final BaseMessage? lastBaseMessage = channel.lastMessage;
    String messageDate = '';

    MyMessage lastMessage = MyMessage.empty();
    if (lastBaseMessage != null) {
      lastMessage = MyMessage.fromBaseMessage(lastBaseMessage);
      messageDate = formatDateTime(lastBaseMessage.createdAt);
    }

    final DataChat myChat = DataChat(
      id: channel.channelUrl,
      name: channel.name ?? "",
      lastMessage: lastMessage,
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
