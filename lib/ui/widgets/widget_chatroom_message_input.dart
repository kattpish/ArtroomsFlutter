
import 'package:flutter/material.dart';

import '../theme/theme_colors.dart';


Widget widgetChatroomMessageInput(TextEditingController messageController, messageFocusNode, {required Null Function(String text) onChanged}) {
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
    ],
  );
}
