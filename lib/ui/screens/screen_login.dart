import 'package:flutter/material.dart';

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
                    const Text(
                      '아트플룻 도넛',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
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
                        ),
                      ),
                      onPressed: () {

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

                          },
                        ),
                        Container(
                          width: 1,
                          height: 20,
                          color: Colors.white70,
                        ),
                        TextButton(
                          child: const Text(
                            '비밀번호 찾기',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {

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
                    // Sign up logic here
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
