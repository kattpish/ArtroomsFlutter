
import 'package:sendbird_sdk/core/channel/group/group_channel.dart';
import 'package:sendbird_sdk/core/message/base_message.dart';
import 'package:sendbird_sdk/core/message/user_message.dart';

import '../beans/bean_message.dart';
import '../main.dart';


class ModuleMessages {

  late final String _channelUrl;
  late final GroupChannel _groupChannel;
  bool _isInitialized = false;

  ModuleMessages(String channelUrl) {
    _channelUrl = channelUrl;
  }

  Future<GroupChannel> initChannel() async {

    await GroupChannel.getChannel(_channelUrl).then((GroupChannel groupChannel) {
      _groupChannel = groupChannel;
    });

    _isInitialized = true;

    return _groupChannel;
  }

  Future<List<MyMessage>> getMessages() async {

    if(!_isInitialized) {
      await initChannel();
    }

    final List<MyMessage> messages = [];

    await moduleSendBird.loadMessages(_groupChannel).then((List<BaseMessage> baseMessages) {

      for(BaseMessage baseMessage in baseMessages) {
        final MyMessage myMessage = MyMessage.fromBaseMessage(baseMessage);
        messages.add(myMessage);
      }

    });

    return messages;
  }

  Future<UserMessage> sendMessage(String text) async {

    if(!_isInitialized) {
      await initChannel();
    }

    return await moduleSendBird.sendMessage(_groupChannel, text);
  }

}

