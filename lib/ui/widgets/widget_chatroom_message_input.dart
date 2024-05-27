
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
            contentPadding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
          ),
          style: const TextStyle(
            color: colorMainGrey800,
            fontSize: 16,
            letterSpacing: -0.32,
            fontFamily: 'SUIT',
            fontWeight: FontWeight.w400,
            height: 1.0,
          ),
        ),
      ),
    ],
  );
}
