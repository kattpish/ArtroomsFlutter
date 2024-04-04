
import 'package:artrooms/ui/widgets/widget_chatroom_message_span.dart';
import 'package:flutter/material.dart';
import 'package:rich_text_editor_controller/rich_text_editor_controller.dart';

import '../theme/theme_colors.dart';


Widget widgetChatroomMessageInput(TextEditingController messageController, RichTextEditorController richTextEditorController, messageFocusNode, {required Null Function(String text) onChanged}) {
  return Stack(
    alignment: Alignment.topLeft,
    children: <Widget>[
      Visibility(
        visible: true,
        child: TextFormField(
          controller: messageController,
          focusNode: messageFocusNode,
          minLines: 1,
          maxLines: 3,
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.newline,
          textCapitalization: TextCapitalization.sentences,
          onChanged: (text) {
            onChanged(text);
          },
          decoration: InputDecoration(
            hintText: '',
            border: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: const Color(0xFFF3F3F3),
          ),
          style: const TextStyle(
            color: colorMainGrey800,
            fontSize: 15.8,
            letterSpacing: 1.2,
            height: 1.4,
          ),
        ),
      ),
      Visibility(
        visible: false,
        child: Positioned(
          top: 12.5,
          left: 12.5,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF3F3F3),
              borderRadius: BorderRadius.circular(25),
            ),
            child: RichText(
              maxLines: 3,
              text: widgetChatroomMessageTextSpan(messageController.text),
            ),
          ),
        ),
      ),
      Visibility(
        visible: false,
        child: RichTextField(
          controller: richTextEditorController,
          maxLines: 10,
          minLines: 1,
          onChanged: (char) {
            updateMentions(richTextEditorController);
          },
        ),
      ),
    ],
  );
}

void updateMentions(RichTextEditorController richTextEditorController) {

  final newDeltas = <TextDelta>[];
  final regex = RegExp(r'@\w+');

  for (final delta in richTextEditorController.deltas) {
    final matches = regex.allMatches(delta.char);
    if (matches.isEmpty) {
      newDeltas.add(delta);
      continue;
    }

    int lastEnd = 0;
    for (final match in matches) {
      if (match.start > lastEnd) {
        newDeltas.add(TextDelta(char: delta.char.substring(lastEnd, match.start)));
      }
      newDeltas.add(TextDelta(
        char: delta.char.substring(match.start, match.end),
        metadata: delta.metadata?.copyWith(color: Colors.blue),
      ));
      lastEnd = match.end;
    }
    if (lastEnd < delta.char.length) {
      newDeltas.add(TextDelta(char: delta.char.substring(lastEnd)));
    }
  }

  print(richTextEditorController.text);

  richTextEditorController.setDeltas(newDeltas);
}