
import 'package:artrooms/ui/widgets/widget_media.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../beans/bean_file.dart';
import '../../beans/bean_message.dart';
import '../../utils/utils_media.dart';
import '../theme/theme_colors.dart';


Widget buildImageAttachments(
    BuildContext context,
    DataMessage message,
    List<DataMessage> listMessages,
    double screenWidth
    ) {

  if (message.attachmentImages.isNotEmpty) {

    List<Widget> rows = [];
    int itemsPlaced = 0;
    int rowIndex = 1;
    final int itemCount = message.attachmentImages.length;

    double heights = 0;

    while (itemsPlaced < itemCount) {
      int itemsInRow;

      if (itemCount == 4 && itemsPlaced == 0) {
        itemsInRow = 2;
      } else if (itemCount - itemsPlaced == 7 ||
          itemCount - itemsPlaced == 8) {
        itemsInRow = rowIndex <= 2 ? 3 : 2;
      } else if (itemCount - itemsPlaced <= 3) {
        itemsInRow = itemCount - itemsPlaced;
      } else {
        itemsInRow = rowIndex % 2 == 0 ? 2 : 3;
      }

      double height;
      if (itemCount == 1) {
        height = 200;
      } else if (itemCount == 2) {
        height = 112;
      } else {
        height = 74;
      }

      heights += height;

      rows.add(Container(
        margin: const EdgeInsets.only(top: 1, bottom: 1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(itemsInRow, (index) {
            String attachment = message.attachmentImages[itemsPlaced];
            bool isLast = index == itemsInRow - 1;
            itemsPlaced++;
            return Expanded(
              child: Container(
                height: height,
                margin: EdgeInsets.only(right: isLast ? 0 : 2),
                child: Container(
                  width: (screenWidth * 0.55) / (message.attachmentImages.length > 3 ? 3 : message.attachmentImages.length),
                  decoration: const BoxDecoration(
                    color: colorMainGrey200,
                  ),
                  child: InkWell(
                    onTap: () {
                      if (!message.isSending) {
                        List<FileItem> listImages = toFileItems(listMessages);
                        int initialIndex = 0;
                        for (int i = 0; i < listImages.length; i++) {
                          FileItem fileItem = listImages[i];
                          if(fileItem.url == attachment) {
                            initialIndex = i;
                            break;
                          }
                        }
                        doOpenPhotoView(context, listImages, initialIndex: initialIndex);
                      }
                    },
                    child: message.isSending && message.hasImagesThumb(index)
                        ?
                    Image.file(
                      message.getImagesThumb(index),
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    )
                        : CachedNetworkImage(
                      imageUrl: attachment,
                      cacheManager: customCacheManager,
                      fit: BoxFit.cover,
                      fadeInDuration: const Duration(milliseconds: 100),
                      fadeOutDuration: const Duration(milliseconds: 100),
                      placeholder: (context, url) {
                        return Image.asset(
                          'assets/images/chats/placeholder_photo.png',
                          fit: BoxFit.cover,
                        );
                      },
                      errorWidget: (context, url, error) {
                        return Image.asset(
                          'assets/images/chats/placeholder_photo.png',
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ));
    }

    return Row(
      textDirection: message.isMe ? TextDirection.rtl : TextDirection.ltr,
      mainAxisAlignment:
      message.isMe ? MainAxisAlignment.start : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          margin: EdgeInsets.only(left: message.isMe ? 0 : 40),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            child: Container(
              constraints: BoxConstraints(maxWidth: screenWidth * 0.55),
              alignment:
              message.isMe ? Alignment.topRight : Alignment.topLeft,
              decoration: const ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
              child: Stack(
                children: [
                  Column(children: rows),
                  if(message.isSending)
                    Container(
                      height: heights,
                      constraints: BoxConstraints(maxWidth: screenWidth * 0.55),
                      color: const Color(0xFFFFFFFF).withOpacity(0.8),
                      child: Center(
                        child: Container(
                          width: 24,
                          height: 24,
                          alignment: Alignment.topRight,
                          child: const CircularProgressIndicator(
                            value: 50,
                            color: Color(0xFF6A79FF),
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          message.getTime(),
          style: const TextStyle(
            color: colorMainGrey300,
            fontSize: 10,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w400,
            height: 0.15,
            letterSpacing: -0.20,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  } else {
    return const SizedBox.shrink();
  }
}
