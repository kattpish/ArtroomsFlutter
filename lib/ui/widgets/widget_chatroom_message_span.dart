
import 'package:flutter/cupertino.dart';

import '../../utils/utils.dart';
import '../theme/theme_colors.dart';


TextSpan widgetChatroomMessageTextSpan(String text) {
  return TextSpan(
    style: const TextStyle(
      fontSize: 15.8,
      letterSpacing: 1.2,
      height: 1.4,

      color: colorMainGrey800,
    ),
    children: replacePattern(text, colorMainGrey800, colorPrimaryPurple, true),
  );
}
