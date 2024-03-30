
import 'package:artrooms/data/module_datastore.dart';
import 'package:sendbird_sdk/sendbird_sdk.dart';
import '../utils/utils.dart';
import 'bean_message.dart';


class DataChat {

  GroupChannel groupChannel;
  final String id;
  final String name;
  String nameKr = " ";
  final int unreadMessages;
  final String date;
  String role = "";
  String profilePictureUrl = "";
  DataMessage lastMessage = DataMessage.empty();
  bool isArtrooms = false;
  bool isNotification = true;

  DataChat({
    required this.groupChannel,
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.unreadMessages,
    required this.profilePictureUrl,
    required this.date,
  });

  factory DataChat.fromGroupChannel(GroupChannel groupChannel) {

    final BaseMessage? lastBaseMessage = groupChannel.lastMessage;
    String messageDate = '';

    DataMessage lastMessage = DataMessage.empty();
    if (lastBaseMessage != null) {
      lastMessage = DataMessage.fromBaseMessage(lastBaseMessage);
      messageDate = formatDateTime(lastBaseMessage.createdAt);
    }

    final DataChat dataChat = DataChat(
      groupChannel: groupChannel,
      id: groupChannel.channelUrl,
      name: groupChannel.name ?? "",
      lastMessage: lastMessage,
      unreadMessages: groupChannel.unreadMessageCount,
      profilePictureUrl: groupChannel.coverUrl ?? groupChannel.coverUrl ??'',
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
