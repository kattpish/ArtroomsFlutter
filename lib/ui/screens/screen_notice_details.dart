
import 'package:artrooms/beans/bean_notification.dart';
import 'package:flutter/material.dart';

import '../theme/theme_colors.dart';


class MyScreenNoticeDetails extends StatefulWidget {

  final Notice notice;

  const MyScreenNoticeDetails({super.key, required this.notice});

  @override
  State<StatefulWidget> createState() {
    return _MyScreenNoticeDetailsState();
  }

}

class _MyScreenNoticeDetailsState extends State<MyScreenNoticeDetails> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Notices",
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: colorMainGrey250),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            widget.notice.title,
            style: const TextStyle(
                color: colorMainGrey900,
                fontWeight: FontWeight.w600
            ),
          ),
          elevation: 0.5,
        ),
        backgroundColor: colorMainScreen,
        body: SingleChildScrollView(
          child: Card(
            margin: const EdgeInsets.only(bottom: 8.0),
            elevation: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children:  [
                const Divider(
                  thickness: 0.0,
                  color: Colors.transparent,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
                  child: Row(
                    children: [
                      Text(
                        widget.notice.date,
                        style: const TextStyle(
                          fontSize: 18,
                          color: colorPrimaryPurple,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Visibility(
                          visible: widget.notice.isAdmin,
                          child: Container(
                            padding: const EdgeInsets.all(2.0),
                            margin: const EdgeInsets.all(6.0),
                            decoration: const BoxDecoration(
                              color: colorPrimaryPurple,
                              shape:  BoxShape.circle,
                            ),
                            child:const Icon(Icons.star, size:10, color: Colors.white,),)
                      ),
                      Text(
                        widget.notice.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                        ),
                      )
                    ],
                  ),
                ),
                const Divider(
                  thickness: 1.0,
                  color: colorMainGrey200,
                ),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.notice.body,
                        style: const TextStyle(
                            fontSize: 15,
                            color: colorMainGrey900,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8,),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
