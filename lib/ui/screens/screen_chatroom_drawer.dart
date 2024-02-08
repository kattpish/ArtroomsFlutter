
import 'package:artrooms/ui/screens/screen_chatroom_file.dart';
import 'package:artrooms/ui/screens/screen_memo.dart';
import 'package:artrooms/ui/screens/screen_notifications_sounds.dart';
import 'package:flutter/material.dart';

import '../theme/theme_colors.dart';


class MyScreenChatroomDrawer extends StatefulWidget {

  const MyScreenChatroomDrawer({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MyScreenChatroomDrawerState();
  }

}

class _MyScreenChatroomDrawerState extends State<MyScreenChatroomDrawer> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          '채팅방 서랍',
          style: TextStyle(
              color: colorMainGrey900,
              fontWeight: FontWeight.w600
          ),
        ),
        leadingWidth: 0,
        actions: [
          Container(
            height: 30.0,
            width: 30.0,
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            padding: const EdgeInsets.all(4.0),
            decoration: const BoxDecoration(
                color: colorMainGrey200,
                shape: BoxShape.circle
            ),
            child: InkWell(
                child: const Icon(Icons.close,color: Colors.white,),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          )
        ],
        elevation: 1,
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(16.0),
                        child: Image.asset(
                          'assets/images/profile/profile_2.png',
                          width: 80,
                          height: 80,),
                      ),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '이원빈',
                            style: TextStyle(
                                fontSize: 18,
                                color: colorMainGrey900,
                                fontWeight: FontWeight.w800
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                              'LEEWONBIN'
                          )
                        ],
                      )
                    ],
                  ),
                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16.0),
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: colorMainGrey100,
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: const Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '주중피드백',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: colorMainGrey400,
                                    fontWeight: FontWeight.w400
                                ),
                              ),
                              Text('간단히 가능'),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('수업상담',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: colorMainGrey400,
                                    fontWeight: FontWeight.w400
                                ),
                              ),
                              Text('불가능'),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('채팅가능시간',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: colorMainGrey400,
                                    fontWeight: FontWeight.w400
                                ),
                              ),
                              Text('월 화 수',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: colorMainGrey800,
                                    fontWeight: FontWeight.w400
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('평균응답시간',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: colorMainGrey400,
                                    fontWeight: FontWeight.w400
                                ),
                              ),
                              Text(' 11시~20시',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: colorMainGrey800,
                                    fontWeight: FontWeight.w400
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('평균응답시간',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: colorMainGrey400,
                                    fontWeight: FontWeight.w400
                                ),
                              ),
                              Text('하루 이내',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: colorMainGrey800,
                                    fontWeight: FontWeight.w400
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                  ),
                  const SizedBox(height: 10),
                  Column(
                    children:[
                      ListTile(
                        title: const Text('메모',
                          style: TextStyle(
                              fontSize: 16,
                              color: colorMainGrey900,
                              fontWeight: FontWeight.w700
                          ),
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return const MyScreenMemo();
                          }));
                        },
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: const Color(0xFFE3E3E3), width: 1.0,),
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: '메모가 없습니다.',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          minLines: 2,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Column(
                    children:[
                      ListTile(
                        title: const Text('공지',
                          style: TextStyle(
                              fontSize: 16,
                              color: colorMainGrey900,
                              fontWeight: FontWeight.w700
                          ),
                        ),
                        trailing: Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return const MyScreenMemo();
                          }));
                        },
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: const Color(0xFFE3E3E3), width: 1.0,),
                        ),
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: '메모가 없습니다.',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          minLines: 2,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                        ),
                      )
                    ],
                  ),
                  Column(
                    children:[
                      ListTile(
                        title: const Text('이미지',
                          style: TextStyle(
                              fontSize: 16,
                              color: colorMainGrey900,
                              fontWeight: FontWeight.w700
                          ),
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return const MyScreenChatroomFile();
                          }));
                        },
                      ),
                      ListTile(
                        title: const Text('파일',
                          style: TextStyle(
                              fontSize: 16,
                              color: colorMainGrey900,
                              fontWeight: FontWeight.w700
                          ),
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return const MyScreenChatroomFile();
                          }));
                        },
                      ),
                      const Divider(
                        thickness: 2,
                        color: colorMainGrey150,
                      ),
                      ListTile(
                        title: const Text('대화상대',
                          style: TextStyle(
                              fontSize: 16,
                              color: colorMainGrey900,
                              fontWeight: FontWeight.w700
                          ),
                        ),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return const MyScreenChatroomFile();
                          }));
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 32),
            child: Column(
              children: [
                const Divider(
                  thickness: 2,
                  color: colorMainGrey150,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        icon: Image.asset('assets/images/icons/icon_send.png', width: 24, height: 24, color: const Color(0xFFD9D9D9),),
                        onPressed: () {
                          _onClickOption1(context);
                        }
                    ),
                    IconButton(
                        icon: Image.asset('assets/images/icons/icon_bell.png', width: 24, height: 24, color: const Color(0xFFD9D9D9),),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return const MyScreenNotificationsSounds();
                          }));
                        }
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _onClickOption1(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: const BoxDecoration(
                      color: colorMainGrey200,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.close,
                        size: 16,
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.all(4),
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  '채팅방 나가기',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                const Text(
                  '대화 내용이 모두 삭제됩니다.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: colorPrimaryPurple,
                    backgroundColor: colorPrimaryPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text(
                    '확인',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

}
