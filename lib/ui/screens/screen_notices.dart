
import 'package:artrooms/beans/bean_notice.dart';
import 'package:artrooms/modules/module_notices.dart';
import 'package:artrooms/ui/screens/screen_notice_details.dart';
import 'package:artrooms/ui/theme/theme_colors.dart';
import 'package:flutter/material.dart';

import '../../beans/bean_chat.dart';
import '../../utils/utils_screen.dart';


class MyScreenNotices extends StatefulWidget {

  final MyChat myChat;

  const MyScreenNotices({super.key, required this.myChat});

  @override
  State<StatefulWidget> createState() {
    return _MyScreenNoticesState();
  }

}

class _MyScreenNoticesState extends State<MyScreenNotices> {

  bool _isLoading = true;
  final List<MyNotice> notifications = [];
  final ModuleNotice moduleNotice = ModuleNotice();
  
  @override
  void initState() {
    super.initState();
    _loadNotices();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Notices",
      home: Scaffold(
        appBar: AppBar(
          toolbarHeight: isTablet(context) ? 60 : 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: colorMainGrey250,
              size: 20,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          leadingWidth: 32,
          title: const Text(
            '공지',
            style: TextStyle(
              color: colorMainGrey900,
              fontSize: 18,
              fontFamily: 'SUIT',
              fontWeight: FontWeight.w700,
              height: 0,
              letterSpacing: -0.36,
            ),
          ),
          elevation: 0.5,
        ),
        bottomNavigationBar: BottomAppBar(
          height: isTablet(context) ? 0 : 60,
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
                '공지',
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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        backgroundColor: colorMainScreen,
        body: SafeArea(
          child: Stack(
            children: [
              ListView(
                children: notifications.map((notice) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8.0),
                    elevation: 0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:  [
                        Divider(
                          thickness: notice.id > 0 ? 1.0 : 0.0,
                          color: notice.id > 0 ? colorMainGrey200 : Colors.transparent,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
                          child: Row(
                            children: [
                              Text(
                                notice.getDate(),
                                style: const TextStyle(
                                  color: colorPrimaryBlue,
                                  fontSize: 14,
                                  fontFamily: 'SUIT',
                                  fontWeight: FontWeight.w600,
                                  height: 0,
                                  letterSpacing: -0.28,
                                ),
                              ),
                              Visibility(
                                  visible: notice.noticeable,
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
                                notice.noticeable ? "표시된 공지" : "",
                                style: const TextStyle(
                                  color: Color(0xFF7D7D7D),
                                  fontSize: 12,
                                  fontFamily: 'SUIT',
                                  fontWeight: FontWeight.w400,
                                  height: 0,
                                  letterSpacing: -0.24,
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
                                notice.notice,
                                style: const TextStyle(
                                  color: colorMainGrey900,
                                  fontSize: 16,
                                  fontFamily: 'SUIT',
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: -0.32,
                                ),
                                maxLines: 6,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                                    return MyScreenNoticeDetails(notice: notice);
                                  }));
                                },
                                child: Column(
                                  children: [
                                    const SizedBox(height: 16,),
                                    Visibility(
                                      visible: notice.noticeable,
                                      child: const Text(
                                        "상세보기",
                                        style: TextStyle(
                                          color: colorMainGrey500,
                                          fontSize: 14,
                                          fontFamily: 'SUIT',
                                          fontWeight: FontWeight.w300,
                                          letterSpacing: -0.28,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8,),
                      ],
                    ),
                  );
                }).toList(),
              ),
              Visibility(
                  visible: _isLoading,
                  child: const Center(
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        color: Color(0xFF6A79FF),
                        strokeWidth: 3,
                      ),
                    ),
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _loadNotices() {

    moduleNotice.getNotices(widget.myChat.id).then((List<MyNotice> listNotices) {

      setState(() {
        notifications.addAll(listNotices);
      });

    }).catchError((e) {

    }).whenComplete(() {

      setState(() {
        _isLoading = false;
      });

    });
    
  }

}
