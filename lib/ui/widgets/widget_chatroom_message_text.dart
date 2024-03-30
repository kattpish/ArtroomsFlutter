
import 'package:artrooms/utils/utils.dart';
import 'package:flutter/material.dart';


class WidgetChatroomMessageText extends StatelessWidget {

  final String message;
  final Color color;
  const WidgetChatroomMessageText({super.key, required this.message, required this.color});

  @override
  Widget build(BuildContext context) {
    List<TextSpan> parsedMessage = replacePattern(message, color, false);
    return RichText(
        softWrap: true,
        selectionColor: color,
        text: TextSpan(
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontFamily: 'SUIT',
            fontWeight: FontWeight.w400,
            letterSpacing: -0.32,
          ),
          children: parsedMessage,
        ));
  }

}
