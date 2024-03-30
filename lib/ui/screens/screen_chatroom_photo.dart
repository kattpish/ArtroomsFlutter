
import 'package:flutter/material.dart';

import '../../beans/bean_chat.dart';
import '../../beans/bean_message.dart';
import '../../modules/module_messages.dart';
import '../../utils/utils_media.dart';
import '../../utils/utils_screen.dart';
import '../theme/theme_colors.dart';
import '../widgets/widget_loader.dart';
import '../widgets/widget_media.dart';


class ScreenChatroomPhoto extends StatefulWidget {

  final DataChat dataChat;

  const ScreenChatroomPhoto({super.key, required this.dataChat});

  @override
  State<ScreenChatroomPhoto> createState() {
    return _ScreenChatroomPhotoState();
  }

}

class _ScreenChatroomPhotoState extends State<ScreenChatroomPhoto> {

  bool _isLoading = true;
  int _selected = 0;
  bool _selectMode = false;
  bool _isButtonDisabled = true;

  late final ModuleMessages _moduleMessages;
  List<DataMessage> _attachmentsImages = [];

  @override
  void initState() {
    super.initState();
    _moduleMessages = ModuleMessages(widget.dataChat.id);
    _loadAttachmentsImages();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photo Manager',
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            !_selectMode ? '이미지' : "$_selected개 선택",
            style: const TextStyle(
                fontSize: 18,
                color: colorMainGrey900,
              fontFamily: 'SUIT',
              fontWeight: FontWeight.w700,
              height: 0,
              letterSpacing: -0.36,
            ),
          ),
          toolbarHeight: 60,
          centerTitle: _selectMode,
          leading: Row(
            children: [
              Visibility(
                visible: !_selectMode,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: colorMainGrey250,
                    size: 20,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              Visibility(
                visible: _selectMode,
                child: Container(
                  height: double.infinity,
                  margin: const EdgeInsets.only(left: 8.0),
                  child: Center(
                    child: InkWell(
                      onTap: () {
                        _deselectAllPhotos(true);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        child: const Text(
                            '취소',
                            style: TextStyle(
                                fontSize: 16,
                                color: colorMainGrey600,
                              fontFamily: 'SUIT',
                              fontWeight: FontWeight.w400,
                              height: 0,
                              letterSpacing: -0.32,
                            )
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            Visibility(
              visible: _selectMode,
              child: Container(
                height: double.infinity,
                margin: const EdgeInsets.only(right: 8.0),
                child: Center(
                  child: InkWell(
                    onTap: () {
                      _deselectAllPhotos(false);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      child: const Text(
                          '선택 해제',
                          style: TextStyle(
                            fontSize: 16,
                            color: colorMainGrey600,
                            fontFamily: 'SUIT',
                            fontWeight: FontWeight.w400,
                            height: 0,
                            letterSpacing: -0.32,
                          )
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: !_selectMode,
              child: Container(
                height: double.infinity,
                margin: const EdgeInsets.only(left: 8.0),
                child: Center(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectMode = true;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      child: const Text(
                          '선택',
                          style: TextStyle(
                            fontSize: 16,
                            color: colorMainGrey600,
                            fontFamily: 'SUIT',
                            fontWeight: FontWeight.w400,
                            height: 0,
                            letterSpacing: -0.32,
                          )
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
          elevation: 0.2,
        ),
        backgroundColor: colorMainScreen,
        body: SafeArea(
          child: _isLoading
              ? const WidgetLoader()
              : GridView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 32),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isTablet(context) ? 6 : 3,
              crossAxisSpacing: 1,
              mainAxisSpacing: 1,
              childAspectRatio: 1,
            ),
            itemCount: _attachmentsImages.length,
            itemBuilder: (context, index) {
              DataMessage attachmentImage = _attachmentsImages[index];
              return Container(
                color: Colors.white,
                child: InkWell(
                  onTap: () {
                    doOpenPhotoView(context, imageUrl:attachmentImage.getImageUrl(), fileName:attachmentImage.attachmentName);
                  },
                  onLongPress: () {
                    setState(() {
                      attachmentImage.isSelected = !attachmentImage.isSelected;
                    });
                    _checkIfPhotoShouldBeEnabled();
                  },
                  child: Stack(
                    children: [
                      FadeInImage.assetNetwork(
                        placeholder: 'assets/images/chats/placeholder_photo.png',
                        image: attachmentImage.getImageUrl(),
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        fadeInDuration: const Duration(milliseconds: 100),
                        fadeOutDuration: const Duration(milliseconds: 100),
                        imageErrorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/images/chats/placeholder_photo.png',
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                      Positioned(
                        top: 3,
                        right: 4,
                        child: Visibility(
                          visible: _selectMode,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                attachmentImage.isSelected = !attachmentImage.isSelected;
                                _checkIfPhotoShouldBeEnabled();
                              });
                            },
                            child: Container(
                              width: 26,
                              height: 26,
                              decoration: BoxDecoration(
                                color: attachmentImage.isSelected ? colorPrimaryBlue : colorMainGrey200.withAlpha(150),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: attachmentImage.isSelected ? colorPrimaryBlue : const Color(0xFFE3E3E3),
                                  width: 1,
                                ),
                              ),
                              child: attachmentImage.isSelected
                                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                                  : Container(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            height: 44,
            margin: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16, bottom: 16),
            decoration: BoxDecoration(color: _isButtonDisabled ? colorPrimaryBlue400.withAlpha(100) : colorPrimaryBlue,
              borderRadius: BorderRadius.circular(30),
            ),
            child: TextButton(
              onPressed: () {
                _selectPhotos();
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

  void _loadAttachmentsImages() async {

    setState(() {
      _isLoading = true;
    });

    List<DataMessage> attachmentsImages = await _moduleMessages.fetchAttachmentsImages();

    setState(() {
      _attachmentsImages = attachmentsImages;
      _isLoading = false;
    });

  }

  void _checkIfPhotoShouldBeEnabled() {

    _selected = 0;
    for(DataMessage attachmentImage in _attachmentsImages) {
      if(attachmentImage.isSelected) {
        setState(() {
          _selected++;
        });
      }
    }

    if (_selected > 0) {
      setState(() {
        _selectMode = true;
        _isButtonDisabled = false;
      });
    } else {
      setState(() {
        _isButtonDisabled = true;
      });
    }

  }

  void _deselectAllPhotos(isClose) {

    setState(() {
      _selected = 0;
    });

    for(DataMessage attachmentImage in _attachmentsImages) {
      setState(() {
        attachmentImage.isSelected = false;
      });
    }

    if(isClose) {
      setState(() {
        _selectMode = false;
      });

      _checkIfPhotoShouldBeEnabled();
    }

  }

  void _selectPhotos() {

    if(!_isButtonDisabled) {

      for(DataMessage attachmentImage in _attachmentsImages) {
        if(attachmentImage.isSelected) {
          downloadFile(context, attachmentImage.attachmentUrl, attachmentImage.attachmentName, showNotification: true);
        }
      }

      _deselectAllPhotos(true);

    }

  }

}
