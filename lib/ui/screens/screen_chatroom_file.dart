
import 'package:artrooms/utils/utils_screen.dart';
import 'package:flutter/material.dart';

import '../../beans/bean_chat.dart';
import '../../beans/bean_message.dart';
import '../../modules/module_messages.dart';
import '../../utils/utils_media.dart';
import '../theme/theme_colors.dart';
import '../widgets/widget_loader.dart';


class MyScreenChatroomFile extends StatefulWidget {

  final DataChat myChat;

  const MyScreenChatroomFile({super.key, required this.myChat});

  @override
  State<MyScreenChatroomFile> createState() {
    return _MyScreenChatroomFileState();
  }

}

class _MyScreenChatroomFileState extends State<MyScreenChatroomFile> {

  bool _isLoading = true;
  bool _isButtonFileDisabled = true;

  int crossAxisCount = 2;
  double crossAxisSpacing = 8;
  double mainAxisSpacing = 8;
  double screenWidth = 0;

  late final ModuleMessages moduleMessages;

  List<MyMessage> _attachmentsMedia = [];

  @override
  void initState() {
    super.initState();
    moduleMessages = ModuleMessages(widget.myChat.id);
    _loadAttachmentsFiles();
  }

  @override
  Widget build(BuildContext context) {

    crossAxisCount = isTablet(context) ? 4 : 2;
    screenWidth = MediaQuery.of(context).size.width;

    return MaterialApp(
      title: 'File Manager',
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
          elevation: 0.5,
        ),
        backgroundColor: colorMainScreen,
        body: SafeArea(
          child: _isLoading
              ? const MyLoader()
              : GridView.builder(
            padding: const EdgeInsets.only(left: 16, top: 12, right: 16, bottom: 32),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: crossAxisSpacing,
              mainAxisSpacing: mainAxisSpacing,
              childAspectRatio: (screenWidth / crossAxisCount - crossAxisSpacing) / (200),
            ),
            itemCount: _attachmentsMedia.length,
            itemBuilder: (context, index) {
              var attachmentFile = _attachmentsMedia[index];
              return Card(
                elevation: 0,
                color: Colors.white,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      attachmentFile.isSelected = !attachmentFile.isSelected;
                      _checkIfFileButtonShouldBeEnabled();
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: attachmentFile.isSelected ? colorPrimaryPurple : colorMainGrey200, width: 1.0,),
                    ),
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 24),
                            Image.asset(
                              attachmentFile.isSelected ? 'assets/images/icons/icon_file_selected.png' : 'assets/images/icons/icon_file.png',
                              width: 30,
                              height: 30,
                            ),
                            const SizedBox(height: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  attachmentFile.attachmentName,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: colorMainGrey700,
                                    fontFamily: 'SUIT',
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: -0.32,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  attachmentFile.getDate(),
                                  style: const TextStyle(
                                    color: Color(0xFF8F8F8F),
                                    fontSize: 12,
                                    fontFamily: 'SUIT',
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                    letterSpacing: -0.24,
                                  ),
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ],
                        ),
                        Positioned(
                          top: 3,
                          right: 2,
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: attachmentFile.isSelected ? colorPrimaryBlue : Colors.transparent,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: attachmentFile.isSelected ? colorPrimaryBlue : const Color(0xFFE3E3E3),
                                width: 1,
                              ),
                            ),
                            child: attachmentFile.isSelected
                                ? const Icon(Icons.check, size: 16, color: Colors.white)
                                : Container(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        bottomNavigationBar: Container(
          height: 44,
          margin: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16, bottom: 40),
          decoration: BoxDecoration(color: _isButtonFileDisabled ? colorPrimaryBlue400.withAlpha(100) : colorPrimaryBlue,
            borderRadius: BorderRadius.circular(30),
          ),
          child: TextButton(
            onPressed: () {
              selectFiles();
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
    );
  }

  void _loadAttachmentsFiles() async {

    setState(() {
      _isLoading = true;
    });

    List<MyMessage> attachmentsFiles = await moduleMessages.fetchAttachmentsFiles();
    setState(() {
      _attachmentsMedia = attachmentsFiles;
    });

    setState(() {
      _isLoading = false;
    });

  }

  void _checkIfFileButtonShouldBeEnabled() {

    int n = 0;
    for(MyMessage attachmentFile in _attachmentsMedia) {
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

  void _deselectAllFiles() {

    for(MyMessage attachmentImage in _attachmentsMedia) {
      setState(() {
        attachmentImage.isSelected = false;
      });
    }

  }

  void selectFiles() {

    if(!_isButtonFileDisabled) {

      for(MyMessage attachmentMedia in _attachmentsMedia) {
        if(attachmentMedia.isSelected) {
          downloadFile(context, attachmentMedia.attachmentUrl, attachmentMedia.attachmentName, showNotification: true);
        }
      }

      _deselectAllFiles();
    }

  }

}
