
import 'package:flutter/cupertino.dart';


Widget widgetNotificationItemTick(Map<String, dynamic> notification, int index, String notificationEnabled, {required Null Function(dynamic index, dynamic isEnabled) onTap}) {

  bool isEnabled = notification['title'] == notificationEnabled;

  return GestureDetector(
    onTap: () {
      onTap(index, !isEnabled);
    },
    child: Image.asset(
      isEnabled ? 'assets/images/icons/icon_tick_on.png' : 'assets/images/icons/icon_tick_off.png',
      width: 24,
      height: 24,
    ),
  );
}

Widget widgetNotificationItemSwitch(bool isEnabled, int index, {required Null Function(dynamic index, dynamic isEnabled) onTap}) {
  return GestureDetector(
    onTap: () {
      onTap(index, !isEnabled);
    },
    child: Image.asset(
      isEnabled ? 'assets/images/icons/icon_switch_on.png' : 'assets/images/icons/icon_switch_off.png',
      width: 36,
      height: 20,
    ),
  );
}

