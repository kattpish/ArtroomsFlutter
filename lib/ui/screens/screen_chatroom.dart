import 'package:artrooms/ui/screens/screen_chatroom_drawer.dart';
import 'package:artrooms/ui/widgets/widget_loader.dart';
import 'package:flutter/material.dart';
import '../../beans/bean_chat.dart';
import '../../beans/bean_message.dart';
import '../../modules/module_messages.dart';
import '../theme/theme_colors.dart';


class MyScreenChatroom extends StatefulWidget {

  final MyChat chat;

  const MyScreenChatroom({super.key, required this.chat});

  @override
  State<StatefulWidget> createState() {
    return _MyScreenChatroomState();
  }

}

class _MyScreenChatroomState extends State<MyScreenChatroom> {

  bool _isLoading = true;
  final List<MyMessage> messages = [];
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.grey),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.chat.name,
          style: const TextStyle(
              color: colorMainGrey900,
              fontWeight: FontWeight.w600
          ),
        ),
        centerTitle: true,
        elevation: 1,
        backgroundColor: Colors.white,
        actions: [
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
                shape: BoxShape.circle,
            ),
            child: InkWell(
              child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset('assets/images/icons/icon_archive.png', width: 24, height: 24)
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const MyScreenChatroomDrawer();
                }));
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const MyLoader()
                : Container(
              child: messages.isNotEmpty ? ListView.builder(
                controller: _scrollController,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  return message.isMe
                      ? _buildMyMessageBubble(message)
                      : _buildOtherMessageBubble(message);
                },
              )
                  : buildNoChats(context),
            ),
          ),
          _buildMessageInput(),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Colors.transparent,
            child: Icon(Icons.add, color: colorMainGrey250),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: '',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: const Color(0xFFF3F3F3),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _sendMessage,
            child: const CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Icon(Icons.send, color: colorMainGrey250),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMyMessageBubble(MyMessage message) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                message.timestamp,
                style: const TextStyle(
                  fontSize: 12,
                  color: colorMainGrey300,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                decoration: const BoxDecoration(
                  color: colorPrimaryPurple,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(0),
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24)
                  ),
                ),
                child: Text(
                  message.content,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          _buildAttachment(message.attachment),
          _buildImageAttachments(message.imageAttachments),
        ],
      ),
    );
  }

  Widget _buildOtherMessageBubble(MyMessage message) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {

                },
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey[300],
                  child: FadeInImage.assetNetwork(
                    placeholder: 'assets/images/profile/profile_${(message.senderId % 2) + 1}.png',
                    image: message.profilePictureUrl,
                    fit: BoxFit.cover,
                    fadeInDuration: const Duration(milliseconds: 200),
                    fadeOutDuration: const Duration(milliseconds: 200),
                    imageErrorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/images/profile/profile_${(message.senderId.hashCode % 2) + 1}.png',
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message.senderName,
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(0),
                                topRight: Radius.circular(24),
                                bottomLeft: Radius.circular(24),
                                bottomRight: Radius.circular(24)
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(message.content),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    message.timestamp,
                    style: const TextStyle(
                      fontSize: 12,
                      color: colorMainGrey300,
                    ),
                  ),
                ],
              ),
            ],
          ),
          _buildAttachment(message.attachment),
          _buildImageAttachments(message.imageAttachments),
        ],
      ),
    );
  }

  Widget buildNoChats(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/icons/chat_gray.png',
            width: 80.0,
            height: 80.0,
          ),
          const SizedBox(height: 10),
          const Text(
            '대화내용이 없어요',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.0,
              color: colorMainGrey700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachment(String attachment) {
    if (false && attachment.isNotEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 22),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFFE3E3E3), width: 1.0,),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'artrooms_img_file_33.psd',
              style: TextStyle(
                  fontSize: 18,
                  color: colorMainGrey700,
                  fontWeight: FontWeight.w500
              ),
            ),
            SizedBox(height: 20),
            Text(
              '70.20MB / 2022.08.16 만료',
              style: TextStyle(
                  fontSize: 16,
                  color: colorMainGrey400,
                  fontWeight: FontWeight.w400
              ),
            ),
            SizedBox(height: 20),
            Text(
              '저장',
              style: TextStyle(
                  fontSize: 16,
                  color: colorMainGrey500,
                  fontWeight: FontWeight.w400
              ),
            ),
          ],
        ),
      );
    }else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildImageAttachments(List<String> imageAttachments) {
    if (false && imageAttachments.isNotEmpty) {
      return Container(
        height: 100,
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: imageAttachments.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(right: 4.0),
              child: FadeInImage.assetNetwork(
                placeholder: 'assets/images/chats/placeholder_photo.png',
                image: imageAttachments[index],
                fit: BoxFit.cover,
                fadeInDuration: const Duration(milliseconds: 200),
                fadeOutDuration: const Duration(milliseconds: 200),
                imageErrorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/images/chats/placeholder_photo.png',
                    fit: BoxFit.cover,
                  );
                },
              ),
            );
          },
        ),
      );
    }else {
      return const SizedBox.shrink();
    }
  }


  void _loadMessages() {

    messages.clear();

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {

        setState(() {
          messages.addAll(loadMessages());
          _isLoading = false;
        });

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
          }
        });

      }
    });
  }

  void _sendMessage() {

    if(_messageController.text.isNotEmpty) {

      final message = MyMessage(
        senderId: 1,
        senderName: 'Me',
        content: _messageController.text,
        timestamp: 'Now',
        isMe: true,
      );

      setState(() {
        messages.add(message);
        _messageController.clear();
      });

      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollToBottom();
      });
    }

  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent + 100,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

}
