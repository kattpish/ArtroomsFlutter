
import 'package:artrooms/ui/screens/screen_chats.dart';
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
  final FocusNode _passwordFocus = FocusNode();
  final TextEditingController _nameController =  TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isButtonDisabled = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
    _nameController.addListener(_checkIfButtonShouldBeEnabled);
    _passwordController.addListener(_checkIfButtonShouldBeEnabled);
    _emailController.addListener(_checkIfButtonShouldBeEnabled);

    _tabController.index = widget.tab;
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameFocus.dispose();
    _passwordFocus.dispose();
    _nameController.dispose();
    _passwordController.dispose();
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
            icon: const Icon(Icons.arrow_back_ios, color: colorMainGrey250),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: const Text(
            '아이디 · 비밀번호 찾기',
            style: TextStyle(
                color: colorMainGrey900,
                fontWeight: FontWeight.w600
            ),
          ),
          centerTitle: true,
          elevation: 0.5,
          backgroundColor: Colors.white,
          bottom: TabBar(
            controller: _tabController,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: colorPrimaryBlue,
            indicatorWeight: 2.0,
            tabs: const [
              Tab(
                  text: '아이디'
              ),
              Tab(
                  text: '비밀번호'
              ),
            ],
          ),
        ),
        body: Builder(
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
                  padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 40.0),
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
                        style: TextStyle(color: Colors.white)
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildIdTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Text('아이디 찾기', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('가입 시 등록했던 이메일 주소를 입력해 주세요.\n비밀번호를 재설정할 수 있는 링크를 보내드립니다.'),
            const SizedBox(height: 24),
            const Text('이름', style: TextStyle(fontSize: 16.0, color: Colors.black)),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: const Color(0xFFE3E3E3), width: 1.0,),
              ),
              child: TextField(
                controller: _nameController,
                focusNode: _nameFocus,
                autofocus: false,
                textInputAction: TextInputAction.next,
                onSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_passwordFocus);
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
              ),
            ),
            const SizedBox(height: 24),
            const Text('핸드폰 번호', style: TextStyle(fontSize: 16.0, color: Colors.black)),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: const Color(0xFFE3E3E3), width: 1.0,),
              ),
              child: TextField(
                controller: _passwordController,
                focusNode: _passwordFocus,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) {
                  _submit(context);
                },
                decoration: InputDecoration(
                  hintText: '휴대폰 번호를 입력해주세요',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none,
                  ),
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Text('비밀번호 찾기', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('가입 시 등록했던 이메일 주소를 입력해 주세요.'),
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: const Color(0xFFE3E3E3), width: 1.0,),
              ),
              child: TextField(
                controller: _emailController,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) {
                  _submit(context);
                },
                decoration: InputDecoration(
                  hintText: '이메일 주소를 입력하세요',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none,
                  ),
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
      if (_nameController.text.isEmpty || _passwordController.text.isEmpty) {
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
    if (_passwordController.text.isEmpty) {
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
