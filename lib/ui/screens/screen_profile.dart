
import 'package:artrooms/ui/screens/screen_login.dart';
import 'package:artrooms/ui/screens/screen_profile_edit.dart';
import 'package:flutter/material.dart';

import '../theme/theme_colors.dart';


class MyScreenProfile extends StatefulWidget {

  const MyScreenProfile({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MyScreenProfileState();
  }

}

class _MyScreenProfileState extends State<MyScreenProfile> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '설정',
          style: TextStyle(
              color: colorMainGrey900,
              fontWeight: FontWeight.w600
          ),
        ),
        leadingWidth: 0,
        actions: [
          Container(
            width: 30,
            height: 30,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: const BoxDecoration(
              color: colorMainGrey200,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(
                Icons.close,
                size: 20,
                color: Colors.white,
              ),
              padding: const EdgeInsets.all(4),
              constraints: const BoxConstraints(),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          )
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Row(
              children: [
                const SizedBox(width: 12),
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.transparent,
                  child: FadeInImage.assetNetwork(
                    placeholder: 'assets/images/profile/placeholder.png',
                    image: 'https://via.placeholder.com',
                    fit: BoxFit.cover,
                    fadeInDuration: const Duration(milliseconds: 200),
                    fadeOutDuration: const Duration(milliseconds: 200),
                    imageErrorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/images/profile/placeholder.png',
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '이유미',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '직함',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: TextButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  backgroundColor: colorMainGrey150,
                  foregroundColor: colorMainGrey700,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: const Text(
                  '프로필 수정',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const MyScreenProfileEdit();
                  }));
                },
              ),
            ),
            ListTile(
              title: const Text('지원하기'),
              onTap: () {

              },
            ),
            const Divider(
              thickness: 2,
              color: colorMainGrey150,
            ),
            ListTile(
              title: const Text('알림 및 소리'),
              onTap: () {

              },
            ),
            ListTile(
              title: const Text('지원하기'),
              onTap: () {

              },
            ),
            ListTile(
              title: const Text('약관 및 정책'),
              onTap: () {

              },
            ),
            ListTile(
              title: const Text('버전정보'),
              onTap: () {

              },
              trailing: const Text(
                'v.24.01.01',
                style: TextStyle(
                  color: colorPrimaryBlue400,
                  fontSize: 14,
                ),
              ),
            ),
            const Divider(
              thickness: 2,
              color: colorMainGrey150,
            ),
            ListTile(
                title: const Text('로그아웃'),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const MyScreenLogin();
                  }));
                }
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

}
