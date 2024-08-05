import 'package:json_annotation/json_annotation.dart';

part 'bean_notification.g.dart';

@JsonSerializable(explicitToJson: true)
class PushNotification {
  @JsonKey(name: 'push_tracking_id')
  final String pushTrackingId;

  @JsonKey(name: 'sqs_ts')
  final int sqsTs;

  @JsonKey(name: 'custom_type')
  final String customType;

  final Channel channel;

  @JsonKey(name: 'created_at')
  final int createdAt;

  @JsonKey(name: 'message_id')
  final int messageId;

  final String type;
  final String message;

  @JsonKey(name: 'unread_message_count')
  final int unreadMessageCount;

  @JsonKey(name: 'push_title')
  final String? pushTitle;

  final Sender sender;

  @JsonKey(name: 'audience_type')
  final String audienceType;

  final Map<String, dynamic> translations;

  @JsonKey(name: 'push_sound')
  final String pushSound;

  final List<dynamic> files;

  @JsonKey(name: 'notification_action')
  final String notificationAction;

  @JsonKey(name: 'channel_type')
  final String channelType;

  final String category;

  @JsonKey(name: 'mentioned_users')
  final List<dynamic> mentionedUsers;

  @JsonKey(name: 'app_id')
  final String appId;

  PushNotification({
    required this.pushTrackingId,
    required this.sqsTs,
    required this.customType,
    required this.channel,
    required this.createdAt,
    required this.messageId,
    required this.type,
    required this.message,
    required this.unreadMessageCount,
    this.pushTitle,
    required this.sender,
    required this.audienceType,
    required this.translations,
    required this.pushSound,
    required this.files,
    required this.notificationAction,
    required this.channelType,
    required this.category,
    required this.mentionedUsers,
    required this.appId,
  });

  factory PushNotification.fromJson(Map<String, dynamic> json) =>
      _$PushNotificationFromJson(json);

  Map<String, dynamic> toJson() => _$PushNotificationToJson(this);
}

@JsonSerializable()
class Channel {
  @JsonKey(name: 'custom_type')
  final String customType;

  final String name;

  @JsonKey(name: 'channel_url')
  final String channelUrl;

  Channel({
    required this.customType,
    required this.name,
    required this.channelUrl,
  });

  factory Channel.fromJson(Map<String, dynamic> json) =>
      _$ChannelFromJson(json);

  Map<String, dynamic> toJson() => _$ChannelToJson(this);
}

@JsonSerializable()
class Sender {
  @JsonKey(name: 'require_auth_for_profile_image')
  final bool requireAuthForProfileImage;

  @JsonKey(name: 'profile_url')
  final String profileUrl;

  final String name;
  final String id;

  Sender({
    required this.requireAuthForProfileImage,
    required this.profileUrl,
    required this.name,
    required this.id,
  });

  factory Sender.fromJson(Map<String, dynamic> json) => _$SenderFromJson(json);

  Map<String, dynamic> toJson() => _$SenderToJson(this);
}
