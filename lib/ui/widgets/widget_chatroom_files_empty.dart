
import 'package:flutter/material.dart';

import '../theme/theme_colors.dart';


Widget widgetChatroomFilesEmpty(BuildContext context) {
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/images/icons/icon_file.png',
          width: 50.0,
          height: 50.0,
        ),
        const SizedBox(height: 14),
        const Text(
          '이 채팅방에는 파일이 없습니다',
          style: TextStyle(
            color: Color(0xFF565656),
            fontSize: 16,
            fontFamily: 'SUIT',
            fontWeight: FontWeight.w600,
            height: 0,
            letterSpacing: -0.32,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          '',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: colorMainGrey700,
            fontSize: 12,
            fontFamily: 'SUIT',
            fontWeight: FontWeight.w400,
            height: 0,
            letterSpacing: -0.24,
          ),
        ),
      ],
    ),
  );
}
