
import 'package:sendbird_sdk/sendbird_sdk.dart';
import 'bean_message.dart';


class MyChat {
  final String id;
  final String name;
  final String lastMessage;
  final int unreadMessages;
  final String profilePictureUrl;
  final String date;
  List<MyMessage> messages = [];

  MyChat({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.unreadMessages,
    required this.profilePictureUrl,
    required this.date,
    required List<MyMessage> messages,
  });

  factory MyChat.fromGroupChannel(GroupChannel channel) {

    final lastMessage = channel.lastMessage;
    String lastMessageText = '';
    String messageDate = '';

    if (lastMessage != null) {
      lastMessageText = lastMessage.message;
      messageDate = DateTime.fromMillisecondsSinceEpoch(lastMessage.createdAt).toString();
    }

    return MyChat(
      id: channel.channelUrl,
      name: channel.name ?? "",
      lastMessage: lastMessageText,
      unreadMessages: channel.unreadMessageCount,
      profilePictureUrl: channel.coverUrl ?? '',
      date: messageDate,
      messages: [],
    );
  }

  factory MyChat.fromUrl(Map<String, dynamic> data) {

    final Map<String, dynamic> lastMessage = data["last_message"];

    String lastMessageText = lastMessage["message"];
    String messageDate = DateTime.fromMillisecondsSinceEpoch(lastMessage["created_at"]).toString();

    return MyChat(
      id: data["channel_url"],
      name: data["name"],
      lastMessage: lastMessageText,
      unreadMessages: data["unread_mention_count"],
      profilePictureUrl: data["cover_url"],
      date: messageDate,
      messages: [],
    );
  }

}
