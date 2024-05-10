
import '../main.dart';


class MyProfile {

  String name = dbStore.getName();
  String nickName = dbStore.getNickName();
  String profileImg = dbStore.getProfileImg();

  MyProfile({
    name,
    nickName,
    profileImg,
  });

  static MyProfile fromProfileMap(Map<String, dynamic> profileMap) {
    dynamic profileImg = profileMap["profileImg"];
    return MyProfile(
        name: profileMap["name"],
        nickName: profileMap["nickName"],
        profileImg: profileImg != null ? profileMap["profileImg"] : "",
    );
  }

}
