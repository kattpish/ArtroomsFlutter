import 'package:flutter/material.dart';

class DisplayMessageText extends StatelessWidget {
  final String message;
  const DisplayMessageText({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    List<TextSpan> parsedMessage = replacePattern(message);
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

List<TextSpan> replacePattern(String original) {
  List<TextSpan> spans=[];
  int lastMatchIndex=0;
  RegExp regex = RegExp(r'@.*?(?=\s)');
  Iterable<RegExpMatch> matches= regex.allMatches(original);

  for (var match in matches) {
    spans.add(TextSpan(text: original.substring(lastMatchIndex,match.start), style: const TextStyle(color: Colors.white)));
    spans.add(TextSpan(text: original.substring(match.start,match.end), style: const TextStyle(color: Colors.lightBlue)));
    lastMatchIndex=match.end;
  }
  spans.add(TextSpan(text: original.substring(lastMatchIndex,original.length), style: const TextStyle(color: Colors.white)));
  print("");
  return spans;
}
