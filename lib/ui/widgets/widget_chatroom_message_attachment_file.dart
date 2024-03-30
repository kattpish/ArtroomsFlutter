
import 'package:flutter/material.dart';

import '../../beans/bean_message.dart';
import '../../utils/utils_media.dart';
import '../theme/theme_colors.dart';


Widget buildAttachment(BuildContext context, State state, DataMessage message, screenWidth) {
  if (message.attachmentUrl.isNotEmpty) {
    return Container(
      width: 216,
      margin: const EdgeInsets.symmetric(vertical: 2),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      constraints: BoxConstraints(maxWidth: screenWidth * 0.55),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFE3E3E3),
          width: 1.0,
        ),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message.attachmentName,
                style: const TextStyle(
                  color: colorMainGrey700,
                  fontSize: 16,
                  fontFamily: 'SUIT',
                  fontWeight: FontWeight.w400,
                  height: 0,
                  letterSpacing: -0.32,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '${message.getAttachmentSize()} / ${message.getDate()} 만료',
                style: const TextStyle(
                  color: colorMainGrey400,
                  fontSize: 11,
                  fontFamily: 'SUIT',
                  fontWeight: FontWeight.w400,
                  height: 0,
                  letterSpacing: -0.22,
                ),
              ),
              const SizedBox(height: 10),
              InkWell(
                onTap: () async {

                  state.setState(() {
                    message.isDownloading = true;
                  });
                  await downloadFile(context, message.attachmentUrl, message.attachmentName);
                  state.setState(() {
                    message.isDownloading = false;
                  });

                },
                child: message.isDownloading
                    ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    color: Color(0xFF6A79FF),
                    strokeWidth: 2,
                  ),
                )
                    : const Text(
                  '저장',
                  style: TextStyle(
                    color: colorMainGrey400,
                    fontSize: 14,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w400,
                    height: 0,
                    letterSpacing: -0.28,
                  ),
                ),
              ),
            ],
          ),
          Visibility(
              visible: message.isSending,
              child: Container(
                constraints: BoxConstraints(maxWidth: screenWidth * 0.55),
                child: Center(
                  child: Container(
                    width: 10,
                    height: 10,
                    alignment: Alignment.bottomRight,
                    child: const CircularProgressIndicator(
                      color: Color(0xFF6A79FF),
                      strokeWidth: 2,
                    ),
                  ),
                ),
              ))
        ],
      ),
    );
  } else {
    return const SizedBox.shrink();
  }
}
