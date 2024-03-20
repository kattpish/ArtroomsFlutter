
import 'package:artrooms/ui/screens/screen_login.dart';
import 'package:artrooms/ui/screens/screen_notifications_sounds.dart';
import 'package:artrooms/ui/screens/screen_profile_edit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../beans/bean_profile.dart';
import '../../data/module_datastore.dart';
import '../../modules/module_profile.dart';
import '../../utils/utils.dart';
import '../theme/theme_colors.dart';


class MyScreenProfile extends StatefulWidget {

  const MyScreenProfile({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MyScreenProfileState();
  }

}

class _MyScreenProfileState extends State<MyScreenProfile> {

  UserModule userModule = UserModule();
  DBStore dbStore = DBStore();

  MyProfile profile = MyProfile();
  String name = "";
  String nickName = "";

  @override
  void initState() {
    super.initState();

    name = profile.name;
    nickName = profile.nickName;
    fetchUserProfile();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '설정',
          style: TextStyle(
            color: colorMainGrey900,
            fontSize: 18,
            fontFamily: 'SUIT',
            fontWeight: FontWeight.w700,
            height: 0,
            letterSpacing: -0.36,
          ),
        ),
        toolbarHeight: 60,
        leadingWidth: 0,
        actions: [
          Container(
            width: 24,
            height: 24,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: const BoxDecoration(
              color: colorMainGrey200,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(
                Icons.close,
                size: 16,
                color: Colors.white,
              ),
              padding: const EdgeInsets.all(4),
              constraints: const BoxConstraints(),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          )
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Row(
              children: [
                const SizedBox(width: 12),
                Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.transparent,
                    child: FadeInImage.assetNetwork(
                      placeholder: 'assets/images/profile/placeholder.png',
                      image: profile.profileImg,
                      fit: BoxFit.cover,
                      height: 64,
                      width: 64,
                      fadeInDuration: const Duration(milliseconds: 100),
                      fadeOutDuration: const Duration(milliseconds: 100),
                      imageErrorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/images/profile/placeholder.png',
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: Color(0xFF111111),
                        fontSize: 20,
                        fontFamily: 'SUIT',
                        fontWeight: FontWeight.w800,
                        height: 0,
                        letterSpacing: -0.40,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      nickName,
                      style: const TextStyle(
                        color: Color(0xFF565656),
                        fontSize: 14,
                        fontFamily: 'SUIT',
                        fontWeight: FontWeight.w600,
                        height: 0,
                        letterSpacing: -0.28,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  minimumSize: const Size(double.infinity, 48),
                  backgroundColor: colorMainGrey150,
                  foregroundColor: colorMainGrey700,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  '프로필 수정',
                  style: TextStyle(
                    color: Color(0xFF565656),
                    fontSize: 14,
                    fontFamily: 'SUIT',
                    fontWeight: FontWeight.w400,
                    height: 0,
                    letterSpacing: -0.28,
                  ),
                ),
                onPressed: () async {
                  await Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const MyScreenProfileEdit();
                  }));
                  fetchUserProfile();
                },
              ),
            ),
            const SizedBox(height: 28),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ListTile(
                title: const Text(
                  '알림 및 소리',
                  style: TextStyle(
                    color: Color(0xFF1F1F1F),
                    fontSize: 16,
                    fontFamily: 'SUIT',
                    fontWeight: FontWeight.w500,
                    height: 0,
                    letterSpacing: -0.32,
                  ),
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const MyScreenNotificationsSounds();
                  }));
                },
              ),
            ),
            const Divider(
              thickness: 1,
              color: colorMainGrey150,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ListTile(
                title: const Text(
                  '지원하기',
                  style: TextStyle(
                    color: Color(0xFF1F1F1F),
                    fontSize: 16,
                    fontFamily: 'SUIT',
                    fontWeight: FontWeight.w500,
                    height: 0,
                    letterSpacing: -0.32,
                  ),
                ),
                onTap: () {
                  launchInBrowser(Uri(scheme: 'mailto', path: 'artrooms@artrooms.com', queryParameters: {
                    'subject': '아트룸즈] 아티스트 지원',
                    'body': '이름:\n작가명(한글):\n작가명(영문):\n휴대전화번호:\n레퍼런스 링크:',
                  },));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ListTile(
                title: const Text(
                  '고객센터',
                  style: TextStyle(
                    color: Color(0xFF1F1F1F),
                    fontSize: 16,
                    fontFamily: 'SUIT',
                    fontWeight: FontWeight.w500,
                    height: 0,
                    letterSpacing: -0.32,
                  ),
                ),
                onTap: () {
                  launchInBrowser(Uri(scheme: 'https', host: 'artrooms.com', path: 'about'));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ListTile(
                title: const Text(
                  '약관 및 정책',
                  style: TextStyle(
                    color: Color(0xFF1F1F1F),
                    fontSize: 16,
                    fontFamily: 'SUIT',
                    fontWeight: FontWeight.w500,
                    height: 0,
                    letterSpacing: -0.32,
                  ),
                ),
                onTap: () {
                  launchInBrowser(Uri(scheme: 'https', host: 'artrooms.com', path: 'policy/service'));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ListTile(
                title: const Text(
                  '버전정보',
                  style: TextStyle(
                    color: Color(0xFF1F1F1F),
                    fontSize: 16,
                    fontFamily: 'SUIT',
                    fontWeight: FontWeight.w500,
                    height: 0,
                    letterSpacing: -0.32,
                  ),
                ),
                onTap: () {

                },
                trailing: const Text(
                  'v.24.01.01',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6A79FF),
                    fontFamily: 'SUIT',
                    fontWeight: FontWeight.w600,
                    height: 0,
                    letterSpacing: -0.28,
                  ),
                ),
              ),
            ),
            const Divider(
              thickness: 1,
              color: colorMainGrey150,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ListTile(
                  title: const Text(
                    '로그아웃',
                    style: TextStyle(
                      color: Color(0xFF1F1F1F),
                      fontSize: 16,
                      fontFamily: 'SUIT',
                      fontWeight: FontWeight.w500,
                      height: 0,
                      letterSpacing: -0.32,
                    ),
                  ),
                  onTap: () {
                    DBStore().logout();
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
                      return const MyScreenLogin();
                    }));
                  }
              ),
            ),
            const Divider(
              thickness: 1,
              color: colorMainGrey150,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void fetchUserProfile() async {

    setState(() {
      profile = MyProfile();
      name = profile.name;
      nickName = profile.nickName;
    });

    Map<String, dynamic>? profileMap = await userModule.getMyProfile();
    if (profileMap != null) {
      dbStore.saveProfile(profileMap);

      setState(() {
        profile = MyProfile.fromProfileMap(profileMap);
        name = profile.name;
        nickName = profile.nickName;
      });

      if (kDebugMode) {
        print("User Profile: $profileMap");
      }
    } else {
      if (kDebugMode) {
        print("Failed to fetch user profile.");
      }
    }

  }

}
