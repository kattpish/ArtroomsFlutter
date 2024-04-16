import 'dart:async';
import 'dart:convert';
import 'package:artrooms/beans/bean_chatting_artist_profile.dart';
import 'package:artrooms/beans/bean_memo.dart';
import 'package:artrooms/data/module_datastore.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../api/api.dart';
import '../beans/bean_notice.dart';

class ModuleMemo{

  Future<Memo> getMemo({required int artistId}) async {
    Map<String, dynamic> body = {
      "operationName": "searchChattingMemo",
      "searchChattingMemo": {"artistId": artistId},
      "query": """
       query searchChattingMemo (\$url: Int!,\$userId: String!,\$adminId: String!){
    searchChattingMemo(artistId: \$url,artistId: \$userId,artistId: \$adminId) {
        ... on ChattingMemo {
            id
            memo
            url
        }
        ... on Error{
        status
        message
        }
    }
}
      """,
    };

    try {

      final response = await http.post(
        Uri.parse(apiUrlGraphQLTest),
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode(body),
      );

      final responseData = json.decode(response.body);

      if (kDebugMode) {
        print('response of profile $responseData');
      }
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return Memo.fromJson(responseData['data']['searchChattingMemo']);
      } else {
        if (kDebugMode) {
          print('Error updating profile picture: ${response.body}');
        }
        return Memo();
      }
    } catch (e) {
      print('error ${e}');
      return Memo();
    }
  }

  Future<Map<String, dynamic>?> updateProfilePicture({
    required int userId,
    required int profileImgId,
  }) async {
    DBStore dbStore = DBStore();

    const String mutation = '''
      mutation UpdateUser(\$id: Int, \$updateStudentInput: UpdateStudentInput, \$updateUserInput: UpdateUserInput) {
        updateUser(
          id: \$id
          updateUserInput: \$updateUserInput
          updateStudentInput: \$updateStudentInput
        ) {
          ... on User {
            id
            type
            email
            student {
              nickname
              name
              id
              phoneNumber
              acceptMarketing
              certificationPhone
              point {
                id
                point
                __typename
              }
              __typename
            }
            profileImgId
            profileImg {
              accessUrl
              __typename
            }
            socialImg
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
    ''';

    var response = await http.post(
      Uri.parse(apiUrlGraphQL),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': dbStore.getAccessToken(),
      },
      body: jsonEncode({
        'operationName': 'UpdateUser',
        'variables': {
          'id': userId,
          'updateUserInput': {
            'id': userId,
            'profileImgId': profileImgId,
          },
        },
        'query': mutation,
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      return data['data']['updateUserProfilePicture'] as Map<String, dynamic>?;
    } else {
      if (kDebugMode) {
        print('Error updating profile picture: ${response.body}');
      }
      return null;
    }
  }

  Future<Map<String, dynamic>?> updateProfileMemo({
    required int userId,
    required int profileImgId,
  }) async {
    DBStore dbStore = DBStore();

    const String mutation = '''
      mutation UpdateUser(\$id: Int, \$updateStudentInput: UpdateStudentInput, \$updateUserInput: UpdateUserInput) {
        updateUser(
          id: \$id
          updateUserInput: \$updateUserInput
          updateStudentInput: \$updateStudentInput
        ) {
          ... on User {
            id
            type
            email
            student {
              nickname
              name
              id
              phoneNumber
              acceptMarketing
              certificationPhone
              point {
                id
                point
                __typename
              }
              __typename
            }
            profileImgId
            profileImg {
              accessUrl
              __typename
            }
            socialImg
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
    ''';

    var response = await http.post(
      Uri.parse(apiUrlGraphQL),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': dbStore.getAccessToken(),
      },
      body: jsonEncode({
        'operationName': 'UpdateUser',
        'variables': {
          'id': userId,
          'updateUserInput': {
            'id': userId,
            'profileImgId': profileImgId,
          },
        },
        'query': mutation,
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      return data['data']['updateUserProfilePicture'] as Map<String, dynamic>?;
    } else {
      if (kDebugMode) {
        print('Error updating profile picture: ${response.body}');
      }
      return null;
    }
  }
}