
import 'package:artrooms/ui/screens/screen_notifications.dart';
import 'package:artrooms/ui/theme/theme_colors.dart';
import 'package:flutter/material.dart';

import '../../data/module_datastore.dart';


class MyScreenNotificationsSounds extends StatefulWidget {

  const MyScreenNotificationsSounds({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MyScreenNotificationsSoundsState();
  }

}

class _MyScreenNotificationsSoundsState extends State<MyScreenNotificationsSounds> {

  MyDataStore myDataStore = MyDataStore();

  late final List<Map<String, dynamic>> _notifications;

  @override
  void initState() {
    super.initState();

    _notifications = [
      {"title": "채팅알림", "enabled": myDataStore.getBool("채팅알림", true)},
      {"title": "멘션알림", "enabled": myDataStore.getBool("멘션알림", false)},
    ];

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Notifications and Sounds",
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
          leadingWidth: 32,
          title: const Text(
            '알림 및 소리',
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
        body: SingleChildScrollView(
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
                      trailing: _buildTrailingWidget(notification['enabled'], index),
                    ),
                  );
                }).toList(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ListTile(
                  title: const Text(
                    '알림음',
                    style: TextStyle(
                      color: Color(0xFF111111),
                      fontSize: 16,
                      fontFamily: 'SUIT',
                      fontWeight: FontWeight.w400,
                      height: 0,
                      letterSpacing: -0.32,
                    ),
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
                      fontFamily: 'SUIT',
                      fontWeight: FontWeight.w400,
                      height: 0,
                      letterSpacing: -0.32,
                    ),
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
    return GestureDetector(
      onTap: () {
        _toggleNotification(index, !isEnabled);
      },
      child: Image.asset(
        isEnabled ? 'assets/images/icons/icon_switch_on.png' : 'assets/images/icons/icon_switch_off.png',
        width: 36,
        height: 20,
      ),
    );
  }

  void _toggleNotification(int index, bool value) {
    setState(() {
      myDataStore.setBool(_notifications[index]['title'], value);
      _notifications[index]['enabled'] = value;
    });
  }

}
