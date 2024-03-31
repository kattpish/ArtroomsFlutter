
import 'package:artrooms/ui/widgets/widget_chatroom_files_empty.dart';
import 'package:artrooms/utils/utils_screen.dart';
import 'package:flutter/material.dart';

import '../../beans/bean_chat.dart';
import '../../beans/bean_message.dart';
import '../../listeners/scroll_bouncing_physics.dart';
import '../../modules/module_messages.dart';
import '../../utils/utils_media.dart';
import '../theme/theme_colors.dart';
import '../widgets/widget_chatroom_files_card.dart';
import '../widgets/widget_loader.dart';
import '../widgets/widget_ui_notify.dart';


class ScreenChatroomFiles extends StatefulWidget {

  final DataChat dataChat;

  const ScreenChatroomFiles({super.key, required this.dataChat});

  @override
  State<ScreenChatroomFiles> createState() {
    return _ScreenChatroomFilesState();
  }

}

class _ScreenChatroomFilesState extends State<ScreenChatroomFiles> {

  bool _isLoading = true;
  bool _isButtonFileDisabled = true;

  int _crossAxisCount = 2;
  double _screenWidth = 0;
  final double _crossAxisSpacing = 8;
  final double _mainAxisSpacing = 8;
  bool _isLoadingMore = false;
  bool _isLoadingFinished = false;
  ScrollController _scrollController = ScrollController();

  late final ModuleMessages _moduleMessages;
  List<DataMessage> _attachmentsMedia = [];

  @override
  void initState() {
    super.initState();
    _moduleMessages = ModuleMessages(widget.dataChat.id);
    _doLoadAttachmentsFiles();
    _scrollController.addListener(_doLoadAttachmentsFilesMore);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_doLoadAttachmentsFilesMore);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    _crossAxisCount = isTablet(context) ? 4 : 2;
    _screenWidth = MediaQuery.of(context).size.width;

    return MaterialApp(
      title: 'Chatroom Files',
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            '파일',
            style: TextStyle(
              color: colorMainGrey900,
              fontSize: 19,
              fontFamily: 'SUIT',
              fontWeight: FontWeight.w700,
              height: 0,
              letterSpacing: -0.38,
            ),
          ),
          toolbarHeight: 60,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: colorMainGrey250),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          leadingWidth: 32,
          elevation: 0.2,
        ),
        backgroundColor: colorMainScreen,
        body: WidgetUiNotify(
          child: SafeArea(
            child: _isLoading
                ? const WidgetLoader()
                : _attachmentsMedia.isEmpty
                ? widgetChatroomFilesEmpty(context)
                : GridView.builder(
              controller: _scrollController,
              physics: const ScrollPhysicsBouncing(),
              padding: const EdgeInsets.only(left: 16, top: 12, right: 16, bottom: 32),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _crossAxisCount,
                crossAxisSpacing: _crossAxisSpacing,
                mainAxisSpacing: _mainAxisSpacing,
                childAspectRatio: (_screenWidth / _crossAxisCount - _crossAxisSpacing) / (200),
              ),
              itemCount: _attachmentsMedia.length + (_isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {

                if (index == _attachmentsMedia.length) {
                  return const Center(
                    child: SizedBox(
                        width: 36,
                        height: 36,
                        child: CircularProgressIndicator(
                          color: Color(0xFF6A79FF),
                          strokeWidth: 4,
                        )
                    ),
                  );
                }

                DataMessage attachmentFile = _attachmentsMedia[index];
                return widgetChatroomFilesCard(context, attachmentFile,
                    onSelect: () {
                      setState(() {
                        if(!attachmentFile.isDownloading) {
                          attachmentFile.isSelected = !attachmentFile.isSelected;
                          _checkEnableButton();
                        }
                      });
                    }
                );
              },
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            height: 44,
            margin: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16, bottom: 16),
            decoration: BoxDecoration(color: _isButtonFileDisabled ? colorPrimaryBlue400.withAlpha(100) : colorPrimaryBlue,
              borderRadius: BorderRadius.circular(30),
            ),
            child: TextButton(
              onPressed: () {
                _doSelectFiles();
              },
              child:const Text(
                  '저장',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'SUIT',
                    fontWeight: FontWeight.w700,
                    height: 0,
                    letterSpacing: -0.32,
                  )
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _doLoadAttachmentsFiles() async {

    setState(() {
      _isLoading = true;
    });

    List<DataMessage> attachmentsFiles = await _moduleMessages.fetchAttachmentsFiles();
    setState(() {
      _attachmentsMedia = attachmentsFiles;
    });

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _doLoadAttachmentsFilesMore() async {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !_isLoadingMore && !_isLoadingFinished) {

      setState(() {
        _isLoadingMore = true;
      });

      List<DataMessage> attachmentsImages = await _moduleMessages.fetchAttachmentsFiles();

      setState(() {
        _attachmentsMedia.addAll(attachmentsImages);
        _isLoadingMore = false;
        _isLoadingFinished = attachmentsImages.isEmpty;
      });

    }
  }

  void _checkEnableButton() {

    int n = 0;
    for(DataMessage attachmentFile in _attachmentsMedia) {
      if(attachmentFile.isSelected) {
        n++;
      }
    }

    if (n > 0) {
      setState(() => _isButtonFileDisabled = false);
    } else {
      setState(() => _isButtonFileDisabled = true);
    }
  }

  void _doDeselectAllFiles() {
    for(DataMessage attachmentImage in _attachmentsMedia) {
      setState(() {
        attachmentImage.isSelected = false;
      });
    }

    _checkEnableButton();
  }

  void _doSelectFiles() {
    if(!_isButtonFileDisabled) {

      for(DataMessage attachmentMedia in _attachmentsMedia) {
        if(attachmentMedia.isSelected) {
          downloadAttachment(context, attachmentMedia);
        }
      }

      _doDeselectAllFiles();
    }
  }

  Future<void> downloadAttachment(BuildContext context, DataMessage attachmentMedia) async {
    setState(() {
      attachmentMedia.isDownloading = true;
    });

    await downloadFile(context, attachmentMedia.attachmentUrl, attachmentMedia.attachmentName, showNotification: true);

    setState(() {
      attachmentMedia.isDownloading = false;
    });
  }

}
