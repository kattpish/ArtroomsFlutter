
import 'package:artrooms/ui/screens/screen_login.dart';
import 'package:artrooms/ui/screens/screen_notifications_sounds.dart';
import 'package:artrooms/ui/screens/screen_profile_edit.dart';
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
  MyDataStore myDataStore = MyDataStore();

  MyProfile profile = MyProfile();

  @override
  void initState() {
    super.initState();

    fetchUserProfile();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '설정',
          style: TextStyle(
              color: colorMainGrey900,
              fontWeight: FontWeight.w600
          ),
        ),
        leadingWidth: 0,
        actions: [
          Container(
            width: 30,
            height: 30,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: const BoxDecoration(
              color: colorMainGrey200,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(
                Icons.close,
                size: 20,
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
                    radius: 40,
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
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      myDataStore.getNickName(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      myDataStore.getEmail(),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: TextButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  backgroundColor: colorMainGrey150,
                  foregroundColor: colorMainGrey700,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: const Text(
                  '프로필 수정',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const MyScreenProfileEdit();
                  }));
                },
              ),
            ),
            ListTile(
              title: const Text('지원하기'),
              onTap: () {
                launchInBrowser(Uri(scheme: 'mailto', path: 'artrooms@artrooms.com', queryParameters: {
                  'subject': '아트룸즈] 아티스트 지원',
                  'body': '이름:\n작가명(한글):\n작가명(영문):\n휴대전화번호:\n레퍼런스 링크:',
                },));
              },
            ),
            const Divider(
              thickness: 2,
              color: colorMainGrey150,
            ),
            ListTile(
              title: const Text('알림 및 소리'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const MyScreenNotificationsSounds();
                }));
              },
            ),
            ListTile(
              title: const Text('고객센터'),
              onTap: () {
                launchInBrowser(Uri(scheme: 'https', host: 'artrooms.com', path: 'about'));
              },
            ),
            ListTile(
              title: const Text('약관 및 정책'),
              onTap: () {
                launchInBrowser(Uri(scheme: 'https', host: 'artrooms.com', path: 'policy/service'));
              },
            ),
            ListTile(
              title: const Text('버전정보'),
              onTap: () {

              },
              trailing: const Text(
                'v.24.01.01',
                style: TextStyle(
                  color: colorPrimaryBlue400,
                  fontSize: 14,
                ),
              ),
            ),
            const Divider(
              thickness: 2,
              color: colorMainGrey150,
            ),
            ListTile(
                title: const Text('로그아웃'),
                onTap: () {
                  MyDataStore().logout();
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
                    return const MyScreenLogin();
                  }));
                }
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void fetchUserProfile() async {

    Map<String, dynamic>? profileMap = await userModule.getMyProfile();
    if (profileMap != null) {
      myDataStore.saveProfile(profileMap);

      setState(() {
        profile = MyProfile.fromProfileMap(profileMap);
      });

      print("User Profile: $profileMap");
    } else {
      print("Failed to fetch user profile.");
    }
  }

}
