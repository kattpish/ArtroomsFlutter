
import 'package:flutter/material.dart';

import '../../data/module_datastore.dart';
import '../theme/theme_colors.dart';


class MyScreenNotifications extends StatefulWidget {

  const MyScreenNotifications({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MyScreenNotificationsState();
  }

}

class _MyScreenNotificationsState extends State<MyScreenNotifications> {

  MyDataStore myDataStore = MyDataStore();

  late final List<Map<String, dynamic>> _notifications;

  @override
  void initState() {
    super.initState();

    _notifications = [
      {"title": "아룸 (기본)", "enabled": myDataStore.getBool("아룸 (기본)", true)},
      {"title": "알림음", "enabled": myDataStore.getBool("알림음", false)},
      {"title": "알림음 2", "enabled": myDataStore.getBool("알림음 2", false)},
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
          leadingWidth: 32,
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrailingWidget1(bool isEnabled, int index) {
    return IconButton(
      icon: Icon(
          Icons.check,
          color: isEnabled ? colorPrimaryBlue : colorMainGrey100
      ),
      color: isEnabled ? Theme.of(context).primaryColor : null,
      onPressed: () {
        _toggleNotification(index, !isEnabled);
      },
    );
  }

  Widget _buildTrailingWidget(bool isEnabled, int index) {
    return GestureDetector(
      onTap: () {
        _toggleNotification(index, !isEnabled);
      },
      child: Image.asset(
        isEnabled ? 'assets/images/icons/icon_tick_on.png' : 'assets/images/icons/icon_tick_off.png',
        width: 24,
        height: 24,
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
