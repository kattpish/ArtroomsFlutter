
import '../data/module_datastore.dart';

class MyProfile {

  String profileImg = MyDataStore().getProfileImg();

  MyProfile({
    profileImg = ""
  });

  static MyProfile fromProfileMap(Map<String, dynamic> profileMap) {
    return MyProfile(
        profileImg: profileMap["profileImg"]["accessUrl"]
    );
  }

}
