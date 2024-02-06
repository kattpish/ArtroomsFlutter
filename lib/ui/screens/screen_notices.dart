
import 'dart:js_interop';

import 'package:flutter/material.dart';


class MyScreenNotices extends StatefulWidget {

  const MyScreenNotices({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MyScreenNoticesState(

    );
  }

}
class Notification {
  final String date;
  final String title;
  final String body;
  IconData icon;

  Notification(this.date, this.title, this.body, {this.icon =Icons.star});
}
class _MyScreenNoticesState extends State<MyScreenNotices> {
  final List<Notification> notifications = [
    Notification("2024.5.12", "프로젝트 공지", "다음주는 쉽니다!",icon:Icons.star ),
    Notification("2024.5.5", "", "미팅이 오전으로 변경되었습니다.", icon: Icons.star )
    // ... Add more notifications
  ];

  void _viewDetails(BuildContext context, Notification notification) {
    // Navigate to the details screen or show a dialog
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(notification.title),
          content: Text(notification.body),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: ListView(
        children: notifications.map((notification) {
          return Card(
            margin: EdgeInsets.all(8.0),
            elevation: 0,
            child: Column(
              children:  [
                Row(
                  children: [
                    Text(
                      notification.date,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                   Icon(notification.icon as IconData?, color: Colors.blue),
                    const SizedBox(width: 8.0),
                    Text(
                      notification.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
                  Container(
                    child: Text(notification.body),
                      padding: EdgeInsets.all(16.0),

                  )
                  //
              ],),);
        }).toList(),
      ),
    );
  }

}
