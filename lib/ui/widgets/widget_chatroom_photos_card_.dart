import 'package:artrooms/beans/bean_message.dart';
import 'package:flutter/material.dart';

import '../theme/theme_colors.dart';

class ChatroomPhotosCard extends StatelessWidget {
  final DataMessage attachmentImage;
  final bool selectMode;
  final Null Function() onSelect;
  final Future<void> Function() onView;
  const ChatroomPhotosCard({super.key, required this.attachmentImage, required this.selectMode, required this.onSelect, required this.onView});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: InkWell(
        onTap: () {
          onView();
        },
        onLongPress: () {
          onSelect();
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
              child: Column(
                children: [
                  Visibility(
                      visible: attachmentImage.isDownloading,
                      child: Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          color: colorPrimaryBlue,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFE3E3E3),
                            width: 1,
                          ),
                        ),
                        child: const Center(
                          child: SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              color: Color(0xFFE3E3E3),
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                      )
                  ),
                  Visibility(
                    visible: !attachmentImage.isDownloading && selectMode,
                    child: InkWell(
                      onTap: () {
                        onSelect();
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
