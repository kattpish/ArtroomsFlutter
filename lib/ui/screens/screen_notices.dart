
import 'package:artrooms/ui/theme/theme_colors.dart';
import 'package:flutter/material.dart';

import '../../beans/bean_notification.dart';


class MyScreenNotices extends StatefulWidget {

  const MyScreenNotices({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MyScreenNoticesState();
  }

}

class _MyScreenNoticesState extends State<MyScreenNotices> {

  final List<Notice> notifications = [
    Notice("2024.5.12", "프로젝트 공지", "* 첫 수업 공지사항  1.수업 전에 디스코드를 깔아 주세요 2. 마이크를 준비해주세요.  3. 이전에 그렸던 그림이 있다면", isVisible: true ),
    Notice("2024.5.5", "", "미팅이 오전으로 변경되었습니다.",  isVisible: false )
  ];

  void _viewDetails(BuildContext context, Notice notice) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(notice.title),
          content: Text(notice.body),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
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
        leading: const Icon(Icons.arrow_back_ios, color:colorMainGrey200,),
        title: const Text('공지'),
      ),
      body: ListView(
        children: notifications.map((notification) {
          return Card(
            margin: const EdgeInsets.all(10.0),
            elevation: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children:  [
                Container(
                  height: 1.0,
                  width: double.infinity,
                  color: colorMainGrey200,
                ),
                Row(
                  children: [
                    Text(
                      notification.date,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue
                      ),
                    ),
                    Visibility(
                        visible: notification.isVisible,
                        child: Container(
                          padding: const EdgeInsets.all(2.0),
                          margin: const EdgeInsets.all(6.0),
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape:  BoxShape.circle,
                          ),
                          child:const Icon(Icons.star, size:10, color: Colors.white,),)
                    ),
                    Text(
                      notification.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 15,
                      ),
                    )
                  ],
                ),
                Container(
                  height: 1.0,
                  width: double.infinity,
                  color: colorMainGrey200,
                ),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(notification.body),
                ),
                Container(
                  height: 1.0,
                  width: double.infinity,
                  color: colorMainGrey200,
                ),
                //
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
