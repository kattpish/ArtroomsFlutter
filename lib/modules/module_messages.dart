
import 'package:sendbird_sdk/core/channel/group/group_channel.dart';
import 'package:sendbird_sdk/core/message/base_message.dart';
import 'package:sendbird_sdk/core/message/file_message.dart';
import 'package:sendbird_sdk/core/message/user_message.dart';

import '../beans/bean_message.dart';
import '../main.dart';


class ModuleMessages {

  late final String _channelUrl;
  late final GroupChannel _groupChannel;
  bool _isInitialized = false;
  bool _isLoading = false;
  int? _earliestMessageTimestamp;
  int? _earliestMessageTimestamp1;

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

    final List<MyMessage> messages = [];

    if(_isLoading) return messages;

    _isLoading = true;

    if(!_isInitialized) {
      await initChannel();
    }

    await moduleSendBird.loadMessages(_groupChannel, _earliestMessageTimestamp).then((List<BaseMessage> baseMessages) {

      for(BaseMessage baseMessage in baseMessages) {
        final MyMessage myMessage = MyMessage.fromBaseMessage(baseMessage);
        messages.add(myMessage);
      }

      if (messages.isNotEmpty) {
        _earliestMessageTimestamp = baseMessages.last.createdAt;
      }

    });

    _isLoading = false;

    return messages;
  }

  Future<MyMessage> sendMessage(String text) async {

    if(!_isInitialized) {
      await initChannel();
    }

    final UserMessage userMessage = await moduleSendBird.sendMessage(_groupChannel, text.trim());

    final myMessage = MyMessage.fromBaseMessage(userMessage);

    return myMessage;
  }

  bool isLoading() {
    return _isLoading;
  }

  Future<List<MyMessage>> fetchAttachments() async {

    if(!_isInitialized) {
      await initChannel();
    }

    List<MyMessage> attachmentsImages = [];

    List<BaseMessage> attachments = await moduleSendBird.fetchAttachments(_groupChannel, _earliestMessageTimestamp1);

    for (BaseMessage message in attachments) {

      MyMessage myMessage = MyMessage.fromBaseMessage(message);

      if(myMessage.isImage || myMessage.isFile) {
        attachmentsImages.add(myMessage);
      }

    }

    if (attachments.isNotEmpty) {
      _earliestMessageTimestamp1 = attachments.last.createdAt;
    }

    return attachmentsImages;
  }

  Future<List<MyMessage>> fetchAttachmentsImages() async {

    if(!_isInitialized) {
      await initChannel();
    }

    List<MyMessage> attachmentsImages = [];

    List<MyMessage> attachments = await fetchAttachments();

    for (MyMessage myMessage in attachments) {

        if(myMessage.isImage) {

          for(String attachmentUrl in myMessage.attachmentImages) {

            MyMessage myMessage1 = MyMessage.fromBaseMessageWithDetails(
              index: myMessage.index,
              senderId: myMessage.senderId,
              senderName: myMessage.senderName,
              content: myMessage.content,
              timestamp: myMessage.timestamp,
              isMe: myMessage.isMe,
            );

            myMessage1.isImage = true;
            myMessage1.attachmentUrl = attachmentUrl;
            myMessage1.attachmentName = myMessage.attachmentName;
            myMessage1.attachmentSize = myMessage.attachmentSize;

            attachmentsImages.add(myMessage1);
          }

        }

    }

    return attachmentsImages;
  }

  Future<List<MyMessage>> fetchAttachmentsFiles() async {

    if(!_isInitialized) {
      await initChannel();
    }

    List<MyMessage> attachmentsImages = [];

    List<MyMessage> attachments = await fetchAttachments();

    for (MyMessage myMessage in attachments) {

      if(myMessage.isFile) {
        attachmentsImages.add(myMessage);
      }

    }

    return attachmentsImages;
  }

}
