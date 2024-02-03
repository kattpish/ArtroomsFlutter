
import 'package:artrooms/ui/screens/screen_chats.dart';
import 'package:flutter/material.dart';

import '../theme/theme_colors.dart';


class MyScreenHome extends StatefulWidget {

  const MyScreenHome({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MyScreenHomeState();
  }

}

class _MyScreenHomeState extends State<MyScreenHome> with SingleTickerProviderStateMixin {

  late TabController _tabController;
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _isButtonDisabled = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
    _idController.addListener(_checkIfButtonShouldBeEnabled);
    _passwordController.addListener(_checkIfButtonShouldBeEnabled);
    _emailController.addListener(_checkIfButtonShouldBeEnabled);
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      _checkIfButtonShouldBeEnabled();
    }
  }

  void _checkIfButtonShouldBeEnabled() {
    if(_tabController.index == 0) {
      if (_idController.text.isNotEmpty || _passwordController.text.isNotEmpty) {
        setState(() => _isButtonDisabled = false);
      } else {
        setState(() => _isButtonDisabled = true);
      }

    }else {
      if (_emailController.text.isNotEmpty) {
        setState(() => _isButtonDisabled = false);
      } else {
        setState(() => _isButtonDisabled = true);
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _idController.dispose();
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
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text(
            '아이디 · 비밀번호 찾기',
            style: TextStyle(
                color: colorMainGrey900,
                fontWeight: FontWeight.w600
            ),
          ),
          centerTitle: true,
          elevation: 1,
          backgroundColor: Colors.white,
          bottom: TabBar(
            controller: _tabController,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: colorPrimaryPurple,
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
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildIdTab(),
            _buildPasswordTab(),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 40.0),
          child: ElevatedButton(
            onPressed: _submit,
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: _isButtonDisabled ? colorPrimaryPurple.withAlpha(100) : colorPrimaryPurple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              elevation: 0,
              textStyle: const TextStyle(fontSize: 18),
              fixedSize: const Size.fromHeight(60),
            ),
            child: const Text('인증메일 전송', style: TextStyle(color: Colors.white)),
          ),
        ),

      ),
    );
  }

  Widget _buildIdTab() {
    return Padding(
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
              controller: _idController,
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
    );
  }

  Widget _buildPasswordTab() {
    return Padding(
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
    );
  }

  void _submit() {

    if(_isButtonDisabled) {

    }

    Navigator.of(context).pop();
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return const MyScreenChats();
    }));

  }

}
