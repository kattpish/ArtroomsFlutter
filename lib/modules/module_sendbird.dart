
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:sendbird_sdk/constant/enums.dart';
import 'package:sendbird_sdk/core/channel/base/base_channel.dart';
import 'package:sendbird_sdk/core/channel/group/group_channel.dart';
import 'package:sendbird_sdk/core/channel/open/open_channel.dart';
import 'package:sendbird_sdk/core/message/base_message.dart';
import 'package:sendbird_sdk/core/message/user_message.dart';
import 'package:sendbird_sdk/params/message_list_params.dart';
import 'package:sendbird_sdk/params/user_message_params.dart';
import 'package:sendbird_sdk/query/channel_list/group_channel_list_query.dart';
import 'package:sendbird_sdk/sdk/sendbird_sdk_api.dart';

import '../data/module_datastore.dart';


const userId = 'alain';

class MySendBird {

  late BaseChannel _channel;

  int? _earliestMessageTimestamp;
  bool isLoading = false;

  final MyDataStore myDataStore = MyDataStore();

  MySendBird() {
    isLoading = true;
  }

  Future<void> initSendbird() async {
    isLoading = true;

    try {

      final String email = myDataStore.getEmail();

      SendbirdSdk(
          appId: "01CFFFE8-F1B8-4BB4-A576-952ABDC8D08A",
          apiToken: "39ac9b8e2125ad49035c7bd9c105ccc9d4dc7ba4"
      );

      final user = await SendbirdSdk().connect(email);
      if (kDebugMode) {
        print('Connected as ${user.userId}');
      }

    } catch (e) {
      if (kDebugMode) {
        print('Sendbird connection error: $e');
      }
    }

    isLoading = false;
  }

  Future<void> joinChannel(id) async {
    isLoading = true;

    try {

      try {
        _channel = await GroupChannel.getChannel(id);
      }catch(e) {
        _channel = await OpenChannel.getChannel(id);
      }

      if (_channel is OpenChannel) {
        await (_channel as OpenChannel).enter();
      } else if (_channel is GroupChannel) {
        await (_channel as GroupChannel).join();
      }

      if (kDebugMode) {
        print('Channel joined $id');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Join channel error: $id : $e');
      }
    }

    isLoading = false;
  }

  Future<List<GroupChannel>> getListOfGroupChannels() async {

    Completer<List<GroupChannel>> completer = Completer<List<GroupChannel>>();

    try {
      GroupChannelListQuery query = GroupChannelListQuery();
      query.memberStateFilter = MemberStateFilter.all;
      query.order = GroupChannelListOrder.latestLastMessage;
      query.limit = 15;
      List<GroupChannel> channels = await query.loadNext();
      if (kDebugMode) {
        print('My GroupChannels: ${channels.length}');
      }
      completer.complete(channels);
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching group channels: $e');
      }
      completer.completeError(e);
    }

    return completer.future;
  }

  Future<List<BaseMessage>> loadMessages() async {
    Completer<List<BaseMessage>> completer = Completer<List<BaseMessage>>();

    if(!isLoading) {
      isLoading = true;

      try {
        final params = MessageListParams();
        params.previousResultSize = 20;
        params.reverse = true;

        final referenceTime = _earliestMessageTimestamp ?? DateTime.now().millisecondsSinceEpoch;
        final messages = await _channel.getMessagesByTimestamp(referenceTime, params);

        if (messages.isNotEmpty) {
          _earliestMessageTimestamp = messages.last.createdAt;
        }

        completer.complete(messages);
      } catch (e) {
        if (kDebugMode) {
          print('Load messages error: $e');
        }
        completer.completeError(e);
      }

      isLoading = false;

    }else {
      completer.complete([]);
    }

    return completer.future;
  }

  Future<UserMessage> sendMessage(String text) async {
    Completer<UserMessage> completer = Completer();

    final params = UserMessageParams(message: text);

    _channel.sendUserMessage(params, onCompleted: (UserMessage userMessage, error) {
      if (error != null) {
        if (kDebugMode) {
          print('Send message error: $error');
        }
        completer.completeError(error);
        return;
      }

      completer.complete(userMessage);
    });

    return completer.future;
  }

}