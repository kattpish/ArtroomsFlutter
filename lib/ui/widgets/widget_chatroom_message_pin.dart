
import 'package:artrooms/ui/widgets/widget_ui_notify.dart';
import 'package:flutter/material.dart';

import '../../beans/bean_chat.dart';
import '../screens/screen_chatroom.dart';


Widget widgetChatMessagePin(BuildContext context, State state, {void Function()? onSelectChat}) {
  return Visibility(
    visible: dataChatPin.id.isNotEmpty,
    child: AnimatedOpacity(
      opacity: dataChatPin.id.isNotEmpty ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 500),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x19000000),
              blurRadius: 10,
              offset: Offset(0, 0),
              spreadRadius: 0,
            )
          ],
        ),
        child: InkWell(
          onTap: () {
            if(onSelectChat != null) {
              onSelectChat();
            }else {
              if(dataChatPin.isNew()) {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ScreenChatroom(dataChat: dataChatPin);
                }));
              }
            }
            notifyState(DataChat.empty());
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SizedBox(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          padding: const EdgeInsets.only(
                            top: 2.55,
                            left: 1.64,
                            right: 1.77,
                            bottom: 2.46,
                          ),
                          clipBehavior: Clip.antiAlias,
                          decoration: const BoxDecoration(),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 16.5,
                                height: 15,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                        "assets/images/icons/icon_chat.png"),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: SizedBox(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    dataChatPin.name,
                                    style: const TextStyle(
                                      color: Color(0xFF3A3A3A),
                                      fontSize: 14,
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w600,
                                      height: 0,
                                      letterSpacing: -0.28,
                                    ),
                                    maxLines: 1,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    dataChatPin.lastMessage.getSummary(),
                                    style: const TextStyle(
                                      color: Color(0xFF3A3A3A),
                                      fontSize: 14,
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w400,
                                      height: 0,
                                      letterSpacing: -0.28,
                                    ),
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 0,
                          height: 20,
                          clipBehavior: Clip.antiAlias,
                          decoration: const BoxDecoration(color: Colors.white),
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("assets/images/icons/icon_arrow_down.png"),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
