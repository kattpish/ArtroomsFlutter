import 'dart:async';
import 'dart:convert';
import 'package:artrooms/beans/bean_memo.dart';
import 'package:artrooms/main.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../api/api.dart';


class ModuleMemo {

  Future<DataMemo?> getMemo({required String url}) async {
    int id = dbStore.getUserId();
    Map<String, dynamic> body = {
      "operationName": "searchChattingMemo",
      "variables": {
        "url": url,
        "userId": id
      },
      "query": """
       query searchChattingMemo (\$url: String!,\$userId: Int,\$adminId: Int){
          searchChattingMemo(url: \$url,userId: \$userId,adminId: \$adminId) {
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
        Uri.parse(apiUrlGraphQL),
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode(body),
      );

      final responseData = json.decode(response.body);

      if (kDebugMode) {
        print('response of profile Memo $responseData');
      }
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (kDebugMode) {
          print('Get Memo: ${responseData}');
        }
        return DataMemo.fromJson(responseData['data']['searchChattingMemo']);
      } else {
        if (kDebugMode) {
          print('Error getting Memo: ${response.body}');
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('error ${e}');
      }
      return null;
    }
  }

  Future<bool> updateProfileMemo({
    required DataMemo dataMemo,
    required String memo
  }) async {

    const String mutation = '''
      mutation updateChattingMemo(\$updateChattingMemoId: Int, \$updateChattingMemoInput: UpdateChattingMemoInput) {
        updateChattingMemo(
          id: \$updateChattingMemoId
          updateChattingMemoInput: \$updateChattingMemoInput
        ) {
          ... on ChattingMemo {
                id  
                memo      
                url      
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

    try{
      var response = await http.post(
        Uri.parse(apiUrlGraphQL),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': dbStore.getAccessToken(),
        },
        body: jsonEncode({
          'operationName': 'updateChattingMemo',
          'variables': {
            "updateChattingMemoId": dataMemo.id,
            "updateChattingMemoInput": {
              "memo": memo,
              "url": dataMemo.url,
              "userId": dbStore.getUserId()
            }
          },
          'query': mutation,
        }),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        return true;
      } else {
        if (kDebugMode) {
          print('Error updating profile memo: ${response.body}');
        }
      }

    }catch(e){
      if (kDebugMode) {
        print('Error updating Memo: $e');
      }
    }

    return false;
  }

}