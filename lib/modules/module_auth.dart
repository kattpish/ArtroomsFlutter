import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../api/api.dart';

class ModuleAuth {
  Future<void> login({
    required String email,
    required String password,
    required bool loginRemember,
    required Function(bool success, String? accessToken, String? refreshToken)
    callback,
  }) async {
    Map<String, Object> body = {
      "operationName": "Login",
      "variables": {
        "loginUserInput": {
          "email": email,
          "password": password,
          "loginRemember": loginRemember,
        },
      },
      "query":
      "mutation Login(\$loginUserInput: LoginUserInput) { login(loginUserInput: \$loginUserInput) { ... on Tokens { accessToken refreshToken __typename } __typename } }",
    };

    final response = await http.post(
      Uri.parse(apiUrlGraphQL),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      if (responseBody != null &&
          responseBody['data'] != null &&
          responseBody['data']['login'] != null) {
        final tokens = responseBody['data']['login'];
        if (tokens['__typename'] == 'Tokens') {
          callback(true, tokens['accessToken'], tokens['refreshToken']);
          return;
        }
      }
    }

    callback(false, null, null);
  }

  Future<void> resetPassword({required String email, required Function(bool success, String message) callback}) async {
    Map<String, dynamic> body = {
      "operationName": "SendEmailForPassword",
      "variables": {
        "email": email,
      },
      "query": """
        mutation SendEmailForPassword(\$email: String!) {
          sendEmailForPassword(email: \$email) {
            ... on Student {
              id
              nickname
              name
              phoneNumber
              acceptMarketing
              certificationPhone
              user {
                id
                type
                profileImgId
                profileImg {
                  accessUrl
                  id
                  __typename
                }
                socialImg
                email
                __typename
              }
              __typename
            }
            ... on Error {
              status
              message
              __typename
            }
            __typename
          }
        }
      """,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrlGraphQL),
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode(body),
      );

      final responseData = json.decode(response.body);
      if (response.statusCode == 200 &&
          responseData['data']['sendEmailForPassword'] != null &&
          responseData['data']['sendEmailForPassword']['__typename'] == "Error") {
        callback(
            false, responseData['data']['sendEmailForPassword']['message']);
      } else {
        callback(true, "이메일로 비밀번호 재설정 링크가 전송되었습니다.");
      }
    } catch (e) {
      callback(false, "네트워크 오류가 발생했습니다. 다시 시도해주세요.");
    }
  }

  Future<void> getUserId({required String name,
    required String phoneNumber,
    required Function(bool success, String message) callback}) async {
    Map<String, dynamic> body = {
      "operationName": "getUserByNameAndPhoneNumber",
      "variables": {"name": name, "phoneNumber": phoneNumber},
      "query": """
        query getUserByNameAndPhoneNumber(\$name: String, \$phoneNumber: String) {
  getUserByNameAndPhoneNumber(name: \$name, phoneNumber: \$phoneNumber)
}
      """,
    };

    try {

      final response = await http.post(
        Uri.parse(apiUrlGraphQL),
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode(body),
      );

      final responseData = json.decode(response.body);

      if (kDebugMode) {
        print(responseData);
      }

      if (response.statusCode != 200) {
        callback(false, "네트워크 오류가 발생했습니다. 다시 시도해주세요.");
      } else {

        if (responseData['errors'] != null) {
          final String errorMessage = responseData['errors'][0]['message'];
          callback(false, errorMessage);
          return;
        }

        callback(true, "${responseData["data"]["getUserByNameAndPhoneNumber"]}");
      }

    } catch (e) {
      callback(false, "네트워크 오류가 발생했습니다. 다시 시도해주세요.");
    }
  }

}
