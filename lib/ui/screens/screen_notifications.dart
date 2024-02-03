import 'package:artrooms/ui/screens/screen_notifications_sounds.dart';
import 'package:flutter/material.dart';

import '../theme/theme_colors.dart';


class MyScreenNotifications extends StatefulWidget {

  const MyScreenNotifications({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MyScreenNotificationsState();
  }

}

class _MyScreenNotificationsState extends State<MyScreenNotifications> {

  final List<Map<String, dynamic>> _notifications = [
    {"title": "새로운알림", "enabled": true},
    {"title": "메시지알림", "enabled": false},
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Notifications",
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: colorMainGrey250),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text(
            '알림 및 소리',
            style: TextStyle(
                color: Colors.black
            ),
          ),
          elevation: 1,
        ),
        backgroundColor: colorMainScreen,
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 16),
              Column(
                children: _notifications.map((notification) {
                  int index = _notifications.indexOf(notification);
                  return ListTile(
                    title: Text(notification['title']),
                    trailing: _buildTrailingWidget(notification['enabled'], index),
                  );
                }).toList(),
              ),
              ListTile(
                title: const Text(
                    '알림음 2'
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const MyScreenNotificationsSounds();
                  }));
                },
                trailing: const Text(
                  '아룸 (기본)',
                  style: TextStyle(
                    color: colorPrimaryPurple400,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrailingWidget(bool isEnabled, int index) {
    return IconButton(
      icon: Icon(
          Icons.check,
          color: isEnabled ? colorPrimaryPurple : colorMainGrey100
      ),
      color: isEnabled ? Theme.of(context).primaryColor : null,
      onPressed: () {
        _toggleNotification(index, !isEnabled);
      },
    );
  }

  void _toggleNotification(int index, bool value) {
    setState(() {
      _notifications[index]['enabled'] = value;
    });
  }

}
