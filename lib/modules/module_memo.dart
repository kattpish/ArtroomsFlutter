import 'dart:async';
import 'dart:convert';
import 'package:artrooms/beans/bean_chatting_artist_profile.dart';
import 'package:artrooms/beans/bean_memo.dart';
import 'package:artrooms/data/module_datastore.dart';
import 'package:artrooms/main.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../api/api.dart';
import '../beans/bean_notice.dart';

class ModuleMemo{

  Future<Memo> getMemo({required String url}) async {
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
          print('Error updating Memo: ${response.body}');
        }
        return Memo();
      }
    } catch (e) {
      print('error ${e}');
      return Memo();
    }
  }

  Future<Memo?> updateProfileMemo({
    required int chattingMemoId,
    required String url,
    required String memo,
    required int userId,
  }) async {
    DBStore dbStore = DBStore();

    const String mutation = '''
      mutation updateChattingMemo(\$updateChattingMemoId: Int, \$updateChattingMemoInput: UpdateChattingMemoInput) {
        updateChattingMemo(
          id: \$updateChattingMemoId
          updateUserInput: \$updateUserInput
          updateStudentInput: \$updateStudentInput
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
       Uri.parse(apiUrlGraphQLTest),
       headers: {
         'Content-Type': 'application/json',
         'Authorization': dbStore.getAccessToken(),
       },
       body: jsonEncode({
         'operationName': 'UpdateChattingMemo',
         'variables': {
           "updateChattingMemoId": chattingMemoId,
           "updateChattingMemoInput": {
             "memo": memo,
             "url": url,
             "userId": userId
           },
           'query': mutation,
         }}),
     );
     if (response.statusCode == 200) {
       Map<String, dynamic> responseData = jsonDecode(response.body);
       return Memo.fromJson(responseData['data']['updateChattingMemo']);
     } else {
       if (kDebugMode) {
         print('Error updating profile picture: ${response.body}');
       }
       return Memo();
     }
   }catch(e){
     print('Error updating Memo: $e');
   }
   return Memo();
  }
}