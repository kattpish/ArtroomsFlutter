import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:sendbird_sdk/core/message/base_message.dart';
import 'package:sendbird_sdk/core/message/file_message.dart';

import '../main.dart';
import '../utils/utils.dart';
import '../utils/utils_notifications.dart';

class DataMessage {
  int index;
  String channelUrl;
  String senderId;
  String senderName;
  String profilePictureUrl = "";
  String content = "";
  int timestamp;
  String attachmentUrl = "";
  String attachmentName = "";
  int attachmentSize = 0;
  List<String> attachmentImages = [];
  List<File?> attachmentImagesThumbs = [];
  bool isMe;
  bool isArtrooms = false;

  bool isImage = false;
  bool isFile = false;
  bool isSelected = false;
  bool isSending = false;
  bool isDownloading = false;
  int? parentMessageId;
  String data = "";
  int timeSelected = 0;

  DataMessage.empty({
    this.index = 0,
    this.channelUrl = "",
    this.senderId = "",
    this.senderName = "",
    this.content = "",
    this.timestamp = 0,
    this.isMe = false,
  });

  DataMessage.fromBaseMessageWithDetails({
    required this.index,
    required this.channelUrl,
    required this.senderId,
    required this.senderName,
    required this.content,
    required this.timestamp,
    required this.isMe,
  });

  DataMessage.fromBaseMessage(BaseMessage baseMessage)
      : index = baseMessage.messageId,
        channelUrl = baseMessage.channelUrl,
        senderId = baseMessage.sender?.userId ?? "",
        senderName = baseMessage.sender?.nickname ?? "",
        timestamp = baseMessage.createdAt,
        isMe = baseMessage.sender?.userId.toString() == dbStore.getEmail(),
        parentMessageId = baseMessage.parentMessageId,
        data = baseMessage.data != null ? baseMessage.data! : "",
        profilePictureUrl = baseMessage.sender?.profileUrl ?? "" {
    if (baseMessage is FileMessage) {
      FileMessage fileMessage = baseMessage;
      attachmentName = fileMessage.name ?? "";
      attachmentSize = fileMessage.size ?? 0;

      if (fileMessage.type.toString().startsWith('image/')) {
        attachmentImages.add(fileMessage.url);
        isImage = true;
      } else {
        attachmentUrl = fileMessage.url;
        isFile = true;
      }
    } else if (baseMessage.message == 'multiple:image') {
      try {
        final data = jsonDecode(baseMessage.data ?? "");
        print('1111 ${baseMessage.toString()}');

        if (data is Map && data.containsKey('data')) {
          final images = data['data'];
          if (images is List<dynamic>) {
            attachmentImages.addAll(images.cast<String>());
          } else {
            final List<dynamic> imageUrls = jsonDecode(images);
            for (dynamic imageUrl in imageUrls) {
              attachmentImages.add(imageUrl.toString());
            }
          }
        }
        isImage = true;
      } catch (e) {
        if (kDebugMode) {
          print('Error parsing image attachments: $e');
        }
      }
    } else {
      content = baseMessage.message.trim();
    }

    if (senderName == "artrooms" || senderName == "artroom") {
      isArtrooms = true;
      if (profilePictureUrl.isEmpty) {
        profilePictureUrl =
            "https://d2ous6lm13gwvv.cloudfront.net/image/2310190543464346_bc8443ee-ac3a-4306-adab-fd925492a358.jpg";
      }
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

  bool hasImagesThumb(int index) {
    return attachmentImagesThumbs.length > index;
  }

  File getImagesThumb(int index) {
    return attachmentImagesThumbs[index] ?? File("/");
  }

  String getAttachmentSize() {
    double size;
    String unit;
    if (attachmentSize <= 0) {
      unit = "Bytes";
      size = 0;
    } else if (attachmentSize < 1024) {
      unit = "Bytes";
      size = attachmentSize / 1;
    } else if (attachmentSize < 1024 * 1024) {
      unit = "KB";
      size = attachmentSize / 1024;
    } else if (attachmentSize < 1024 * 1024 * 1024) {
      unit = "MB";
      size = attachmentSize / (1024 * 1024);
    } else if (attachmentSize < 1024 * 1024 * 1024) {
      unit = "GB";
      size = attachmentSize / (1024 * 1024 * 1024);
    } else {
      unit = "TB";
      size = attachmentSize / (1024 * 1024 * 1024 * 1024);
    }
    String sizeStr = size.toStringAsFixed(2);
    if (sizeStr.endsWith('.00')) {
      sizeStr = sizeStr.substring(0, sizeStr.length - 3);
    }
    return "$sizeStr$unit";
  }

  bool isNew() {
    return (DateTime.now().millisecondsSinceEpoch - timestamp <
        timeSecRefreshChat * 1000);
  }

  bool isSameTime(DataMessage dataMessage) {
    DateTime dateTime1 = DateTime.fromMillisecondsSinceEpoch(timestamp);
    DateTime dateTime2 =
        DateTime.fromMillisecondsSinceEpoch(dataMessage.timestamp);
    return dateTime1.hour == dateTime2.hour &&
        dateTime1.minute == dateTime2.minute;
  }

  bool isSameDate(DataMessage dataMessage) {
    DateTime dateTime1 = DateTime.fromMillisecondsSinceEpoch(timestamp);
    DateTime dateTime2 =
        DateTime.fromMillisecondsSinceEpoch(dataMessage.timestamp);
    return dateTime1.year == dateTime2.year &&
        dateTime1.month == dateTime2.month &&
        dateTime1.day == dateTime2.day;
  }

  bool isSameDateTime(DataMessage dataMessage) {
    return isSameTime(dataMessage) && isSameDate(dataMessage);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is DataMessage &&
            runtimeType == other.runtimeType &&
            index == other.index;
  }

  @override
  int get hashCode {
    return index.hashCode;
  }
}

class ParentMessage {
  int messageId;
  String content;
  String senderId;
  String senderName;
  String data;

  ParentMessage(
      this.messageId, this.content, this.senderId, this.senderName, this.data);

  ParentMessage.fromJson(Map<String, dynamic> json)
      : messageId = json['messageId'],
        content = json['content'],
        senderId = json['senderId'],
        senderName = json['senderName'],
        data = json['data'];

  Map<String, dynamic> toJson() {
    return {
      'messageId': messageId,
      'content': content,
      'senderId': senderId,
      'senderName': senderName,
      'data': data,
    };
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ParentMessage &&
            runtimeType == other.runtimeType &&
            messageId == other.messageId;
  }

  @override
  int get hashCode {
    return messageId.hashCode;
  }
}
