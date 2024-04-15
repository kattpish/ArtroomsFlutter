
import 'package:flutter/material.dart';

import '../../beans/bean_message.dart';
import '../../utils/utils_media.dart';
import '../theme/theme_colors.dart';


Widget buildAttachment(BuildContext context, State state, DataMessage message, screenWidth) {
  if (message.attachmentUrl.isNotEmpty) {
    return Container(
      width: 216,
      margin: const EdgeInsets.symmetric(vertical: 2),
      padding: const EdgeInsets.only(right: 18, left: 18, top: 14, bottom: 6),
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
                '${message.getAttachmentSize()} / ${message.getDate()}',
                style: const TextStyle(
                  color: colorMainGrey400,
                  fontSize: 11,
                  fontFamily: 'SUIT',
                  fontWeight: FontWeight.w400,
                  height: 0,
                  letterSpacing: -0.22,
                ),
              ),
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
                child: Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
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
              ),
            ],
          ),
          Center(
            child: Visibility(
                visible: message.isSending,
                child: Container(
                  constraints: BoxConstraints(maxWidth: screenWidth * 0.55, minHeight: 60),
                  color: const Color(0xFFFFFFFF).withOpacity(0.4),
                  child: Center(
                    child: Container(
                      width: 24,
                      height: 24,
                      alignment: Alignment.bottomRight,
                      child: const CircularProgressIndicator(
                        value: 50,
                        color: Color(0xFF6A79FF),
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                ),
            ),
          ),
        ],
      ),
    );
  } else {
    return const SizedBox.shrink();
  }
}
