import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;

import 'package:artrooms/beans/bean_message.dart';
import 'package:flutter/foundation.dart';
import 'package:sendbird_sdk/constant/enums.dart';
import 'package:sendbird_sdk/core/channel/base/base_channel.dart';
import 'package:sendbird_sdk/core/channel/group/group_channel.dart';
import 'package:sendbird_sdk/core/channel/open/open_channel.dart';
import 'package:sendbird_sdk/core/message/base_message.dart';
import 'package:sendbird_sdk/core/message/file_message.dart';
import 'package:sendbird_sdk/core/message/user_message.dart';
import 'package:sendbird_sdk/core/models/user.dart';
import 'package:sendbird_sdk/handlers/channel_event_handler.dart';
import 'package:sendbird_sdk/params/file_message_params.dart';
import 'package:sendbird_sdk/params/message_list_params.dart';
import 'package:sendbird_sdk/params/user_message_params.dart';
import 'package:sendbird_sdk/query/channel_list/group_channel_list_query.dart';
import 'package:sendbird_sdk/sdk/sendbird_sdk_api.dart';

import '../main.dart';
import '../utils/utils.dart';
import 'module_push_notifications.dart';

class ModuleSendBird {
  late final User user;
  bool _isInitialized = false;

  Future<void> initSendbird() async {
    try {
      if (!_isInitialized) {
        await initLocale();

        final String email = dbStore.getEmail();

        SendbirdSdk(
            appId: "01CFFFE8-F1B8-4BB4-A576-952ABDC8D08A",
            apiToken: "39ac9b8e2125ad49035c7bd9c105ccc9d4dc7ba4");

        user = await SendbirdSdk().connect(email);

        ModulePushNotifications modulePushNotifications =
            ModulePushNotifications();
        modulePushNotifications.init();
      }

      _isInitialized = true;
    } catch (e) {
      if (kDebugMode) {
        print('Sendbird connection error: $e');
      }
    }
  }

  bool isInitialized() {
    return _isInitialized;
  }

  Future<void> joinChannel(id) async {
    late BaseChannel channel;

    try {
      try {
        channel = await GroupChannel.getChannel(id);
      } catch (e) {
        channel = await OpenChannel.getChannel(id);
      }

      if (channel is OpenChannel) {
        await (channel).enter();
      } else if (channel is GroupChannel) {
        await (channel).join();
      }

      if (kDebugMode) {
        print('Channel joined $id');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Join channel error: $id : $e');
      }
    }
  }

  Future<void> leaveChannel(String channelUrl) async {
    late BaseChannel channel;

    try {
      try {
        channel = await GroupChannel.getChannel(channelUrl);
      } catch (e) {
        channel = await OpenChannel.getChannel(channelUrl);
      }

      if (channel is OpenChannel) {
        await (channel).exit();
      } else if (channel is GroupChannel) {
        await (channel).leave();
      }

      if (kDebugMode) {
        print('Channel joined $channelUrl');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Join channel error: $channelUrl : $e');
      }
    }
  }

