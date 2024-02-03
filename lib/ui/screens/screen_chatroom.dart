import 'package:artrooms/ui/widgets/widget_loader.dart';
import 'package:flutter/material.dart';
import '../../beans/bean_chat.dart';
import '../../beans/bean_message.dart';
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
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _messageController = TextEditingController();
  List<MyMessage> messages = [];

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  void _loadMessages() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {

        setState(() {
          messages = List.generate(12, (index) => MyMessage(
            senderId: index.isEven ? 'my_id' : 'other_id',
            senderName: 'User ${index + 1}',
            content: 'This is message ${index + 1}',
            timestamp: '12:00 PM',
          ));
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

    final message = MyMessage(
      senderId: 'my_id',
      senderName: 'Me',
      content: _messageController.text,
      timestamp: 'Now',
    );

    setState(() {
      messages.add(message);
      _messageController.clear();
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollToBottom();
    });

  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent + 100,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
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
          style: const TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        elevation: 1,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.archive_outlined, color: Colors.grey),
            onPressed: () {

            },
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
                  return message.senderId == 'my_id'
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
      child: Row(
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
    );
  }

  Widget _buildOtherMessageBubble(MyMessage message) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey[300],
            child: Text(message.senderName[0]),
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

}
