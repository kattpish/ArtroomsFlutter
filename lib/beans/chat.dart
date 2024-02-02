class Chat {
  final String id;
  final String name;
  final String lastMessage;
  final int unreadMessages;
  final String profilePictureUrl;
  final String date;

  Chat({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.unreadMessages,
    required this.profilePictureUrl,
    required this.date,
  });
}
