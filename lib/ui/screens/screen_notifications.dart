
import 'package:flutter/material.dart';

import '../../data/module_datastore.dart';
import '../../listeners/scroll_bouncing_physics.dart';
import '../../main.dart';
import '../theme/theme_colors.dart';
import '../widgets/widget_notifications.dart';
import '../widgets/widget_ui_notify.dart';


class ScreenNotifications extends StatefulWidget {

  const ScreenNotifications({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ScreenNotificationsState();
  }

}

class _ScreenNotificationsState extends State<ScreenNotifications> {

  late String _notificationEnabled;
  late final List<Map<String, dynamic>> _notifications;

  @override
  void initState() {
    super.initState();

    _notificationEnabled = dbStore.getNotificationValue();

    _notifications = [
      {"title": "아룸 (기본)"},
      {"title": "알림음"},
      {"title": "알림음 2"},
    ];

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Notifications",
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 10.0),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: colorMainGrey250,
                size: 20,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          toolbarHeight: 60,
          titleSpacing: 0,
          leadingWidth: 46,
          title: const Text(
            '알림음',
            style: TextStyle(
              color: colorMainGrey900,
              fontSize: 18,
              fontFamily: 'SUIT',
              fontWeight: FontWeight.w700,
              height: 0,
              letterSpacing: -0.36,
            ),
          ),
          elevation: 0,
        ),
        backgroundColor: colorMainScreen,
        body: WidgetUiNotify(
          child: ScrollConfiguration(
            behavior: scrollBehavior,
            child: SingleChildScrollView(
              // physics: const ScrollPhysicsBouncing(),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Column(
                    children: _notifications.map((notification) {
                      int index = _notifications.indexOf(notification);
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: ListTile(
                          title: Text(
                            notification['title'],
                            style: const TextStyle(
                              color: Color(0xFF111111),
                              fontSize: 16,
                              fontFamily: 'SUIT',
                              fontWeight: FontWeight.w400,
                              height: 0,
                              letterSpacing: -0.32,
                            ),
                          ),
                          trailing: widgetNotificationItemTick(notification, index, _notificationEnabled,
                              onTap: (index, isEnabled) {
                                _doToggleNotification(index, isEnabled);
                              }
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _doToggleNotification(int index, bool value) {
    dbStore.setNotificationValue(_notifications[index]['title']);
    setState(() {
      _notificationEnabled = _notifications[index]["title"];
    });
  }

}
