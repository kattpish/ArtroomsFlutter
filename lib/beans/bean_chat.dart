import 'package:artrooms/main.dart';
import 'package:sendbird_sdk/sendbird_sdk.dart';
import '../utils/utils.dart';
import '../utils/utils_notifications.dart';
import 'bean_message.dart';

class DataChat {
  GroupChannel? groupChannel;
  final String id;
  String name;
  String nameKr = " ";
  int unreadMessages;
  final String date;
  String role = "";
  String profilePictureUrl = "";
  DataMessage lastMessage = DataMessage.empty();
  bool isArtrooms = false;
  bool isNotification = true;
  User? creator;

  DataChat({
    required this.groupChannel,
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.creator,
    this.unreadMessages = 0,
    this.profilePictureUrl = "",
    this.date = "",
  });

  factory DataChat.empty() {
    final DataChat dataChat = DataChat(
      id: "",
      name: "",
      groupChannel: null,
      lastMessage: DataMessage.empty(),
      creator: null,
    );
    return dataChat;
  }

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
      profilePictureUrl: groupChannel.coverUrl ?? groupChannel.coverUrl ?? '',
      date: messageDate,
      creator: groupChannel.creator,
    );

    if (dataChat.name == "artrooms" || dataChat.name == "artroom") {
      dataChat.isArtrooms = true;
      dataChat.nameKr = "아트룸즈";
      if (dataChat.profilePictureUrl.isEmpty) {
        dataChat.profilePictureUrl =
            "https://d2ous6lm13gwvv.cloudfront.net/image/2310190543464346_bc8443ee-ac3a-4306-adab-fd925492a358.jpg";
      }
    }

    dataChat.isNotification = dbStore.isNotificationChat(dataChat);

    return dataChat;
  }

  bool isNew() {
    return (DateTime.now().millisecondsSinceEpoch - lastMessage.timestamp <
        timeSecRefreshChat * 1000);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is DataChat && runtimeType == other.runtimeType && id == other.id;
  }

  @override
  int get hashCode {
    return id.hashCode;
  }
}
