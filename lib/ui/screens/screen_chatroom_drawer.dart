
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
        title: const Text('설정'),
        actions: [
          Container(
            decoration: const BoxDecoration(
                color: colorMainGrey200,
                shape: BoxShape.circle
            ),
            padding: const EdgeInsets.all(3.0),
            height: 30.0,
            width: 30.0,
            child:const Icon(Icons.close,color: Colors.white,),
          )
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  margin: EdgeInsets.all(16.0),
                  child:Image.asset('assets/images/profile/profile_2.png',
                    width: 80,
                    height: 80,),
                ),
                Column(
                  children: [
                    Text(
                        '설정설정'
                    ),
                    Text(
                        'LEEWONBIN'
                    )
                  ],
                )
              ],
            ),
            Container(
                padding: EdgeInsets.all(10.0),

                color: colorMainGrey200,
                child: Row(
                  children: [
                    Column(
                      children: [
                        Text('주중피드백'),
                        Text('수업상담'),
                        Text('채팅가능시간'),
                        Text('평균응답시간'),
                        Text('평균응답시간'),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.all(60.0),
                      color: Colors.transparent,
                    ),
                    Column(
                      children: [
                        Text('간단히 가능'),
                        Text('불가능'),
                        Text('월 화 수'),
                        Text(' 11시~20시'),
                        Text('하루 이내'),
                      ],
                    )
                  ],
                )
            ),
            Container(
              child: Column(
                children:[
                  ListTile(
                    title: Text('공지'),
                    trailing: Icon(Icons.chevron_right),
                  ),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: '메모가 없습니다.',
                    ),
                  )
                ],
              ),
            ),
            Container(
              child: Column(
                children:[
                  ListTile(
                    title: Text('공지'),
                    trailing: Icon(Icons.chevron_right),
                  ),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: '메모가 없습니다.',
                    ),
                  )
                ],
              ),
            ),
            Container(
              child: Column(
                children:[
                  ListTile(
                    title: Text('공지'),
                    trailing: Icon(Icons.chevron_right),
                  ),

                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
