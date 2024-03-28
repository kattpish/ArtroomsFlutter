import 'package:artrooms/utils/utils.dart';
import 'package:flutter/material.dart';

class DisplayMessageText extends StatelessWidget {
  final String message;
  const DisplayMessageText({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    List<TextSpan> parsedMessage = replacePattern(message,false);
    return RichText(
      softWrap: true,
        text: TextSpan(
        style:  const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontFamily: 'SUIT',
        fontWeight: FontWeight.w400,
        // height: 0.9,
        // letterSpacing: -0.32,
    ),
    children: parsedMessage,
    ));
  }
}


