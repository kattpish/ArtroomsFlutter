import 'package:artrooms/modules/module_datastore.dart';
import 'package:artrooms/ui/screens/screen_chats.dart';
import 'package:artrooms/ui/screens/screen_login_reset.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../modules/module_auth.dart';
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

  bool _isLoading = false;
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if(MyDataStore().isLoggedIn()) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
        return const MyScreenChats();
      }));
      return;
    }

  }

  @override
  void dispose() {
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: MaterialApp(
        title: 'Login',
        home: Scaffold(
          backgroundColor: colorPrimaryBlue,
          body: Builder(
            builder: (context) {
              return SafeArea(
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
                    const SizedBox(height: 40),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                          child: TextField(
                            controller: _emailController,
                            focusNode: _emailFocus,
                            autofocus: false,
                            textInputAction: TextInputAction.next,
                            onSubmitted: (_) {
                              FocusScope.of(context).requestFocus(_passwordFocus);
                            },
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
                            controller: _passwordController,
                            focusNode: _passwordFocus,
                            textInputAction: TextInputAction.done,
                            onSubmitted: (_) {
                              _attemptLogin(context);
                            },
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
                              foregroundColor: colorPrimaryBlue,
                              backgroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Color(0xFF6A79FF),
                                strokeWidth: 3,
                              ),
                            )
                                : const Text(
                              '로그인',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600
                              ),
                            ),
                            onPressed: () {
                              _attemptLogin(context);
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
                                    return const MyScreenLoginReset(tab: 0);
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
                                    return const MyScreenLoginReset(tab: 1);
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
                          launchInBrowser(Uri(scheme: 'https', host: 'artrooms.com', path: ''));
                        },
                      ),
                    ),
                    const Spacer(flex: 1),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _attemptLogin(BuildContext context) {

    if(_isLoading) return;

    if (_emailController.text.isEmpty) {
      showSnackBar(context, "이메일을 입력해주세요");
      return;
    }
    if (!isEmailValid(_emailController.text)) {
      showSnackBar(context, "유효한 이메일을 입력해주세요");
      return;
    }
    if (_passwordController.text.isEmpty) {
      showSnackBar(context, "비밀번호를 입력해주세요");
      return;
    }

    closeKeyboard(context);

    setState(() {
      _isLoading = true;
    });

    AuthModule authModule = AuthModule();
    authModule.login(
      email: _emailController.text,
      password: _passwordController.text,
      loginRemember: true,
      callback: (bool success, String? accessToken, String? refreshToken) async {

        if (success) {

          MyDataStore().saveTokens(accessToken, refreshToken);

          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
            return const MyScreenChats();
          }));

        } else {
          showSnackBar(context, "로그인 실패");
        }

        setState(() {
          _isLoading = false;
        });

      },
    );

  }

}
