import 'dart:convert';
import 'package:http/http.dart' as http;


class AuthModule {

  Future<void> login({
    required String email,
    required String password,
    required bool loginRemember,
    required Function(bool success, String? accessToken, String? refreshToken) callback,
  }) async {

    const String url = 'https://artrooms-api-elasticbeanstalk.com/graphql';

    Map<String, Object> body = {
      "operationName": "Login",
      "variables": {
        "loginUserInput": {
          "email": email,
          "password": password,
          "loginRemember": loginRemember,
        },
      },
      "query": "mutation Login(\$loginUserInput: LoginUserInput) { login(loginUserInput: \$loginUserInput) { ... on Tokens { accessToken refreshToken __typename } __typename } }",
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    print("${response.statusCode} ${response.body}\n${jsonEncode(body)}");

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      if (responseBody != null && responseBody['data'] != null && responseBody['data']['login'] != null) {
        final tokens = responseBody['data']['login'];
        if (tokens['__typename'] == 'Tokens') {
          callback(true, tokens['accessToken'], tokens['refreshToken']);
          return;
        }
      }
    }

    callback(false, null, null);
  }

}
