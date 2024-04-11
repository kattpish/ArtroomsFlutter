
import 'dart:math' as math;

import 'package:artrooms/beans/bean_file.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import '../../listeners/scroll_bouncing_physics.dart';
import '../../utils/utils.dart';
import '../../utils/utils_media.dart';
import '../theme/theme_colors.dart';
import '../widgets/widget_ui_notify.dart';


class ScreenPhotoView extends StatefulWidget {

  final List<FileItem> images;
  final int initialIndex;
  final bool isSelectMode;
  final Null Function(bool isSelected, dynamic index, FileItem fileItem)? onSelect;

  const ScreenPhotoView({
    Key? key,
    required this.images,
    this.initialIndex = 0,
    this.isSelectMode = false,
    this.onSelect,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ScreenPhotoView();
  }

}

class _ScreenPhotoView extends State<ScreenPhotoView> {

  bool isDownloading = false;
  late int currentIndex;
  late PageController _pageController;
  double rotationAngleDegrees = 0;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black.withOpacity(0.5),
        body: WidgetUiNotify(
          child: Builder(
            builder: (_) {
              return SafeArea(
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Stack(
                    children: [
                      Center(
                        child: Stack(
                          children: [
                            ScrollConfiguration(
                              behavior: scrollBehavior,
                              child: PageView.builder(
                                controller: _pageController,
                                itemCount: widget.images.length,
                                // // physics: const ScrollPhysicsBouncingNormal(),
                                onPageChanged: (int index) {
                                  setState(() {
                                    currentIndex = index;
                                  });
                                },
                                itemBuilder: (context, index) {
                                  FileItem fileItem = widget.images[index];
                                  return Transform.rotate(
                                      angle: rotationAngleDegrees * math.pi / 180,
                                      alignment: FractionalOffset.center,
                                      child: photoView(context, fileItem)
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 18,
                        right: 18,
                        child: IconButton(
                          icon: const Icon(Icons.flip_camera_android, color: colorMainGrey250),
                          onPressed: () {
                            rotateImage();
                          },
                        ),
                      ),
                      Positioned(
                        top: 18,
                        left: 18,
                        child: Visibility(
                          visible: widget.isSelectMode,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                if(!widget.images[currentIndex].isSelected) {
                                  widget.images[currentIndex].isSelected = true;
                                  widget.images[currentIndex].timeSelected = DateTime.now().millisecondsSinceEpoch;
                                  widget.onSelect!(true, currentIndex, widget.images[currentIndex]);
                                }else {
                                  widget.images[currentIndex].isSelected = false;
                                  widget.images[currentIndex].timeSelected = 0;
                                  widget.onSelect!(false, currentIndex, widget.images[currentIndex]);
                                }
                              });
                            },
                            child: Container(
                              width: 26,
                              height: 26,
                              decoration: BoxDecoration(
                                color: widget.images[currentIndex].isSelected ? colorPrimaryBlue : colorMainGrey200.withAlpha(150),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: widget.images[currentIndex].isSelected ? colorPrimaryBlue : const Color(0xFFE3E3E3),
                                  width: 1,
                                ),
                              ),
                              child: widget.images[currentIndex].isSelected
                                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                                  : Container(),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                          top: 18,
                          right: 18,
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: const BoxDecoration(
                              color: colorMainGrey250,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.close,
                                size: 22,
                                color: Colors.black,
                              ),
                              padding: const EdgeInsets.all(4),
                              constraints: const BoxConstraints(),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          )
                      ),
                      Positioned(
                          bottom: 18,
                          left: 18,
                          child: Visibility(
                            visible: widget.images[currentIndex].url.isNotEmpty,
                            child: SizedBox(
                              width: 40,
                              height: 40,
                              child: IconButton(
                                icon: isDownloading
                                    ? const SizedBox(width: 40, height: 40,
                                  child: CircularProgressIndicator(
                                    color: Color(0xFF6A79FF),
                                    strokeWidth: 3,
                                  ),
                                )
                                    : const Icon(
                                  Icons.file_download_outlined,
                                  size: 32,
                                  color: colorMainGrey300,
                                ),
                                padding: const EdgeInsets.all(4),
                                constraints: const BoxConstraints(),
                                onPressed: () async {

                                  if(!isDownloading) {

                                    setState(() {
                                      isDownloading = true;
                                    });

                                    await downloadFile(context, widget.images[currentIndex].url, widget.images[currentIndex].name);

                                    setState(() {
                                      isDownloading = false;
                                    });

                                    showSnackBar(context, "이미지가 다운로드됨");
                                  }

                                },
                              ),
                            ),
                          )
                      ),
                    ],
                  ),
                ),
              );
            }
          ),
        ),
      ),
    );
  }

  Widget photoView(BuildContext context, FileItem fileItem) {

    late ImageProvider imageProvider;
    if (fileItem.url.isEmpty) {
      imageProvider = FileImage(fileItem.file);
    } else {
      imageProvider = NetworkImage(fileItem.url);
    }

    return PhotoView(
      imageProvider: imageProvider,
      backgroundDecoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
      ),
      loadingBuilder: (context, event) {
        return Center(
          child: CircularProgressIndicator(
            value: event == null ? 0 : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(
          'assets/images/chats/placeholder_photo.png',
          width: 0,
          fit: BoxFit.cover,
        );
      },
    );
  }

  void rotateImage() {
    setState(() {
      rotationAngleDegrees += 90; // Rotate 90 degrees
      // Normalize angle to be within 0-360 degrees
      rotationAngleDegrees %= 360;
    });
  }

}