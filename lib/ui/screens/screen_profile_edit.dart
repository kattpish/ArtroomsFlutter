
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
import '../widgets/widget_profile_inputs.dart';


class ScreenProfileEdit extends StatefulWidget {

  const ScreenProfileEdit({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ScreenProfileEditState();
  }

}

class _ScreenProfileEditState extends State<ScreenProfileEdit> {

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

  final UserModule _userModule = UserModule();
  MyProfile _profile = MyProfile();
  XFile? _fileImage;

  @override
  void initState() {
    super.initState();
    _doLoadUserProfile();
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
                      child: _fileImage == null
                          ? FadeInImage.assetNetwork(
                        placeholder: 'assets/images/profile/placeholder.png',
                        image: _profile.profileImg,
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
                        File(_fileImage!.path),
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
                          _fileImage = xFileImage;
                        });

                        if (_fileImage != null) {
                          _doUploadProfile(context);
                          if (kDebugMode) {
                            print("Picked image path: ${_fileImage?.path}");
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
                  buildInputField(
                      label: '이름',
                      controller: _nameController,
                      focus: _nameFocus,
                      readOnly: false,
                      onSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_nicknameFocus);
                      }
                  ),
                  const SizedBox(height: 16),
                  buildInputField(
                      label: '닉네임',
                      controller: _nicknameController,
                      focus: _nicknameFocus,
                      onSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_phoneFocus);
                      }
                  ),
                  const SizedBox(height: 16),
                  buildInputField(
                      label: '이메일',
                      controller: _emailController,
                      focus: _emailFocus,
                      readOnly: true,
                      onSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_passwordFocus);
                      }
                  ),
                  const SizedBox(height: 16),
                  buildPickerField(
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
                  buildPickerField(
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
                child: const WidgetLoaderPage()
            ),
          ],
        ),
      ),
    );
  }

  void _doLoadUserProfile() async {

    Map<String, dynamic>? profileMap = await _userModule.getMyProfile();
    if (profileMap != null) {

      dbStore.saveProfile(profileMap);

      setState(() {
        _profile = MyProfile.fromProfileMap(profileMap);
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

    _profile.name = _nameController.text;
    _profile.nickName = _nicknameController.text;

    Map<String, dynamic>? resUpdateProfile = await _userModule.updateProfile(
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

    if(_fileImage != null) {

      setState(() {
        _isUploading = true;
      });

      Map<String, dynamic>? resUploadProfile = await _userModule.uploadProfileImage(_fileImage!);

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
