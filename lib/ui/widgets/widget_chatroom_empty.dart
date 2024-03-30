
import 'package:flutter/cupertino.dart';

import '../theme/theme_colors.dart';


Widget widgetChatroomEmpty(BuildContext context) {
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/images/icons/icon_chat.png',
          width: 54.0,
          height: 54.0,
        ),
        const SizedBox(height: 17),
        const Text(
          '대화내용이 없어요',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: colorMainGrey700,
            fontSize: 14,
            fontFamily: 'SUIT',
            fontWeight: FontWeight.w400,
            height: 0,
            letterSpacing: -0.28,
          ),
        ),
      ],
    ),
  );
}
