
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:sendbird_sdk/core/channel/base/base_channel.dart';
import 'package:sendbird_sdk/core/channel/open/open_channel.dart';
import 'package:sendbird_sdk/core/message/base_message.dart';
import 'package:sendbird_sdk/core/message/user_message.dart';
import 'package:sendbird_sdk/params/message_list_params.dart';
import 'package:sendbird_sdk/params/user_message_params.dart';
import 'package:sendbird_sdk/sdk/sendbird_sdk_api.dart';


const userId = 'alain';

class MySendBird {

  late OpenChannel _channel;

  int? _earliestMessageTimestamp;
  bool isLoading = false;

  MySendBird() {
    isLoading = true;
  }

  Future<void> initSendbird() async {
    isLoading = true;

    try {
      SendbirdSdk(
          appId: "BC823AD1-FBEA-4F08-8F41-CF0D9D280FBF",
          apiToken: "f93b05ff359245af400aa805bafd2a091a173064"
      );
      final user = await SendbirdSdk().connect(userId,
          accessToken: "02de54411c3b107081cc75de3166aeebfb591af3"
      );
      if (kDebugMode) {
        print('Connected as ${user.userId}');
      }
      await _joinChannel();
    } catch (e) {
      if (kDebugMode) {
        print('Sendbird connection error: $e');
      }
    }

    isLoading = false;
  }

  Future<void> _joinChannel() async {
    isLoading = true;

    try {
      _channel = await OpenChannel.getChannel("sendbird_open_channel_14092_bf4075fbb8f12dc0df3ccc5c653f027186ac9211");
      await _channel.enter();
      if (kDebugMode) {
        print('Channel joined');
      }
      loadMessages();
    } catch (e) {
      if (kDebugMode) {
        print('Join channel error: $e');
      }
    }

    isLoading = false;
  }

  Future<List<BaseMessage>> loadMessages() async {
    Completer<List<BaseMessage>> completer = Completer<List<BaseMessage>>();

    if(!isLoading) {
      isLoading = true;

      try {
        final params = MessageListParams();
        params.previousResultSize = 20;
        params.reverse = true;

        final referenceTime = _earliestMessageTimestamp ?? DateTime
            .now()
            .millisecondsSinceEpoch;
        final messages = await _channel.getMessagesByTimestamp(
            referenceTime, params);

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

    UserMessage userMessage = _channel.sendUserMessage(params, onCompleted: (UserMessage userMessage, error) {
      if (error != null) {
        if (kDebugMode) {
          print('Send message error: $error');
        }
        completer.completeError(error);
        return;
      }

      completer.complete(userMessage);
    });

    // completer.complete(userMessage);

    return completer.future;
  }

}