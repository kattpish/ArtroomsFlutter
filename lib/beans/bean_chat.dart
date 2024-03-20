
import 'package:artrooms/data/module_datastore.dart';
import 'package:sendbird_sdk/sendbird_sdk.dart';
import '../utils/utils.dart';
import 'bean_message.dart';


class DataChat {

  final String id;
  final String name;
  String nameKr = " ";
  final int unreadMessages;
  final String date;
  String role = "";
  String profilePictureUrl = "";
  MyMessage lastMessage = MyMessage.empty();
  bool isArtrooms = false;
  bool isNotification = true;

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

    final DataChat dataChat = DataChat(
      id: channel.channelUrl,
      name: channel.name ?? "",
      lastMessage: lastMessage,
      unreadMessages: channel.unreadMessageCount,
      profilePictureUrl: channel.coverUrl ?? channel.coverUrl ??'',
      date: messageDate,
    );

    if(dataChat.name == "artrooms" || dataChat.name == "artroom") {
      dataChat.isArtrooms = true;
      dataChat.nameKr = "아트룸즈";
      if(dataChat.profilePictureUrl.isEmpty) {
        dataChat.profilePictureUrl = "https://d2ous6lm13gwvv.cloudfront.net/image/2310190543464346_bc8443ee-ac3a-4306-adab-fd925492a358.jpg";
      }
    }

    dataChat.isNotification = DBStore().isNotificationChat(dataChat);

    return dataChat;
  }

}
