
import 'package:flutter/cupertino.dart';

import '../../utils/utils.dart';
import '../theme/theme_colors.dart';


TextSpan widgetChatroomMessageTextSpan (String text) {
  return TextSpan(
    style: const TextStyle(fontSize: 15.8,letterSpacing: 0.5),
    children: replacePattern(text, colorMainGrey800, true),
  );
}
