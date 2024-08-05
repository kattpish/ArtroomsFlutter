// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bean_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PushNotification _$PushNotificationFromJson(Map<String, dynamic> json) =>
    PushNotification(
      pushTrackingId: json['push_tracking_id'] as String,
      sqsTs: (json['sqs_ts'] as num).toInt(),
      customType: json['custom_type'] as String,
      channel: Channel.fromJson(json['channel'] as Map<String, dynamic>),
      createdAt: (json['created_at'] as num).toInt(),
      messageId: (json['message_id'] as num).toInt(),
      type: json['type'] as String,
      message: json['message'] as String,
      unreadMessageCount: (json['unread_message_count'] as num).toInt(),
      pushTitle: json['push_title'] as String?,
      sender: Sender.fromJson(json['sender'] as Map<String, dynamic>),
      audienceType: json['audience_type'] as String,
      translations: json['translations'] as Map<String, dynamic>,
      pushSound: json['push_sound'] as String,
      files: json['files'] as List<dynamic>,
      notificationAction: json['notification_action'] as String,
      channelType: json['channel_type'] as String,
      category: json['category'] as String,
      mentionedUsers: json['mentioned_users'] as List<dynamic>,
      appId: json['app_id'] as String,
    );

Map<String, dynamic> _$PushNotificationToJson(PushNotification instance) =>
    <String, dynamic>{
      'push_tracking_id': instance.pushTrackingId,
      'sqs_ts': instance.sqsTs,
      'custom_type': instance.customType,
      'channel': instance.channel.toJson(),
      'created_at': instance.createdAt,
      'message_id': instance.messageId,
      'type': instance.type,
      'message': instance.message,
      'unread_message_count': instance.unreadMessageCount,
      'push_title': instance.pushTitle,
      'sender': instance.sender.toJson(),
      'audience_type': instance.audienceType,
      'translations': instance.translations,
      'push_sound': instance.pushSound,
      'files': instance.files,
      'notification_action': instance.notificationAction,
      'channel_type': instance.channelType,
      'category': instance.category,
      'mentioned_users': instance.mentionedUsers,
      'app_id': instance.appId,
    };

Channel _$ChannelFromJson(Map<String, dynamic> json) => Channel(
      customType: json['custom_type'] as String,
      name: json['name'] as String,
      channelUrl: json['channel_url'] as String,
    );

Map<String, dynamic> _$ChannelToJson(Channel instance) => <String, dynamic>{
      'custom_type': instance.customType,
      'name': instance.name,
      'channel_url': instance.channelUrl,
    };

Sender _$SenderFromJson(Map<String, dynamic> json) => Sender(
      requireAuthForProfileImage:
          json['require_auth_for_profile_image'] as bool,
      profileUrl: json['profile_url'] as String,
      name: json['name'] as String,
      id: json['id'] as String,
    );

Map<String, dynamic> _$SenderToJson(Sender instance) => <String, dynamic>{
      'require_auth_for_profile_image': instance.requireAuthForProfileImage,
      'profile_url': instance.profileUrl,
      'name': instance.name,
      'id': instance.id,
    };
