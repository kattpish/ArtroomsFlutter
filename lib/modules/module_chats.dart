
import 'package:sendbird_sdk/core/channel/group/group_channel.dart';

import '../beans/bean_chat.dart';
import '../main.dart';


class ChatModule {

  Future<List<MyChat>> getUserChats() async {

    final List<MyChat> chats = [];

    await moduleSendBird.getListOfGroupChannels().then((List<GroupChannel> groupChannels) {

      for (GroupChannel groupChannel in groupChannels) {
        final MyChat myChat = MyChat.fromGroupChannel(groupChannel);
        chats.add(myChat);
      }

    });

    return chats;
  }

}
