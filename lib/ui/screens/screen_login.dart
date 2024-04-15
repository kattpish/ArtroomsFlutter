
import 'package:artrooms/data/module_datastore.dart';
import 'package:artrooms/ui/screens/screen_channel_talk.dart';
import 'package:artrooms/ui/screens/screen_chats.dart';
import 'package:artrooms/ui/screens/screen_login_reset.dart';
import 'package:artrooms/utils/utils_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../listeners/scroll_bouncing_physics.dart';
import '../../main.dart';
import '../../modules/module_auth.dart';
import '../../modules/module_profile.dart';
import '../../utils/utils.dart';
import '../theme/theme_colors.dart';


class ScreenLogin extends StatefulWidget {

  final String onPageEmail;
  const ScreenLogin({super.key, required this.onPageEmail});

  @override
  State<StatefulWidget> createState() {
    return _ScreenLoginState();
  }

}

class _ScreenLoginState extends State<ScreenLogin> {

  bool _isLoading = false;
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final ModuleProfile _userModule = ModuleProfile();
  final ModuleAuth _authModule = ModuleAuth();

  @override
  void initState() {
    super.initState();

    if(widget.onPageEmail.isNotEmpty){
      _emailController.text = widget.onPageEmail;
    }

    if(DBStore().isLoggedIn()) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
        return const ScreenChats();
      }));
      return;
    }

    // _emailController.text = "artrooms@test.com";
    // _passwordController.text = "1234";
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
          backgroundColor: Colors.white,
          body: Builder(
            builder: (context) {
              return SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: ScrollConfiguration(
                          behavior: scrollBehavior,
                          child: SingleChildScrollView(
                            // physics: const ScrollPhysicsBouncing(),
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: isTablet(context) ? 50.0 : 20.0),
                              child: Column(
                                children: <Widget>[
                                  SizedBox(height: MediaQuery.of(context).size.height / 6),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        width: 56,
                                        height: 56,
                                        padding: const EdgeInsets.all(14),
                                        decoration: ShapeDecoration(
                                          gradient: const LinearGradient(
                                            begin: Alignment(0.71, -0.71),
                                            end: Alignment(-0.71, 0.71),
                                            colors: [Color(0xFF6A79FF), Color(0xFF6D6AFF)],
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(15.75),
                                          ),
                                        ),
                                        child: Image.asset(
                                          'assets/images/icons/logo.png',
                                          height: 60,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      const Text(
                                        'ARTROOMS',
                                        style: TextStyle(
                                          color: Color(0xFF6A79FF),
                                          fontSize: 20,
                                          fontFamily: 'Gmarket Sans',
                                          fontWeight: FontWeight.w500,
                                          height: 0,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 40),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        height: 54,
                                        decoration: ShapeDecoration(
                                          shape: RoundedRectangleBorder(
                                            side: const BorderSide(width: 1, color: Color(0xFFE3E3E3)),
                                            borderRadius: BorderRadius.circular(30),
                                          ),
                                        ),
                                        child: TextField(
                                          controller: _emailController,
                                          focusNode: _emailFocus,
                                          autofocus: false,
                                          keyboardType: TextInputType.emailAddress,
                                          textInputAction: TextInputAction.next,
                                          minLines: 1,
                                          maxLines: 1,
                                          onSubmitted: (_) {
                                            FocusScope.of(context).requestFocus(_passwordFocus);
                                          },
                                          style: const TextStyle(
                                            color: colorPrimaryBlue,
                                            fontSize: 14,
                                            fontFamily: 'SUIT',
                                            fontWeight: FontWeight.w300,
                                            height: 0,
                                            letterSpacing: -0.28,
                                          ),
                                          decoration: const InputDecoration(
                                            hintText: '아이디(이메일)',
                                            hintStyle: TextStyle(
                                              color: Color(0xFFBFBFBF),
                                              fontSize: 15,
                                              fontFamily: 'Pretendard',
                                              fontWeight: FontWeight.w400,
                                              height: 0,
                                              letterSpacing: -0.30,
                                            ),
                                            border: InputBorder.none,
                                            contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 18),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 14),
                                      Container(
                                        height: 54,
                                        decoration: ShapeDecoration(
                                          shape: RoundedRectangleBorder(
                                            side: const BorderSide(width: 1, color: Color(0xFFE3E3E3)),
                                            borderRadius: BorderRadius.circular(30),
                                          ),
                                        ),
                                        child: TextField(
                                          controller: _passwordController,
                                          focusNode: _passwordFocus,
                                          textInputAction: TextInputAction.done,
                                          minLines: 1,
                                          maxLines: 1,
                                          onSubmitted: (_) {
                                            _doLogin(context);
                                          },
                                          obscureText: true,
                                          style: const TextStyle(
                                            color: colorPrimaryBlue,
                                            fontSize: 14,
                                            fontFamily: 'SUIT',
                                            fontWeight: FontWeight.w300,
                                            height: 0,
                                            letterSpacing: -0.28,
                                          ),
                                          decoration: const InputDecoration(
                                            hintText: '비밀번호',
                                            hintStyle: TextStyle(
                                              color: Color(0xFFBFBFBF),
                                              fontSize: 15,
                                              fontFamily: 'Pretendard',
                                              fontWeight: FontWeight.w400,
                                              height: 0,
                                              letterSpacing: -0.30,
                                            ),
                                            border: InputBorder.none,
                                            contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 18),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 14),
                                      SizedBox(
                                        height: 54,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            elevation: 0,
                                            minimumSize: const Size(double.infinity, 48),
                                            foregroundColor: Colors.white,
                                            backgroundColor: colorPrimaryBlue,
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
                                              color: Colors.white,
                                              strokeWidth: 3,
                                            ),
                                          )
                                              : const Text(
                                            '로그인',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontFamily: 'SUIT',
                                              fontWeight: FontWeight.w700,
                                              height: 0,
                                              letterSpacing: -0.36,
                                            ),
                                          ),
                                          onPressed: () {
                                            _doLogin(context);
                                          },
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            TextButton(
                                              child: const Text(
                                                '아이디 찾기',
                                                style: TextStyle(
                                                  color: Color(0xFF8F8F8F),
                                                  fontSize: 14,
                                                  fontFamily: 'Pretendard',
                                                  fontWeight: FontWeight.w400,
                                                  height: 0,
                                                  letterSpacing: -0.28,
                                                ),
                                              ),
                                              onPressed: () {
                                                Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                  return const ScreenLoginReset(tab: 0);
                                                }));
                                              },
                                            ),
                                            Container(
                                              width: 1,
                                              height: 18,
                                              color: const Color(0xFFE3E3E3),
                                              margin: const EdgeInsets.symmetric(horizontal: 12.0),
                                            ),
                                            TextButton(
                                              child: const Text(
                                                '비밀번호 찾기',
                                                style: TextStyle(
                                                  color: Color(0xFF8F8F8F),
                                                  fontSize: 14,
                                                  fontFamily: 'Pretendard',
                                                  fontWeight: FontWeight.w400,
                                                  height: 0,
                                                  letterSpacing: -0.28,
                                                ),
                                              ),
                                              onPressed: () {
                                                Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                  return const ScreenLoginReset(tab: 1);
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
                                      style: TextButton.styleFrom(foregroundColor: colorPrimaryBlue,),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Text(
                                            '회원가입은 홈페이지에서 진행해주세요',
                                            style: TextStyle(
                                              color: Color(0xFF7D7D7D),
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
                                              color: colorMainGrey500,
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

  void _doLogin(BuildContext context) {
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

    _authModule.login(
      email: email,
      password: _passwordController.text,
      loginRemember: true,
      callback: (bool success, String? accessToken, String? refreshToken) async {

        if (success) {

          await dbStore.saveTokens(email, accessToken, refreshToken);

          Map<String, dynamic>? profile = await _userModule.getMyProfile();
          if (profile != null) {

            await dbStore.saveProfile(profile);

            if (kDebugMode) {
              print("User Profile: $profile");
            }

          } else {
            if (kDebugMode) {
              print("Failed to fetch user profile.");
            }
          }

          await moduleSendBird.initSendbird();

          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
            return const ScreenChats();
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
