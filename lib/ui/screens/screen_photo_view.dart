
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import '../../utils/utils.dart';
import '../../utils/utils_media.dart';
import '../theme/theme_colors.dart';
import '../widgets/widget_ui_notify.dart';


class ScreenPhotoView extends StatefulWidget {

  final File? fileImage;
  final String imageUrl;
  final String fileName;

  const ScreenPhotoView({
    super.key,
    this.fileImage,
    this.imageUrl = "",
    this.fileName = "",
  });

  @override
  State<StatefulWidget> createState() {
    return _ScreenPhotoView();
  }

}

class _ScreenPhotoView extends State<ScreenPhotoView> {

  bool isDownloading = false;
  late ImageProvider imageProvider;
  double rotationAngleDegrees = 0;

  @override
  void initState() {
    super.initState();

    final File? fileImage = widget.fileImage;

    if (fileImage != null) {
      imageProvider = FileImage(fileImage);
    } else {
      imageProvider = NetworkImage(widget.imageUrl);
    }

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
                      Transform.rotate(
                        angle: rotationAngleDegrees * math.pi / 180,
                        alignment: FractionalOffset.center,
                        child: Center(
                          child: Stack(
                            children: [
                              PhotoView(
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
                              ),
                            ],
                          ),
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
                      Visibility(
                        visible: widget.imageUrl.isNotEmpty,
                        child: Positioned(
                            bottom: 19,
                            left: 19,
                            child: SizedBox(
                              width: 40,
                              height: 40,
                              child: IconButton(
                                icon: isDownloading
                                    ? const SizedBox(
                                  width: 40,
                                  height: 40,
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

                                    await downloadFile(context, widget.imageUrl, widget.fileName);

                                    setState(() {
                                      isDownloading = false;
                                    });

                                    showSnackBar(context, "이미지가 다운로드됨");
                                  }

                                },
                              ),
                            )
                        ),
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

  void rotateImage() {
    setState(() {
      rotationAngleDegrees += 90; // Rotate 90 degrees
      // Normalize angle to be within 0-360 degrees
      rotationAngleDegrees %= 360;
    });
  }

}