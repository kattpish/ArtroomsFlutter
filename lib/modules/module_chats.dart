import 'package:sendbird_sdk/core/channel/base/base_channel.dart';
import 'package:sendbird_sdk/core/channel/group/group_channel.dart';
import 'package:sendbird_sdk/handlers/channel_event_handler.dart';

import '../beans/bean_chat.dart';
import '../main.dart';

class ModuleChat {
  Future<List<DataChat>> getUserChats() async {
    final List<DataChat> chats = [];

    await moduleSendBird
        .getListOfGroupChannels()
        .then((List<GroupChannel> groupChannels) {
      for (GroupChannel groupChannel in groupChannels) {
        final DataChat myChat = DataChat.fromGroupChannel(groupChannel);
        chats.add(myChat);
      }
    });

    return chats;
  }

  Future<void> markMessageAsRead(DataChat dataChat) async {
    if (dataChat.groupChannel != null) {
      moduleSendBird.markMessageAsRead(dataChat.groupChannel!);
    }
  }

  void addChannelEventHandler(
      GroupChannel groupChannel, ChannelEventHandler listener) {
    moduleSendBird.addChannelEventHandlerKey(
        "CHAT-LIST-${groupChannel.channelUrl}", listener);
  }

  void removeChannelEventHandler(GroupChannel groupChannel) {
    moduleSendBird
        .removeChannelEventHandlerKey("CHAT-LIST-${groupChannel.channelUrl}");
  }
}

class CustomChannelEventHandler extends ChannelEventHandler {
  final Function(BaseChannel channel) callback;

  CustomChannelEventHandler({required this.callback});

  @override
  void onChannelChanged(BaseChannel channel) {
    callback(channel);
  }
}
