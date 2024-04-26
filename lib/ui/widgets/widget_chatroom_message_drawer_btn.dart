
import 'package:artrooms/beans/bean_chat.dart';
import 'package:artrooms/beans/bean_chatting_artist_profile.dart';
import 'package:artrooms/beans/bean_notice.dart';
import 'package:artrooms/modules/module_memo.dart';
import 'package:artrooms/modules/module_notices.dart';
import 'package:artrooms/modules/module_profile.dart';
import 'package:flutter/material.dart';

import '../../test_screen.dart';
import '../screens/screen_chatroom_drawer.dart';


Widget widgetChatroomMessageDrawerBtn(BuildContext context, DataChat dataChat,
    ModuleNotice moduleNotice,DataNotice dataNotice,ModuleMemo moduleMemo ) {
  return Container(
    width: 80,
    height: 80,
    decoration: const BoxDecoration(
      shape: BoxShape.circle,
    ),
    child: InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
          padding: const EdgeInsets.all(16.0),
          alignment: Alignment.centerRight,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: Image.asset(
            'assets/images/icons/icon_archive.png',
            width: 24,
            height: 24,
          )),
      onTap: () async{
      Navigator.push(context,
          MaterialPageRoute(builder: (context) {
            return ScreenChatroomDrawer(
              dataChat: dataChat,
            );
          }),
        );
      },
    ),
  );
}
