
import 'package:artrooms/ui/screens/screen_notice_details.dart';
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
    Notice(
        0,
        "2024.5.12",
        "프로젝트 공지",
        "* 첫 수업 공지사항\n\n1. 수업 전에 디스코드를 깔아 주세요.\n2. 마이크를 준비해주세요.\n3. 이전에 그렸던 그림이 있다면artrooms@gmail.com 메일로 보내주세요.\n4. 선호하는 그림체가 있다면 그림을 모아서 첫 수업때 보여주세요.\n5. 수업환경을 수업 전에 점검해주세요.",
        isAdmin: true
    ),
    Notice(
        1,
        "2024.5.10",
        "",
        "다음주는 휴강입니다!",
        isAdmin: false
    ),
    Notice(
        2,
        "2024.5.5",
        "",
        "5월 과제 키워드는 ‘디저트’입니다\n디저트를 주제로 매일 한 장씩 아이디어 스케치 도전!",
        isAdmin: false
    )
  ];

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
          title: const Text(
              '공지 상세보기',
            style: TextStyle(
                color: colorMainGrey900,
                fontWeight: FontWeight.w600
            ),
          ),
          elevation: 0.5,
        ),
        backgroundColor: colorMainScreen,
        body: ListView(
          children: notifications.map((notice) {
            return Card(
              margin: const EdgeInsets.only(bottom: 8.0),
              elevation: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children:  [
                  Divider(
                    thickness: notice.index > 0 ? 1.0 : 0.0,
                    color: notice.index > 0 ? colorMainGrey200 : Colors.transparent,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
                    child: Row(
                      children: [
                        Text(
                          notice.date,
                          style: const TextStyle(
                            fontSize: 18,
                              color: colorPrimaryPurple,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Visibility(
                            visible: notice.isAdmin,
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
                          notice.title,
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
                            notice.body,
                          style: const TextStyle(
                            fontSize: 15,
                            color: colorMainGrey900,
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
                                visible: notice.isAdmin,
                                child: const Text(
                                    "상세보기",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: colorMainGrey500,
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
      ),
    );
  }

}
