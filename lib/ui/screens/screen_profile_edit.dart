import 'dart:io';

import 'package:artrooms/utils/utils.dart';
import 'package:artrooms/utils/utils_permissions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../beans/bean_profile.dart';
import '../../main.dart';
import '../../modules/module_profile.dart';
import '../theme/theme_colors.dart';
import '../widgets/widget_loader.dart';


class MyScreenProfileEdit extends StatefulWidget {

  const MyScreenProfileEdit({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MyScreenProfileEditState();
  }

}

class _MyScreenProfileEditState extends State<MyScreenProfileEdit> {

  bool _isLoading = true;
  bool _isSubmitting = false;
  bool _isUploading = false;
  bool _isPasswordVisible = false;
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _nicknameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final UserModule userModule = UserModule();
  MyProfile profile = MyProfile();

  XFile? fileImage;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

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
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 10.0),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: colorMainGrey250,
              size: 20,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        leadingWidth: 32,
        title: const Text(
          '프로필 수정',
          style: TextStyle(
            color: Color(0xFF1F1F1F),
            fontSize: 18,
            fontFamily: 'SUIT',
            fontWeight: FontWeight.w700,
            height: 0,
            letterSpacing: -0.36,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: colorMainScreen,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.transparent,
                      child: fileImage == null
                          ? FadeInImage.assetNetwork(
                        placeholder: 'assets/images/profile/placeholder.png',
                        image: profile.profileImg,
                        fit: BoxFit.cover,
                        width: 120,
                        height: 120,
                        fadeInDuration: const Duration(milliseconds: 100),
                        fadeOutDuration: const Duration(milliseconds: 100),
                        imageErrorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/images/profile/placeholder.png',
                            fit: BoxFit.cover,
                          );
                        },
                      )
                          : Image.file(
                        File(fileImage!.path),
                        height: 120,
                        width: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: () async {

                        requestPermissions(context);

                        final ImagePicker picker = ImagePicker();
                        XFile? xFileImage = await picker.pickImage(source: ImageSource.gallery);

                        setState(() {
                          fileImage = xFileImage;
                        });

                        if (fileImage != null) {
                          _doUploadProfile(context);
                          if (kDebugMode) {
                            print("Picked image path: ${fileImage?.path}");
                          }
                        }

                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(color: Color(0xFFD7D7D7), width: 1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: _isUploading
                          ? const SizedBox(
                        width: 20,
                        height: 20,
                            child: CircularProgressIndicator(
                        color: colorPrimaryPurple,
                        strokeWidth: 3,
                      ),
                          )
                          : const Text(
                        '프로필 바꾸기',
                        style: TextStyle(
                          color: Color(0xFF5F5F5F),
                          fontSize: 14,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildInputField(
                      label: '이름',
                      controller: _nameController,
                      focus: _nameFocus,
                      readOnly: false,
                      onSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_nicknameFocus);
                      }
                  ),
                  const SizedBox(height: 16),
                  _buildInputField(
                      label: '닉네임',
                      controller: _nicknameController,
                      focus: _nicknameFocus,
                      onSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_phoneFocus);
                      }
                  ),
                  const SizedBox(height: 16),
                  _buildInputField(
                      label: '이메일',
                      controller: _emailController,
                      focus: _emailFocus,
                      readOnly: true,
                      onSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_passwordFocus);
                      }
                  ),
                  const SizedBox(height: 16),
                  _buildPickerField(
                    label: '휴대전화',
                    controller: _phoneController,
                    focus: _phoneFocus,
                    readOnly: true,
                    onSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_passwordFocus);
                    },
                    onTap: () {

                    },
                  ),
                  const SizedBox(height: 16),
                  _buildPickerField(
                    label: '비밀번호',
                    controller: _passwordController,
                    focus: _passwordFocus,
                    readOnly: true,
                    isObscure: !_isPasswordVisible,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) {
                      _doUpdateProfile(context);
                    },
                    onTap: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                  const SizedBox(height: 56),
                  ElevatedButton(
                    onPressed: () {
                      _doUpdateProfile(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorPrimaryBlue,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Container(
                      height: 44,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
                      child:
                      _isSubmitting
                          ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Color(0xFFFFFFFF),
                          strokeWidth: 3,
                        ),
                      )
                          : const Text(
                          '저장',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontFamily: 'SUIT',
                            fontWeight: FontWeight.w700,
                            height: 0,
                            letterSpacing: -0.32,
                          )
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            Visibility(
                visible: _isLoading,
                child: const MyLoaderPage()
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    bool readOnly = false,
    bool isPassword = false,
    required FocusNode focus,
    textInputAction = TextInputAction.next,
    required void Function(String) onSubmitted,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF8F8F8F),
              fontSize: 14,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w600,
              height: 0,
              letterSpacing: -0.28,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            height: 48,
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: readOnly ? const Color(0xFFF5F5F5) : const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: const Color(0xFFE3E3E3), width: 1.0,),
            ),
            child: TextField(
              controller: controller,
              focusNode: focus,
              textInputAction: textInputAction,
              decoration: InputDecoration(
                border: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: readOnly ? const Color(0xFFF5F5F5) : const Color(0xFFFFFFFF),
              ),
              readOnly: readOnly,
              obscureText: isPassword,
              onSubmitted: onSubmitted,
              textAlign: TextAlign.start,
              style: const TextStyle(
                color: Color(0xFF1F1F1F),
                fontSize: 16,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w400,
                height: 1.0,
                letterSpacing: -0.32,
              ),
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
    bool readOnly = false,
    bool isObscure = false,
    textInputAction = TextInputAction.next,
    required void Function(String) onSubmitted,
    required FocusNode focus,
  }) {
    return Container(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF8F8F8F),
              fontSize: 14,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w600,
              height: 0,
              letterSpacing: -0.28,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            height: 48,
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: readOnly ? const Color(0xFFE3E3E3) : const Color(0xFFE3E3E3),
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: const Color(0xFFE3E3E3), width: 1.0,),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    focusNode: focus,
                    obscureText: isObscure,
                    textInputAction: textInputAction,
                    decoration: InputDecoration(
                      hintText: '',
                      filled: true,
                      fillColor: readOnly ? const Color(0xFFF5F5F5) : const Color(0xFFFFFFFF),
                      border: const UnderlineInputBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5.0),
                          bottomLeft: Radius.circular(5.0),
                        ),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    readOnly: readOnly,
                    onSubmitted: onSubmitted,
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      color: Color(0xFF1F1F1F),
                      fontSize: 16,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w400,
                      height: 0.9,
                      letterSpacing: -0.32,
                    ),
                  ),
                ),
                Visibility(
                  visible: !readOnly,
                  child: Container(
                    width: 78,
                    height: 48,
                    decoration: const BoxDecoration(
                      border: Border(
                        left: BorderSide(color: Color(0xFFE3E3E3), width: 1.0),
                      ),
                    ),
                    child: InkWell(
                      onTap: onTap,
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(8.0),
                        decoration: const BoxDecoration(
                          color: Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(5.0),
                            bottomRight: Radius.circular(5.0),
                          ),
                        ),
                        child: Text(
                          isObscure ? '변경' : '수정',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color(0xFF8F8F8F),
                            fontSize: 14,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w700,
                            height: 0,
                            letterSpacing: -0.28,
                          ),
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

  void _loadUserProfile() async {

    Map<String, dynamic>? profileMap = await userModule.getMyProfile();
    if (profileMap != null) {

      dbStore.saveProfile(profileMap);

      setState(() {
        profile = MyProfile.fromProfileMap(profileMap);
      });

      Map<String, dynamic> student = profileMap["student"];

      setState(() {
        _emailController.text = profileMap["email"];
        _nameController.text = student["name"];
        _nicknameController.text = student["nickname"];
        _phoneController.text = student["phoneNumber"];
        _passwordController.text = "**********";
      });

      setState(() {
        _isLoading = false;
      });

    } else {
      print("Failed to fetch user profile.");
    }
  }

  Future<void> _doUpdateProfile(BuildContext context) async {

    if(_isSubmitting) return;

    setState(() {
      _isSubmitting = true;
    });

    profile.name = _nameController.text;
    profile.nickName = _nicknameController.text;

    Map<String, dynamic>? resUpdateProfile = await userModule.updateProfile(
      userId: dbStore.getUserId(),
      name: _nameController.text,
      nickname: _nicknameController.text,
      acceptMarketing: false,
      certificationPhone: false,
    );

    if (resUpdateProfile != null) {

      setState(() {
        _isSubmitting = false;
      });

      dbStore.saveProfile(resUpdateProfile);

      showSnackBar(context, "귀하의 계정 업데이트가 완료되었습니다.");

    } else {
      showSnackBar(context, "프로필을 업데이트하지 못했습니다.");
    }

  }

  Future<void> _doUploadProfile(BuildContext context) async {

    if(_isUploading) return;

    if(fileImage != null) {

      setState(() {
        _isUploading = true;
      });

      Map<String, dynamic>? resUploadProfile = await userModule.uploadProfileImage(fileImage!);

      if (resUploadProfile != null) {

        setState(() {
          _isUploading = false;
        });

        showSnackBar(context, "프로필 사진이 업로드되었습니다.");

      } else {
        showSnackBar(context, "프로필 사진을 업로드하지 못했습니다..");
      }

    }

  }

}
