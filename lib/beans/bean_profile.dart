
import '../data/module_datastore.dart';


class MyProfile {

  String name = DBStore().getName();
  String nickName = DBStore().getNickName();
  String profileImg = DBStore().getProfileImg();

  MyProfile({
    name,
    nickName,
    profileImg,
  });

  static MyProfile fromProfileMap(Map<String, dynamic> profileMap) {
    return MyProfile(
        name: profileMap["name"],
        nickName: profileMap["nickName"],
        profileImg: profileMap["profileImg"]["accessUrl"],
    );
  }

}
