
import 'package:artrooms/ui/widgets/widget_chatroom_photos_empty.dart';
import 'package:flutter/material.dart';

import '../../beans/bean_chat.dart';
import '../../beans/bean_file.dart';
import '../../beans/bean_message.dart';
import '../../listeners/scroll_bouncing_physics.dart';
import '../../modules/module_messages.dart';
import '../../utils/utils_media.dart';
import '../../utils/utils_screen.dart';
import '../theme/theme_colors.dart';
import '../widgets/widget_chatroom_photos_card.dart';
import '../widgets/widget_loader.dart';
import '../widgets/widget_media.dart';
import '../widgets/widget_ui_notify.dart';


class ScreenChatroomPhotos extends StatefulWidget {

  final DataChat dataChat;

  const ScreenChatroomPhotos({super.key, required this.dataChat});

  @override
  State<ScreenChatroomPhotos> createState() {
    return _ScreenChatroomPhotosState();
  }

}

class _ScreenChatroomPhotosState extends State<ScreenChatroomPhotos> {

  bool _isLoading = true;
  int _selected = 0;
  bool _selectMode = false;
  bool _isViewing = false;
  bool _isButtonDisabled = true;
  bool _isLoadingMore = false;
  bool _isLoadingFinished = false;
  final ScrollController _scrollController = ScrollController();

  late final ModuleMessages _moduleMessages;
  List<DataMessage> _attachmentsImages = [];

  @override
  void initState() {
    super.initState();
    _moduleMessages = ModuleMessages(widget.dataChat.id);
    _doLoadAttachmentsImages();
    _scrollController.addListener(_doLoadAttachmentsImagesMore);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_doLoadAttachmentsImagesMore);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if(_selectMode) {
          _doDeselectAllPhotos(true);
          return false;
        }else if(_isViewing) {
          return false;
        }
        return true;
      },
      child: MaterialApp(
        title: 'Photos',
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
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                Visibility(
                  visible: _selectMode,
                  child: Container(
                    height: double.infinity,
                    margin: const EdgeInsets.only(left: 8.0),
                    child: Center(
                      child: InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          _doDeselectAllPhotos(true);
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
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        _doDeselectAllPhotos(false);
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
                            ),
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
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
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
          body: WidgetUiNotify(
            child: SafeArea(
              child: _isLoading
                  ? const WidgetLoader()
                  : _attachmentsImages.isEmpty
                  ? widgetChatroomPhotosEmpty(context)
                  : StretchingOverscrollIndicator(
                axisDirection: AxisDirection.down,
                    child: ScrollConfiguration(
                behavior: scrollBehavior,
                      child: GridView.builder(
                controller: _scrollController,
                // physics: const ScrollPhysicsBouncing(),
                padding: const EdgeInsets.only(bottom: 32),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isTablet(context) ? 6 : 3,
                      crossAxisSpacing: 1,
                      mainAxisSpacing: 1,
                      childAspectRatio: 1,
                ),
                itemCount: _attachmentsImages.length + (_isLoadingMore ? 1 : 0),
                itemBuilder: (context, index) {

                      if (index == _attachmentsImages.length) {
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

                      DataMessage attachmentImage = _attachmentsImages[index];
                      return widgetChatroomPhotosCard(context, attachmentImage, _selectMode,
                          onView: ()  async {
                            setState(() {
                              _isViewing = true;
                            });
                            List<FileItem> listImages = toFileItems(_attachmentsImages);
                            await doOpenPhotoView(context, listImages, initialIndex: index);
                            setState(() {
                              _isViewing = false;
                            });
                          },
                          onSelect: () {
                            setState(() {
                              if(!attachmentImage.isDownloading) {
                                if(!attachmentImage.isSelected) {
                                  attachmentImage.isSelected = true;
                                  attachmentImage.timeSelected = DateTime.now().millisecondsSinceEpoch;
                                }else {
                                  attachmentImage.isSelected = false;
                                  attachmentImage.timeSelected = 0;
                                }
                                _checkEnableButton();
                              }
                            });
                          }
                      );
                },
              ),
                    ),
                  ),
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
                  _doSelectPhotos();
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
      ),
    );
  }

  void _doLoadAttachmentsImages() async {

    setState(() {
      _isLoading = true;
    });

    List<DataMessage> attachmentsImages = await _moduleMessages.fetchAttachmentsImages();

    setState(() {
      _attachmentsImages = attachmentsImages;
      _isLoading = false;
    });

  }

  Future<void> _doLoadAttachmentsImagesMore() async {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !_isLoadingMore && !_isLoadingFinished) {

      setState(() {
        _isLoadingMore = true;
      });

      List<DataMessage> attachmentsImages = await _moduleMessages.fetchAttachmentsImages();

      setState(() {
        _attachmentsImages.addAll(attachmentsImages);
        _isLoadingMore = false;
        _isLoadingFinished = attachmentsImages.isEmpty;
      });

    }
  }

  void _checkEnableButton() {

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

  void _doDeselectAllPhotos(isClose) {

    setState(() {
      _selected = 0;
    });

    for(DataMessage attachmentImage in _attachmentsImages) {
      setState(() {
        attachmentImage.isSelected = false;
        attachmentImage.timestamp = 0;
      });
    }

    if(isClose) {
      setState(() {
        _selectMode = false;
      });

      _checkEnableButton();
    }

  }

  void _doSelectPhotos() {

    if(!_isButtonDisabled) {

      for(DataMessage attachmentImage in _attachmentsImages) {
        if(attachmentImage.isSelected) {
          downloadAttachment(context, attachmentImage);
        }
      }

      _doDeselectAllPhotos(true);
    }

  }

  Future<void> downloadAttachment(BuildContext context, DataMessage attachmentImage) async {
    setState(() {
      attachmentImage.isDownloading = true;
    });

    await downloadFile(context, attachmentImage.attachmentUrl, attachmentImage.attachmentName, showNotification: true);

    setState(() {
      attachmentImage.isDownloading = false;
    });
  }

}
