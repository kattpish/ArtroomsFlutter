
import 'package:flutter/material.dart';

import '../../beans/bean_notice.dart';
import '../../utils/utils_screen.dart';
import '../theme/theme_colors.dart';


class MyScreenNoticeDetails extends StatefulWidget {

  final DataNotice dataNotice;

  const MyScreenNoticeDetails({super.key, required this.dataNotice});

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
          toolbarHeight: isTablet(context) ? 60 : 60,
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
              fontSize: 19,
              fontFamily: 'SUIT',
              fontWeight: FontWeight.w700,
              height: 0,
              letterSpacing: -0.38,
            ),
          ),
          leadingWidth: 32,
          elevation: 0.5,
        ),
        backgroundColor: colorMainScreen,
        bottomNavigationBar: BottomAppBar(
          height: isTablet(context) ? 0 : 0,
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
          child: Container(
            margin: const EdgeInsets.only(bottom: 8.0),
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
                        widget.dataNotice.getDate(),
                        style: const TextStyle(
                          color: colorPrimaryBlue,
                          fontSize: 15,
                          fontFamily: 'SUIT',
                          fontWeight: FontWeight.w600,
                          height: 0,
                          letterSpacing: -0.30,
                        ),
                      ),
                      Visibility(
                          visible: widget.dataNotice.noticeable,
                          child: Container(
                            padding: const EdgeInsets.all(2.0),
                            margin: const EdgeInsets.all(6.0),
                            decoration: const BoxDecoration(
                              color: colorPrimaryBlue,
                              shape:  BoxShape.circle,
                            ),
                            child:const Icon(Icons.star, size:10, color: Colors.white,),)
                      ),
                      Text(
                        widget.dataNotice.title,
                        style: const TextStyle(
                          color: Color(0xFF7D7D7D),
                          fontSize: 13,
                          fontFamily: 'SUIT',
                          fontWeight: FontWeight.w400,
                          height: 0,
                          letterSpacing: -0.26,
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 4,),
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
                        widget.dataNotice.notice,
                        style: const TextStyle(
                          color: colorMainGrey900,
                          fontSize: 19,
                          fontFamily: 'SUIT',
                          fontWeight: FontWeight.w700,
                          height: 0,
                          letterSpacing: -0.38,
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
