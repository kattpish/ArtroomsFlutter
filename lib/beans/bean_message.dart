
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:sendbird_sdk/core/message/base_message.dart';
import 'package:sendbird_sdk/core/message/file_message.dart';

import '../main.dart';
import '../utils/utils.dart';


class MyMessage {
  int index;
  String senderId;
  String senderName;
  String profilePictureUrl = "";
  String content = "";
  int timestamp;
  String attachmentUrl = "";
  String attachmentName = "";
  int attachmentSize = 0;
  List<String> attachmentImages = [];
  bool isMe;

  bool isImage = false;
  bool isFile = false;
  bool isSelected = false;
  bool isSending = false;

  MyMessage.empty({
    this.index = 0,
    this.senderId = "",
    this.senderName = "",
    this.content = "",
    this.timestamp = 0,
    this.isMe = false,
  });

  MyMessage.fromBaseMessageWithDetails({
    required this.index,
    required this.senderId,
    required this.senderName,
    required this.content,
    required this.timestamp,
    required this.isMe,
  });

  MyMessage.fromBaseMessage(BaseMessage baseMessage)
      : index = baseMessage.messageId,
        senderId = baseMessage.sender?.userId ?? "",
        senderName = baseMessage.sender?.nickname ?? "",
        timestamp = baseMessage.createdAt,
        isMe = baseMessage.sender?.userId.toString() == dbStore.getUid(),
        profilePictureUrl = baseMessage.sender?.profileUrl ?? ""
  {

    if (baseMessage is FileMessage) {

      FileMessage fileMessage = baseMessage;
      attachmentName = fileMessage.name ?? "";
      attachmentSize = fileMessage.size ?? 0;

      if (fileMessage.type.toString().startsWith('image/')) {
        attachmentImages.add(fileMessage.url);
        isImage = true;
      }else {
        attachmentUrl = fileMessage.url;
        isFile = true;
      }

    } else if (baseMessage.message == 'multiple:image') {
      try {
        try {
          final data = jsonDecode(baseMessage.data ?? "");
          if (data is Map && data.containsKey('data')) {
            final images = data['data'];
            if (images is List) {
              attachmentImages.addAll(images.cast<String>());
            }
          }
          isImage = true;
        }catch(e) {
          if (kDebugMode) {
            print("Error fromBaseMessage: $e");
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error parsing image attachments: $e');
        }
      }

    }else {
      content = baseMessage.message.trim();
    }

  }

  String getName() {
    return senderName.isNotEmpty ? senderName : senderId;
  }

  String getTime() {
    return formatTime(timestamp);
  }

  String getDate() {
    return formatDate(timestamp);
  }

  String getDateTime() {
    return "${getDate()} ${getTime()}";
  }

  String getImageUrl() {
    return attachmentImages.isNotEmpty ? attachmentImages[0] : attachmentUrl;
  }

  String getSummary() {
    return isImage ? "첨부 파일" : (isFile ? "첨부 이미지" : content);
  }

  String getAttachmentSize() {
    double size;
    String unit;
    if(attachmentSize <= 0) {
      unit = "Bytes";
      size = 0;
    }else if(attachmentSize < 1024) {
      unit = "Bytes";
      size = attachmentSize / 1;
    }else if(attachmentSize < 1024*1024) {
      unit = "KB";
      size = attachmentSize/1024;
    }else if(attachmentSize < 1024*1024*1024) {
      unit = "MB";
      size = attachmentSize/(1024*1024);
    }else if(attachmentSize < 1024*1024*1024) {
      unit = "GB";
      size = attachmentSize/(1024*1024*1024);
    }else {
      unit = "TB";
      size = attachmentSize/(1024*1024*1024*1024);
    }
    String sizeStr = size.toStringAsFixed(2);
    if (sizeStr.endsWith('.00')) {
      sizeStr = sizeStr.substring(0, sizeStr.length - 3);
    }
    return "$sizeStr$unit";
  }

}
