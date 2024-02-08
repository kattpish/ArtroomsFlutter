
class MyMessage {

  int senderId;
  String senderName;
  String profilePictureUrl = "";
  String content;
  String timestamp;
  String attachment = "";
  List<String> imageAttachments = [];
  bool isMe;

  MyMessage({
    required this.senderId,
    required this.senderName,
    required this.content,
    required this.timestamp,
    this.attachment = "",
    this.imageAttachments = const [],
    required this.isMe,
  });

}
