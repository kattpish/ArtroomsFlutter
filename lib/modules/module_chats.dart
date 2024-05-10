
import 'package:sendbird_sdk/core/channel/group/group_channel.dart';

import '../beans/bean_chat.dart';
import '../main.dart';


class ModuleChat {

  Future<List<DataChat>> getUserChats() async {

    final List<DataChat> chats = [];

    await moduleSendBird.getListOfGroupChannels().then((List<GroupChannel> groupChannels) {
      for (GroupChannel groupChannel in groupChannels) {
        final DataChat myChat = DataChat.fromGroupChannel(groupChannel);
        chats.add(myChat);
      }
    });

    return chats;
  }

  Future<void> markMessageAsRead(DataChat dataChat) async {
    if(dataChat.groupChannel != null) {
      moduleSendBird.markMessageAsRead(dataChat.groupChannel!);
    }
  }

}
