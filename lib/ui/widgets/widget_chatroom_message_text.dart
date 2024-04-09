
import 'package:artrooms/utils/utils.dart';
import 'package:flutter/material.dart';


class WidgetChatroomMessageText extends StatelessWidget {

  final String message;
  final Color color;
  final Color colorMention;

  const WidgetChatroomMessageText({super.key, required this.message, required this.color, required this.colorMention});

  @override
  Widget build(BuildContext context) {

    List<TextSpan> parsedMessage = replacePattern(message, color, colorMention, false);

    return RichText(
        softWrap: true,
        selectionColor: color,
        textAlign: TextAlign.start,
        text: TextSpan(
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontFamily: 'SUIT',
            fontWeight: FontWeight.w400,
            letterSpacing: -0.32,
          ),
          children: parsedMessage,
        )
    );
  }

}
