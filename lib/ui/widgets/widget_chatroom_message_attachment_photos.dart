
import 'package:artrooms/ui/widgets/widget_media.dart';
import 'package:flutter/material.dart';

import '../../beans/bean_message.dart';
import '../theme/theme_colors.dart';


Widget buildImageAttachments(
    BuildContext context,
    DataMessage message,
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
        margin: const EdgeInsets.only(bottom: 2),
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
                  width: (screenWidth * 0.55) /
                      (message.attachmentImages.length > 3
                          ? 3
                          : message.attachmentImages.length),
                  decoration: const BoxDecoration(
                    color: colorMainGrey200,
                  ),
                  child: InkWell(
                    onTap: () {
                      if (!message.isSending) {
                        doOpenPhotoView(context, imageUrl: attachment, fileName: message.attachmentName);
                      }
                    },
                    child: FadeInImage.assetNetwork(
                      placeholder:
                      'assets/images/chats/placeholder_photo.png',
                      image: attachment,
                      fit: BoxFit.cover,
                      fadeInDuration: const Duration(milliseconds: 100),
                      fadeOutDuration: const Duration(milliseconds: 100),
                      imageErrorBuilder: (context, error, stackTrace) {
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
            borderRadius: const BorderRadius.all(Radius.circular(24)),
            child: Container(
              constraints: BoxConstraints(maxWidth: screenWidth * 0.55),
              alignment:
              message.isMe ? Alignment.topRight : Alignment.topLeft,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: Colors.white,
              ),
              child: Stack(
                children: [
                  Column(children: rows),
                  Visibility(
                      visible: message.isSending,
                      child: Container(
                        height: heights,
                        constraints:
                        BoxConstraints(maxWidth: screenWidth * 0.55),
                        child: Center(
                          child: Container(
                            width: 30,
                            height: 30,
                            alignment: Alignment.topRight,
                            child: const CircularProgressIndicator(
                              color: Color(0xFF6A79FF),
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                      ))
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
