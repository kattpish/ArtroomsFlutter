import 'package:flutter/material.dart';
import '../theme/theme_colors.dart';


class MyScreenProfileEdit extends StatefulWidget {

  const MyScreenProfileEdit({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MyScreenProfileEditState();
  }

}

class _MyScreenProfileEditState extends State<MyScreenProfileEdit> {

  bool _isPasswordVisible = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _nicknameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: colorMainGrey250),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          '프로필 수정',
          style: TextStyle(
              color: Colors.black
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: colorMainScreen,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CircleAvatar(
              radius: 60,
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
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.center,
              child: TextButton(
                onPressed: () {

                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('프로필 바꾸기'),
              ),
            ),
            const SizedBox(height: 32),
            _buildInputField(
              label: '이름',
              controller: _nameController,
            ),
            const SizedBox(height: 16),
            _buildInputField(
              label: '닉네임',
              controller: _nicknameController,
            ),
            const SizedBox(height: 16),
            _buildInputField(
              label: '이메일',
              controller: _emailController,
            ),
            const SizedBox(height: 16),
            _buildInputField(
              label: '비밀번호',
              controller: _passwordController,
              isPassword: true,
            ),
            const SizedBox(height: 16),
            _buildPickerField(
              label: '전화번호',
              controller: _phoneController,
              onTap: () {

              },
            ),
            const SizedBox(height: 16),
            _buildPickerField(
              label: '비밀번호',
              controller: _passwordController,
              isObscure: !_isPasswordVisible,
              onTap: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {

              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colorPrimaryPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                child: Text('저장'),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    bool isPassword = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          const SizedBox(height: 4),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: const Color(0xFFE3E3E3), width: 1.0,),
            ),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              obscureText: isPassword,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPickerField({
    required String label,
    required VoidCallback onTap,
    required TextEditingController controller,
    bool isObscure = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          const SizedBox(height: 4),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: const Color(0xFFE3E3E3), width: 1.0,),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    obscureText: isObscure,
                    decoration: const InputDecoration(
                      hintText: '',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8.0),
                          topRight: Radius.circular(0.0),
                          bottomLeft: Radius.circular(8.0),
                          bottomRight: Radius.circular(0.0),
                        ),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                    ),
                  ),
                ),
                SizedBox(
                  width: 80,
                  child: InkWell(
                    onTap: onTap,
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                          isObscure ? '비밀번호' : '선택',
                        textAlign: TextAlign.center,
                        style: const TextStyle(

                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
