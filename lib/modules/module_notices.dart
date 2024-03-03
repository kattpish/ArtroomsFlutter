
import 'dart:async';
import 'dart:convert';
import 'package:artrooms/data/module_datastore.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../api/api.dart';
import '../beans/bean_notice.dart';


class ModuleNotice {

  final MyDataStore myDataStore = MyDataStore();


  Future<MyNotice> getNotice(final String channelUrl) async {

    final MyNotice myNotice;

    final List<MyNotice> notices = await getNotices(channelUrl);

    if(notices.isNotEmpty) {
      myNotice = notices[0];
    }else {
      myNotice = MyNotice();
    }

    return myNotice;
  }

  Future<List<MyNotice>> getNotices(final String channelUrl) async {

    final List<dynamic> noticesJson = await fetchNotices(channelUrl);

    final List<MyNotice> notices = noticesJson.map((json) {
      return MyNotice.fromJson(json);
    }).toList();

    return notices;
  }

  Future<List<dynamic>> fetchNotices(final String channelUrl) async {

    List<dynamic> noticesJson = [];

    final Uri uri = Uri.parse(apiUrlGraphQL);

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${myDataStore.getAccessToken()}',
      },
      body: jsonEncode({
        "operationName": "SearchChattingNotice",
        "variables": {
          "url": channelUrl,
        },
        "query": """
          query SearchChattingNotice(\$url: String!) {
            searchChattingNotice(url: \$url) {
              ... on ChattingNoticeList {
                data {
                  id
                  notice
                  url
                  artistId
                  noticeable
                  createdAt
                  __typename
                }
                totalCount
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
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      noticesJson = responseData['data']['searchChattingNotice']['data'];
      if (kDebugMode) {
        print('fetched notices: $noticesJson');
      }
    } else {
      if (kDebugMode) {
        print('Error fetching notices: ${response.body}');
      }
    }

    return noticesJson;
  }

}