  Future<List<GroupChannel>> getListOfGroupChannels() async {
    Completer<List<GroupChannel>> completer = Completer<List<GroupChannel>>();

    try {
      GroupChannelListQuery query = GroupChannelListQuery();
      query.memberStateFilter = MemberStateFilter.all;
      query.order = GroupChannelListOrder.latestLastMessage;
      List<GroupChannel> channels = await query.loadNext();
      if (kDebugMode) {
        print('My GroupChannels: ${channels[0].creator}');
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

  Future<List<User>> getGroupChannelMembers(String channelUrl) async {
    try {
      var channel = await GroupChannel.getChannel(channelUrl);
      List<User> members = channel.members;
      return members;
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching group channel members: $e');
      }
      return [];
    }
  }

  Future<List<BaseMessage>> loadMessages(
      GroupChannel groupChannel, int? earliestMessageTimestamp) async {
    Completer<List<BaseMessage>> completer = Completer<List<BaseMessage>>();

    try {
      print("...loadMessages init ${earliestMessageTimestamp}");
      final params = MessageListParams();
      params.previousResultSize = 200;
      params.reverse = true;

      final referenceTime =
          earliestMessageTimestamp ?? DateTime.now().millisecondsSinceEpoch;
      print("...loadMessages referenceTime $referenceTime ${params}");
      final messages =
          await groupChannel.getMessagesByTimestamp(referenceTime, params);
      print(
          "...loadMessages RESULT ${messages.length} /${messages.first.data}/");

      completer.complete(messages);
    } catch (e) {
      if (kDebugMode) {
        print('Load messages error: $e');
      }
      completer.completeError(e);
    }

    return completer.future;
  }

  Future<List<BaseMessage>> fetchAttachments(
      GroupChannel groupChannel, int? earliestMessageTimestamp) async {
    try {
      final params = MessageListParams();
      params.previousResultSize = 200;
      params.reverse = true;

      final referenceTime =
          earliestMessageTimestamp ?? DateTime.now().millisecondsSinceEpoch;
      final messages =
          await groupChannel.getMessagesByTimestamp(referenceTime, params);

      return messages;
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching attachments: $e");
      }
      return [];
    }
  }

  Future<UserMessage> sendMessage(GroupChannel groupChannel, String text,
      {String data = "",
      DataMessage? message,
      List<String>? mentionedUserIds}) async {
    final params = UserMessageParams(message: text);
    print('data.isNotEmpty ? data : message?.data ?? "" ${data.isNotEmpty ? data : message?.data ?? ""}');
    ParentMessage parentMessage = ParentMessage(
        message?.index ?? 0,
        message?.content ?? "",
        message?.senderId ?? "",
        message?.senderName ?? "",
        data.isNotEmpty ? data : message?.data ?? "");
    params.mentionedUserIds = mentionedUserIds ?? [];
    // params.data = (data.isNotEmpty || (message?.senderName ?? "").isNotEmpty)
    //     ? const JsonEncoder().convert(parentMessage)
    //     : "";

    params.data = const JsonEncoder().convert(parentMessage).replaceAll('\\','').replaceAll('"["','["').replaceAll('"]"','"]');
    print(
        "===================sendMessage 1${params.data}");
    return performSendMessage(groupChannel, text, params);
  }

  Future<UserMessage> performSendMessage(
      GroupChannel groupChannel, String text, UserMessageParams params) async {
    Completer<UserMessage> completer = Completer();

    groupChannel.sendUserMessage(params,
        onCompleted: (UserMessage userMessage, error) {
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

  Future<FileMessage> sendMessageFile(
      GroupChannel groupChannel, File file) async {
    Completer<FileMessage> completer = Completer();

    String fileName = path.basename(Uri.parse(file.path).path);

    final params = FileMessageParams.withFile(file, name: fileName);

    if (kDebugMode) {
      print('Sending message file: ${file.path}');
    }

    groupChannel.sendFileMessage(params,
        onCompleted: (FileMessage userMessage, error) {
      if (error != null) {
        if (kDebugMode) {
          print('Send message file error: $error');
        }
        completer.completeError(error);
        return;
      }

      if (kDebugMode) {
        print('Sent message file: ${file.path}');
      }

      completer.complete(userMessage);
    });

    return completer.future;
  }

  Future<DataMessage> sendMessageFiles(
      GroupChannel groupChannel, List<File> files) async {
    Completer<DataMessage> completer = Completer();

    DataMessage myMessage = DataMessage.empty();

    List<String> attachmentImages = [];

    for (int i = 0; i < files.length; i++) {
      File file = files[i];

      FileMessage fileMessage = await sendMessageFile(groupChannel, file);

      myMessage = DataMessage.fromBaseMessage(fileMessage);

      attachmentImages.add(fileMessage.url);
    }

    myMessage.attachmentImages = attachmentImages;

    completer.complete(myMessage);

    return completer.future;
  }

  Future<void> markMessageAsRead(GroupChannel groupChannel) async {
    try {
      groupChannel.markAsRead();
      if (kDebugMode) {
        print("Messages marked as read.");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Failed to mark message as read: $e");
      }
    }
  }

  void addChannelEventHandler(
      GroupChannel groupChannel, ChannelEventHandler listener) {
    SendbirdSdk().addChannelEventHandler(groupChannel.channelUrl, listener);
  }

  void removeChannelEventHandler(GroupChannel groupChannel) {
    SendbirdSdk().removeChannelEventHandler(groupChannel.channelUrl);
  }
}
