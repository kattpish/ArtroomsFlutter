
import 'package:flutter/material.dart';

import '../../modules/module_auth.dart';
import '../../utils/utils.dart';
import '../theme/theme_colors.dart';


class MyScreenLoginReset extends StatefulWidget {

  final int tab;

  const MyScreenLoginReset({super.key, required this.tab});

  @override
  State<StatefulWidget> createState() {
    return _MyScreenLoginResetState();
  }

}

class _MyScreenLoginResetState extends State<MyScreenLoginReset> with SingleTickerProviderStateMixin {

  bool _isLoading = false;
  late TabController _tabController;
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final TextEditingController _nameController =  TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool _isButtonDisabled = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
    _nameController.addListener(_checkIfButtonShouldBeEnabled);
    _phoneController.addListener(_checkIfButtonShouldBeEnabled);
    _emailController.addListener(_checkIfButtonShouldBeEnabled);

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
          elevation: 0.5,
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
                        _buildIdTab(),
                        _buildPasswordTab(),
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
                        _submit(context);
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

  Widget _buildIdTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Text(
                '아이디 찾기',
                style: TextStyle(
                  color: Color(0xFF1F1F1F),
                  fontSize: 16,
                  fontFamily: 'SUIT',
                  fontWeight: FontWeight.w700,
                  height: 0,
                  letterSpacing: -0.32,
                )
            ),
            const SizedBox(height: 10),
            const Text(
              '가입 시 등록했던 이메일 주소를 입력해 주세요.\n비밀번호를 재설정할 수 있는 링크를 보내드립니다.',
              style: TextStyle(
                color: Color(0xFF1F1F1F),
                fontSize: 14,
                fontFamily: 'SUIT',
                fontWeight: FontWeight.w400,
                height: 0,
                letterSpacing: -0.28,
              ),
            ),
            const SizedBox(height: 30),
            const Text(
                '이름',
                style: TextStyle(
                  color: Color(0xFF979797),
                  fontSize: 16,
                  fontFamily: 'SUIT',
                  fontWeight: FontWeight.w600,
                  height: 0,
                  letterSpacing: -0.32,
                )
            ),
            const SizedBox(height: 6),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: const Color(0xFFE7E7E7), width: 1.0,),
              ),
              child: TextField(
                controller: _nameController,
                focusNode: _nameFocus,
                autofocus: false,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                onSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_phoneFocus);
                },
                decoration: InputDecoration(
                  hintText: '실명을 입력해주세요',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(
                  fontSize: 16,
                  fontFamily: 'SUIT',
                  fontWeight: FontWeight.w400,
                  height: 0,
                  letterSpacing: -0.32,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
                '핸드폰 번호',
                style: TextStyle(
                  color: Color(0xFF979797),
                  fontSize: 16,
                  fontFamily: 'SUIT',
                  fontWeight: FontWeight.w600,
                  height: 0,
                  letterSpacing: -0.32,
                )
            ),
            const SizedBox(height: 6),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: const Color(0xFFE7E7E7), width: 1.0,),
              ),
              child: TextField(
                controller: _phoneController,
                focusNode: _phoneFocus,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) {
                  _submit(context);
                },
                decoration: InputDecoration(
                  hintText: '휴대폰 번호를 입력해주세요',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(
                  fontSize: 16,
                  fontFamily: 'SUIT',
                  fontWeight: FontWeight.w400,
                  height: 0,
                  letterSpacing: -0.32,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Text(
                '비밀번호 찾기',
                style: TextStyle(
                  color: Color(0xFF1F1F1F),
                  fontSize: 16,
                  fontFamily: 'SUIT',
                  fontWeight: FontWeight.w700,
                  height: 0,
                  letterSpacing: -0.32,
                )
            ),
            const SizedBox(height: 10),
            const Text(
              '가입 시 등록했던 이메일 주소를 입력해 주세요.',
              style: TextStyle(
                color: Color(0xFF1F1F1F),
                fontSize: 14,
                fontFamily: 'SUIT',
                fontWeight: FontWeight.w400,
                height: 0,
                letterSpacing: -0.28,
              ),
            ),
            const SizedBox(height: 30),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: const Color(0xFFE7E7E7), width: 1.0,),
              ),
              child: TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) {
                  _submit(context);
                },
                decoration: InputDecoration(
                  hintText: '이메일 주소를 입력하세요',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(
                  fontSize: 16,
                  fontFamily: 'SUIT',
                  fontWeight: FontWeight.w400,
                  height: 0,
                  letterSpacing: -0.32,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      _checkIfButtonShouldBeEnabled();
    }
  }

  void _checkIfButtonShouldBeEnabled() {
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

  void _submit(BuildContext context) {

    if(_tabController.index == 0) {
      _attemptFindId(context);
    }else {
      _attemptResetPassword(context);
    }

  }

  void _attemptFindId(BuildContext context) {

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

    AuthModule authModule = AuthModule();
    authModule.resetPassword(
      email: _emailController.text,
      callback: (bool success, String message) async {

        if(success) {
          Navigator.of(context).pop();
        } else {
          showSnackBar(context, "로그인 실패");
        }

        setState(() {
          _isLoading = false;
        });

      },
    );

  }

  void _attemptResetPassword(BuildContext context) {

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

    AuthModule authModule = AuthModule();
    authModule.resetPassword(
      email: _emailController.text,
      callback: (bool success, String message) async {

        if(success) {
          Navigator.of(context).pop();
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
