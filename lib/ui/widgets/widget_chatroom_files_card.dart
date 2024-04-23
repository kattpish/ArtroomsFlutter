
import 'package:flutter/material.dart';

import '../../beans/bean_message.dart';
import '../theme/theme_colors.dart';


Widget widgetChatroomFilesCard(BuildContext context, DataMessage attachmentFile, {required Null Function() onSelect}) {
  return Card(
    elevation: 0,
    color: Colors.white,
    child: InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        onSelect();
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
              child: attachmentFile.isDownloading
                  ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  color: Color(0xFF6A79FF),
                  strokeWidth: 2,
                ),
              )
                  : Container(
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
}