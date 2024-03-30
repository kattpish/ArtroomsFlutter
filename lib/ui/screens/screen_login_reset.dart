
import 'package:artrooms/ui/screens/screen_login.dart';
import 'package:flutter/material.dart';

import '../../modules/module_auth.dart';
import '../../utils/utils.dart';
import '../theme/theme_colors.dart';
import '../widgets/widget_login_reset_tab_id.dart';
import '../widgets/widget_login_reset_tab_password.dart';


class ScreenLoginReset extends StatefulWidget {

  final int tab;

  const ScreenLoginReset({super.key, required this.tab});

  @override
  State<StatefulWidget> createState() {
    return _ScreenLoginResetState();
  }

}

class _ScreenLoginResetState extends State<ScreenLoginReset> with SingleTickerProviderStateMixin {

  bool _isLoading = false;
  late TabController _tabController;
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final TextEditingController _nameController =  TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool _isButtonDisabled = true;

  final ModuleAuth _authModule = ModuleAuth();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_doHandleTabSelection);
    _nameController.addListener(_doCheckEnableButton);
    _phoneController.addListener(_doCheckEnableButton);
    _emailController.addListener(_doCheckEnableButton);

    _tabController.index = widget.tab;
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameFocus.dispose();
    _phoneFocus.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home',
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
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
          title: const Text(
            '아이디 · 비밀번호 찾기',
            style: TextStyle(
              color: Color(0xFF1F1F1F),
              fontSize: 18,
              fontFamily: 'SUIT',
              fontWeight: FontWeight.w700,
              height: 0,
              letterSpacing: -0.36,
            ),
          ),
          centerTitle: true,
          elevation: 0.2,
          toolbarHeight: 60,
          backgroundColor: Colors.white,
          bottom: TabBar(
            controller: _tabController,
            labelColor: const Color(0xFF1F1F1F),
            unselectedLabelColor: const Color(0xFF979797),
            indicatorColor: colorPrimaryBlue,
            indicatorWeight: 2.0,
            labelStyle: const TextStyle(
              color: Color(0xFF1F1F1F),
              fontSize: 18,
              fontFamily: 'SUIT',
              fontWeight: FontWeight.w500,
              height: 0,
              letterSpacing: -0.36,
            ),
            tabs: const [
              Tab(
                text: '아이디',
              ),
              Tab(
                  text: '비밀번호'
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: Builder(
            builder: (context) {
              return Column(
                children: [
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        widgetLoginRestTabId(context, _nameController, _phoneController, _nameFocus, _phoneFocus,
                            onSubmitted:() {
                              _doSubmit(context);
                            }
                        ),
                        widgetLoginRestTabPassword(context, _emailController,
                            onSubmitted:() {
                              _doSubmit(context);
                            }
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 44,
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        _doSubmit(context);
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: _isButtonDisabled ? colorPrimaryBlue.withAlpha(100) : colorPrimaryBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        elevation: 0,
                        textStyle: const TextStyle(fontSize: 18),
                        fixedSize: const Size.fromHeight(60),
                      ),
                      child:  _isLoading
                          ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Color(0xFFFFFFFF),
                          strokeWidth: 3,
                        ),
                      )
                          : const Text(
                          '인증메일 전송',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'SUIT',
                            fontWeight: FontWeight.w700,
                            height: 0,
                            letterSpacing: -0.32,
                          )
                      ),
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _doHandleTabSelection() {
    if (_tabController.indexIsChanging) {
      _doCheckEnableButton();
    }
  }

  void _doCheckEnableButton() {
    if(_tabController.index == 0) {
      if (_nameController.text.isEmpty || _phoneController.text.isEmpty) {
        setState(() {
          _isButtonDisabled = true;
        });
      }else {
        setState(() {
          _isButtonDisabled = false;
        });
      }

    }else {
      if (_emailController.text.isEmpty) {
        setState(() {
          _isButtonDisabled = true;
        });
      } else if (!isEmailValid(_emailController.text)) {
        setState(() {
          _isButtonDisabled = true;
        });
      } else {
        setState(() {
          _isButtonDisabled = false;
        });
      }
    }
  }

  void _doSubmit(BuildContext context) {
    if(_tabController.index == 0) {
      _doFindId(context);
    }else {
      _doResetPassword(context);
    }
  }

  void _doFindId(BuildContext context) {
    if(_isLoading) return;

    if (_nameController.text.isEmpty) {
      showSnackBar(context, "당신의 이름을 입력 해주세요");
      return;
    }
    if (_phoneController.text.isEmpty) {
      showSnackBar(context, "비밀번호를 입력해주세요");
      return;
    }

    closeKeyboard(context);

    setState(() {
      _isLoading = true;
    });

    _authModule.resetPassword(
      email: _emailController.text,
      callback: (bool success, String message) async {

        if(success) {

          Navigator.of(context).pop();

          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const ScreenLogin();
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

  void _doResetPassword(BuildContext context) {

    if(_isLoading) return;

    if (_emailController.text.isEmpty) {
      showSnackBar(context, "이메일을 입력해주세요");
      return;
    }
    if (!isEmailValid(_emailController.text)) {
      showSnackBar(context, "유효한 이메일을 입력해주세요");
      return;
    }

    closeKeyboard(context);

    setState(() {
      _isLoading = true;
    });

    _authModule.resetPassword(
      email: _emailController.text,
      callback: (bool success, String message) async {

        if(success) {

          Navigator.of(context).pop();

          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const ScreenLogin();
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
