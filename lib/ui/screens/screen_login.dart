import 'package:artrooms/ui/screens/screen_chats.dart';
import 'package:artrooms/ui/screens/screen_home.dart';
import 'package:flutter/material.dart';

import '../../utils/utils.dart';
import '../theme/theme_colors.dart';


class MyScreenLogin extends StatefulWidget {

  const MyScreenLogin({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MyScreeLoginState();
  }

}

class _MyScreeLoginState extends State<MyScreenLogin> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      home: Scaffold(
        backgroundColor: colorPrimaryPurple,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Spacer(flex: 2),
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'assets/images/icons/logo.png',
                      height: 60,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      '아트플룻 도넛',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                    child: TextField(
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFF7F94FE).withAlpha(255),
                        hintText: '이메일',
                        hintStyle: const TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                    child: TextField(
                      obscureText: true,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFF7F94FE).withAlpha(255),
                        hintText: '비밀번호',
                        hintStyle: const TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                        foregroundColor: colorPrimaryPurple,
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: const Text(
                        '로그인',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return const MyScreenChats();
                        }));
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TextButton(
                          child: const Text(
                            '아이디 찾기',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return const MyScreenHome(tab: 0);
                            }));
                          },
                        ),
                        Container(
                          width: 1,
                          height: 18,
                          color: Colors.white,
                          margin: const EdgeInsets.symmetric(horizontal: 8.0),
                        ),
                        TextButton(
                          child: const Text(
                            '비밀번호 찾기',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return const MyScreenHome(tab: 1);
                            }));
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Spacer(flex: 1),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.only(bottom: 20.0),
                child: TextButton(
                  style: TextButton.styleFrom(foregroundColor: Colors.white70),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '회원가입은 홈페이지에서 진행해주세요',
                        style: TextStyle(color: Colors.white70),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white70,
                        size: 16.0,
                      ),
                    ],
                  ),
                  onPressed: () {
                    launchInBrowser(Uri(scheme: 'https', host: 'artrooms.app', path: 'signup'));
                  },
                ),
              ),
              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}
