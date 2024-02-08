import 'package:artrooms/ui/screens/screen_notifications.dart';
import 'package:artrooms/ui/theme/theme_colors.dart';
import 'package:flutter/material.dart';


class MyScreenNotificationsSounds extends StatefulWidget {

  const MyScreenNotificationsSounds({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MyScreenNotificationsSoundsState();
  }

}

class _MyScreenNotificationsSoundsState extends State<MyScreenNotificationsSounds> {

  final List<Map<String, dynamic>> _notifications = [
    {"title": "새로운알림", "enabled": true},
    {"title": "메시지알림", "enabled": false},
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Notifications and Sounds",
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
                color: colorMainGrey900,
                fontWeight: FontWeight.w600
            ),
          ),
          elevation: 0.5,
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
                    '알림음'
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const MyScreenNotifications();
                  }));
                },
                trailing: const Text(
                  '아룸 (기본)',
                  style: TextStyle(
                    color: colorPrimaryBlue400,
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
    return Switch(
      value: isEnabled,
      activeColor: colorPrimaryBlue,
      onChanged: (value) {
        _toggleNotification(index, value);
      },
    );
  }

  void _toggleNotification(int index, bool value) {
    setState(() {
      _notifications[index]['enabled'] = value;
    });
  }

}
