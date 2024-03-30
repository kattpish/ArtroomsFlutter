
import 'package:flutter/material.dart';

import '../theme/theme_colors.dart';


Widget widgetChatsEmpty(BuildContext context) {
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/images/icons/chat_blue.png',
          width: 50.0,
          height: 50.0,
        ),
        const SizedBox(height: 14),
        const Text(
          '채팅방이 없어요',
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
          '아트룸즈 홈페이지에서 상담신청을 하시거나\n라이브 클래스가 개설되면 채팅방이 개설됩니다',
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
