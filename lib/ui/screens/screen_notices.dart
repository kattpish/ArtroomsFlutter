
import 'dart:js_interop';

import 'package:artrooms/ui/theme/theme_colors.dart';
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
  bool isVisible;

  Notification(this.date, this.title, this.body, {this.isVisible = true});

}
class _MyScreenNoticesState extends State<MyScreenNotices> {
  final List<Notification> notifications = [
    Notification("2024.5.12", "프로젝트 공지", "* 첫 수업 공지사항  1.수업 전에 디스코드를 깔아 주세요 2. 마이크를 준비해주세요.  3. 이전에 그렸던 그림이 있다면", isVisible: true ),
    Notification("2024.5.5", "", "미팅이 오전으로 변경되었습니다.",  isVisible: false )
  ];



  void _viewDetails(BuildContext context, Notification notification) {
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
        leading: Icon(Icons.arrow_back_ios,color:colorMainGrey200,),
        title: Text('공지'),
      ),
      body: ListView(
        children: notifications.map((notification) {
          return Card(
            margin: EdgeInsets.all(10.0),
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
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue
                      ),
                    ),

                    Visibility(

                        visible: notification.isVisible,
                        child: Container(
                          child:Icon(Icons.star,size:10, color: Colors.white,),
                          padding: EdgeInsets.all(2.0),
                          margin: EdgeInsets.all(6.0),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            shape:  BoxShape.circle,
                          ),)

                    ),

                    Text(
                      notification.title,
                      style: TextStyle(
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
                  child: Text(notification.body),
                  padding: EdgeInsets.all(16.0),

                ),
                Container(
                  height: 1.0,
                  width: double.infinity,
                  color: colorMainGrey200,
                ),
                //
              ],),);
        }).toList(),
      ),
    );
  }

}
