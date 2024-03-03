
import 'package:flutter/material.dart';

import '../../beans/bean_notice.dart';
import '../theme/theme_colors.dart';


class MyScreenNoticeDetails extends StatefulWidget {

  final MyNotice notice;

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
          toolbarHeight: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: colorMainGrey250),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: const Text(
            "공지 상세보기",
            style: TextStyle(
                color: colorMainGrey900,
                fontWeight: FontWeight.w600
            ),
          ),
          elevation: 0.5,
        ),
        backgroundColor: colorMainScreen,
        bottomNavigationBar: BottomAppBar(
          notchMargin: 6.0,
          color: Colors.white,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: colorMainGrey250,
                  size: 20,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              const SizedBox(width: 2,),
              const Text(
                "공지 상세보기",
                style: TextStyle(
                  color: colorMainGrey900,
                  fontSize: 18,
                  fontFamily: 'SUIT',
                  fontWeight: FontWeight.w700,
                  height: 0,
                  letterSpacing: -0.36,
                ),
              )
            ],
          ),
        ),
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
                        widget.notice.getDate(),
                        style: const TextStyle(
                          fontSize: 18,
                          color: colorPrimaryBlue,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Visibility(
                          visible: widget.notice.noticeable,
                          child: Container(
                            padding: const EdgeInsets.all(2.0),
                            margin: const EdgeInsets.all(6.0),
                            decoration: const BoxDecoration(
                              color: colorPrimaryBlue,
                              shape:  BoxShape.circle,
                            ),
                            child:const Icon(Icons.star, size:10, color: Colors.white,),)
                      ),
                      const Text(
                        "widget.notice.title",
                        style: TextStyle(
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
                        widget.notice.notice,
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
