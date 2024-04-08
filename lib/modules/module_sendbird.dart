
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:artrooms/modules/module_push_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:path/path.dart' as path;

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
import 'package:sendbird_sdk/query/group_channel_list_query.dart';
import 'package:sendbird_sdk/sdk/sendbird_sdk_api.dart';

import '../main.dart';


class ModuleSendBird {

  Future<void> initSendbird() async {
    ModulePushNotifications modulePushNotifications = ModulePushNotifications();
    try {

      final String email = dbStore.getEmail();

      SendbirdSdk(
          appId: "01CFFFE8-F1B8-4BB4-A576-952ABDC8D08A",
          apiToken: "39ac9b8e2125ad49035c7bd9c105ccc9d4dc7ba4"
      );

      final user = await SendbirdSdk().connect(email);
      PushTokenRegistrationStatus status = await SendbirdSdk().registerPushToken(
        type: getPushTokenType(),
        token: await getToken(),
        unique: true,
      );
      print(' PushTokenRegistrationStatus -> $status');
      if (kDebugMode) {
        print('Connected as ${user.userId}');
      }

    } catch (e) {
      if (kDebugMode) {
        print('Sendbird connection error: $e');
      }
    }

  }

  Future<void> joinChannel(id) async {

    late BaseChannel channel;

    try {

      try {
        channel = await GroupChannel.getChannel(id);
      }catch(e) {
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
      }catch(e) {
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

  Future<List<BaseMessage>> loadMessages(GroupChannel groupChannel, int? earliestMessageTimestamp) async {
    Completer<List<BaseMessage>> completer = Completer<List<BaseMessage>>();

      try {
        final params = MessageListParams();
        params.previousResultSize = 20;
        params.reverse = true;

        final referenceTime = earliestMessageTimestamp ?? DateTime.now().millisecondsSinceEpoch;
        final messages = await groupChannel.getMessagesByTimestamp(referenceTime, params);

        completer.complete(messages);
      } catch (e) {
        if (kDebugMode) {
          print('Load messages error: $e');
        }
        completer.completeError(e);
      }

    return completer.future;
  }

  Future<List<BaseMessage>> fetchAttachments(GroupChannel groupChannel, int? earliestMessageTimestamp) async {
    try {

      final params = MessageListParams();
      params.previousResultSize = 200;
      params.reverse = true;

      final referenceTime = earliestMessageTimestamp ?? DateTime.now().millisecondsSinceEpoch;
      final messages = await groupChannel.getMessagesByTimestamp(referenceTime, params);

      return messages;
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching attachments: $e");
      }
      return [];
    }
  }

  Future<UserMessage> sendMessage(GroupChannel groupChannel, String text, {String data="",DataMessage? message}) async {
    final params = UserMessageParams(message: text);
     ParentMessage parentMessage = ParentMessage(message?.index ?? 0, message?.content ?? "", message?.senderId ?? "",message?.senderName ?? "");
     params.mentionedUserIds = [];
     params.data =  const JsonEncoder().convert(parentMessage);
    return performSendMessage(groupChannel, text,params);
  }

  Future<UserMessage> performSendMessage(GroupChannel groupChannel, String text,UserMessageParams params) async {
    Completer<UserMessage> completer = Completer();

    groupChannel.sendUserMessage(params, onCompleted: (UserMessage userMessage, error) {
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


  Future<FileMessage> sendMessageFile(GroupChannel groupChannel, File file) async {
    Completer<FileMessage> completer = Completer();

    String fileName = path.basename(Uri.parse(file.path).path);

    final params = FileMessageParams.withFile(file, name: fileName);

    if (kDebugMode) {
      print('Sending message file: ${file.path}');
    }

    groupChannel.sendFileMessage(params, onCompleted: (FileMessage userMessage, error) {
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

  Future<DataMessage> sendMessageFiles(GroupChannel groupChannel, List<File> files) async {
    Completer<DataMessage> completer = Completer();

    DataMessage myMessage = DataMessage.empty();

    List<String> attachmentImages = [];

    for(int i = 0; i < files.length; i++) {

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

  void addChannelEventHandler(GroupChannel groupChannel, ChannelEventHandler listener) {
    SendbirdSdk().addChannelEventHandler(groupChannel.channelUrl, listener);
  }

  void removeChannelEventHandler(GroupChannel groupChannel) {
    SendbirdSdk().removeChannelEventHandler(groupChannel.channelUrl);
  }

  PushTokenType getPushTokenType() {
    PushTokenType pushTokenType;
    if (Platform.isAndroid) {
      pushTokenType = PushTokenType.fcm;
    } else if (Platform.isIOS) {
      pushTokenType = PushTokenType.apns;
    }else {
      pushTokenType = PushTokenType.fcm;
    }
    return pushTokenType;
  }

  Future<String> getToken() async {
    String? token;
    if (Platform.isAndroid) {
      token = await FirebaseMessaging.instance.getToken();
    } else if (Platform.isIOS) {
      token = await FirebaseMessaging.instance.getAPNSToken();
    }
    if (kDebugMode) {
      print('fcm token $token');
    }
    return token ?? "";
  }

}