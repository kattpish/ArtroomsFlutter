
import 'package:artrooms/data/module_datastore.dart';
import 'package:artrooms/ui/screens/screen_chats.dart';
import 'package:artrooms/ui/screens/screen_login_reset.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../main.dart';
import '../../modules/module_auth.dart';
import '../../modules/module_profile.dart';
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

  final UserModule userModule = UserModule();
  final AuthModule authModule = AuthModule();

  @override
  void initState() {
    super.initState();

    if(MyDataStore().isLoggedIn()) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
        return const MyScreenChats();
      }));
      return;
    }

    _emailController.text = "artrooms@test.com";
    _passwordController.text = "1234";
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
                  children: [
                    Expanded(
                      child: Center(
                        child: SingleChildScrollView(
                          child: Container(
                            constraints: const BoxConstraints(maxWidth: 375),
                            child: Column(
                              children: <Widget>[
                                SizedBox(height: MediaQuery.of(context).size.height / 6),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Image.asset(
                                      'assets/images/icons/logo.png',
                                      height: 60,
                                    ),
                                    const SizedBox(height: 20),
                                    const Text(
                                      '아트플룻 도넛',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 26,
                                        fontFamily: 'LINE Seed Sans KR',
                                        fontWeight: FontWeight.w400,
                                        letterSpacing: -0.52,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 45),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                      child: TextField(
                                        controller: _emailController,
                                        focusNode: _emailFocus,
                                        autofocus: false,
                                        keyboardType: TextInputType.emailAddress,
                                        textInputAction: TextInputAction.next,
                                        onSubmitted: (_) {
                                          FocusScope.of(context).requestFocus(_passwordFocus);
                                        },
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontFamily: 'SUIT',
                                          fontWeight: FontWeight.w300,
                                          height: 0,
                                          letterSpacing: -0.28,
                                        ),
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: const Color(0xFF7F94FE).withAlpha(255),
                                          hintText: '아이디 입력',
                                          hintStyle: const TextStyle(color: Colors.white),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(30.0),
                                            borderSide: BorderSide.none,
                                          ),
                                            contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                      child: TextField(
                                        controller: _passwordController,
                                        focusNode: _passwordFocus,
                                        textInputAction: TextInputAction.done,
                                        onSubmitted: (_) {
                                          _attemptLogin(context);
                                        },
                                        obscureText: true,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontFamily: 'SUIT',
                                          fontWeight: FontWeight.w300,
                                          height: 0,
                                          letterSpacing: -0.28,
                                        ),
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: const Color(0xFF7F94FE).withAlpha(255),
                                          hintText: '비밀번호 입력',
                                          hintStyle: const TextStyle(color: Colors.white),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(30.0),
                                            borderSide: BorderSide.none,
                                          ),
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Container(
                                      height: 54,
                                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          elevation: 0,
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
                                            color: Color(0xFF6A79FF),
                                            fontSize: 18,
                                            fontFamily: 'SUIT',
                                            fontWeight: FontWeight.w700,
                                            height: 0,
                                            letterSpacing: -0.36,
                                          ),
                                        ),
                                        onPressed: () {
                                          _attemptLogin(context);
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          TextButton(
                                            child: const Text(
                                              '아이디 찾기',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontFamily: 'SUIT',
                                                fontWeight: FontWeight.w400,
                                                height: 0,
                                                letterSpacing: -0.28,
                                              ),
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
                                            margin: const EdgeInsets.symmetric(horizontal: 20.0),
                                          ),
                                          TextButton(
                                            child: const Text(
                                              '비밀번호 찾기',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontFamily: 'SUIT',
                                                fontWeight: FontWeight.w400,
                                                height: 0,
                                                letterSpacing: -0.28,
                                              ),
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
                                const SizedBox(height: 80),
                                Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.only(bottom: 20.0),
                                  child: TextButton(
                                    style: TextButton.styleFrom(foregroundColor: Colors.white70),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text(
                                          '회원가입은 홈페이지에서 진행해주세요',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontFamily: 'SUIT',
                                            fontWeight: FontWeight.w400,
                                            height: 0,
                                            letterSpacing: -0.28,
                                          ),
                                        ),
                                        Container(
                                          width: 16,
                                          height: 16,
                                          alignment: Alignment.center,
                                          child: const Icon(
                                            Icons.arrow_forward_ios,
                                            color: Colors.white,
                                            size: 12.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                    onPressed: () {
                                      launchInBrowser(Uri(scheme: 'https', host: 'artrooms.com', path: ''));
                                    },
                                  ),
                                ),
                                const SizedBox(height: 40),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
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

    String email = _emailController.text;

    authModule.login(
      email: email,
      password: _passwordController.text,
      loginRemember: true,
      callback: (bool success, String? accessToken, String? refreshToken) async {

        if (success) {

          await myDataStore.saveTokens(email, accessToken, refreshToken);

          Map<String, dynamic>? profile = await userModule.getMyProfile();
          if (profile != null) {

            await myDataStore.saveProfile(profile);

            if (kDebugMode) {
              print("User Profile: $profile");
            }

          } else {
            if (kDebugMode) {
              print("Failed to fetch user profile.");
            }
          }

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
