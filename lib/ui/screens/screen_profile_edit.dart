import 'package:artrooms/utils/utils.dart';
import 'package:artrooms/utils/utils_permissions.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../beans/bean_profile.dart';
import '../../data/module_datastore.dart';
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

  UserModule userModule = UserModule();
  MyDataStore myDataStore = MyDataStore();

  MyProfile profile = MyProfile();

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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: colorMainGrey250),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          '프로필 수정',
          style: TextStyle(
              color: colorMainGrey900,
              fontWeight: FontWeight.w600
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: colorMainScreen,
      body: Stack(
        children: [
          SingleChildScrollView(
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
                    child: FadeInImage.assetNetwork(
                      placeholder: 'assets/images/profile/placeholder.png',
                      image: profile.profileImg,
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
                ),
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () async {

                      requestPermissions(context);

                      final ImagePicker _picker = ImagePicker();
                      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                      if (image != null) {
                        print("Picked image path: ${image.path}");
                        setState(() {
                          profile.profileImg = image.path;
                        });
                      }

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
                    focus: _nameFocus,
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
                      FocusScope.of(context).requestFocus(_emailFocus);
                    }
                ),
                const SizedBox(height: 16),
                _buildInputField(
                    label: '이메일',
                    controller: _emailController,
                    focus: _emailFocus,
                    onSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_passwordFocus);
                    }
                ),
                const SizedBox(height: 16),
                _buildPickerField(
                  label: '전화번호',
                  controller: _phoneController,
                  focus: _phoneFocus,
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
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: () {
                    _doUpdateProfile(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorPrimaryBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
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
                        : const Text('저장'),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
          Visibility(
              visible: _isLoading,
              child: const MyLoaderPage()
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    bool isPassword = false,
    required FocusNode focus,
    textInputAction = TextInputAction.next,
    required void Function(String) onSubmitted,
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
              focusNode: focus,
              textInputAction: textInputAction,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              obscureText: isPassword,
              onSubmitted: onSubmitted,
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
    textInputAction = TextInputAction.next,
    required void Function(String) onSubmitted,
    required FocusNode focus,
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
                    focusNode: focus,
                    obscureText: isObscure,
                    textInputAction: textInputAction,
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
                    onSubmitted: onSubmitted,
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

  void _loadUserProfile() async {

    Map<String, dynamic>? profileMap = await userModule.getMyProfile();
    if (profileMap != null) {
      print("User Profile: $profileMap");

      myDataStore.saveProfile(profileMap);

      setState(() {
        profile = MyProfile.fromProfileMap(profileMap);
      });

      Map<String, dynamic> student = profileMap["student"];

      setState(() {
        _emailController.text = profileMap["email"];
        _nameController.text = student["name"];
        _nicknameController.text = student["nickname"];
        _phoneController.text = student["phoneNumber"];
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

    Map<String, dynamic>? resUpdateProfile = await userModule.updateProfile(
      userId: 1,
      name: _nameController.text,
      nickname: _nicknameController.text,
      acceptMarketing: false,
      certificationPhone: false,
    );

    if (resUpdateProfile != null) {

      setState(() {
        _isSubmitting = false;
      });

      showSnackBar(context, "귀하의 계정 업데이트가 완료되었습니다.");

    } else {
      showSnackBar(context, "프로필을 업데이트하지 못했습니다.");
    }

  }

}
