
import '../main.dart';


class MyDataStore {

  bool isLoggedIn() {
    return getAccessToken().isNotEmpty;
  }

  String getAccessToken() {
    String? accessToken = sharedPreferences.getString("accessToken");
    return accessToken ?? "";
  }

  String getRefreshToken() {
    String? refreshToken = sharedPreferences.getString("refreshToken");
    return refreshToken ?? "";
  }

  Future<void> saveTokens(String? accessToken, String? refreshToken) async {
    await sharedPreferences.setString('accessToken', accessToken ?? '');
    await sharedPreferences.setString('refreshToken', refreshToken ?? '');
  }

  Future<void> logout() async {
    await sharedPreferences.setString('accessToken', "");
    await sharedPreferences.setString('refreshToken', "");
  }

}