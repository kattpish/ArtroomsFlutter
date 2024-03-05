
import 'package:artrooms/beans/bean_chat.dart';

import '../main.dart';


class MyDataStore {

  String getString(String key, {String defaultValue = ""}) {
    String? string = sharedPreferences.getString(key);
    return string ?? defaultValue;
  }

  bool getBool(String key, bool defaultValue) {
    bool? boolValue = sharedPreferences.getBool(key);
    return boolValue ?? defaultValue;
  }

  void setString(String key, String value) {
    sharedPreferences.setString(key, value);
  }

  void setBool(String key, bool value) {
    sharedPreferences.setBool(key, value);
  }

  bool isLoggedIn() {
    return getAccessToken().isNotEmpty;
  }

  String getUid() {
    String? uid = sharedPreferences.getString("email");
    return uid ?? "";
  }

  String getEmail() {
    String? email = sharedPreferences.getString("email");
    return email ?? "";
  }

  String getName() {
    String? name = sharedPreferences.getString("name");
    return name ?? "";
  }

  String getNickName() {
    String? nickname = sharedPreferences.getString("nickname");
    return nickname ?? "";
  }

  String getProfileImg() {
    String? profileImg = sharedPreferences.getString("profileImg");
    return profileImg ?? "";
  }

  String getAccessToken() {
    String? accessToken = sharedPreferences.getString("accessToken");
    return accessToken ?? "";
  }

  String getRefreshToken() {
    String? refreshToken = sharedPreferences.getString("refreshToken");
    return refreshToken ?? "";
  }

  Future<void> saveTokens(String email, String? accessToken, String? refreshToken) async {
    await sharedPreferences.setString('email', email);
    await sharedPreferences.setString('accessToken', accessToken ?? '');
    await sharedPreferences.setString('refreshToken', refreshToken ?? '');
  }

  Future<void> saveProfile(Map<String, dynamic> profile) async {

    Map<String, dynamic> student = profile["student"];

    await sharedPreferences.setString('name', student["name"] ?? "");
    await sharedPreferences.setString('nickname', student["nickname"] ?? "");
    await sharedPreferences.setString('phoneNumber', student["phoneNumber"] ?? "");
    await sharedPreferences.setString('profileImg', profile["profileImg"]["accessUrl"] ?? "");
  }

  Future<void> saveProfilePicture(Map<String, dynamic> profileImg) async {
    await sharedPreferences.setString('profileImg', profileImg["accessUrl"] ?? "");
  }

  String getMemo(MyChat myChat) {
    return getString(myChat.id);
  }

  void saveMemo(MyChat myChat, String memo) {
    setString(myChat.id, memo);
  }

  Future<void> logout() async {
    await sharedPreferences.setString('accessToken', "");
    await sharedPreferences.setString('refreshToken', "");
  }

}