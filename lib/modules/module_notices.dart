
import 'dart:async';
import 'dart:convert';
import 'package:artrooms/beans/bean_chatting_artist_profile.dart';
import 'package:artrooms/data/module_datastore.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../api/api.dart';
import '../beans/bean_notice.dart';


class ModuleNotice {

  final DBStore dbStore = DBStore();


  Future<DataNotice> getNotice(final String channelUrl) async {

    final DataNotice dataNotice;

    final List<DataNotice> notices = await getNotices(channelUrl);

    if(notices.isNotEmpty) {
      dataNotice = notices[0];
    }else {
      dataNotice = DataNotice();
    }

    return dataNotice;
  }

  Future<List<DataNotice>> getNotices(final String channelUrl) async {

    final List<dynamic> noticesJson = await fetchNotices(channelUrl);

    final List<DataNotice> notices = noticesJson.map((json) {
      return DataNotice.fromJson(json);
    }).toList();

    return notices;
  }

  Future<List<dynamic>> fetchNotices(final String channelUrl) async {

    List<dynamic> noticesJson = [];

    final Uri uri = Uri.parse(apiUrlGraphQLTest);

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${dbStore.getAccessToken()}',
      },
      body: jsonEncode({
        "operationName": "searchChattingNotice",
        "variables": {
          "url": channelUrl,
        },
        "query": """
           query searchChattingNotice(\$url: String!) {
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
  Future<ArtistProfile> getProfileInfo({required int artistId}) async {
    Map<String, dynamic> body = {
      "operationName": "searchChattingArtistProfile",
      "variables": {"artistId": artistId},
      "query": """
       query searchChattingArtistProfile (\$artistId: Int!){
    searchChattingArtistProfile(artistId: \$artistId) {
        ... on ChattingArtistProfile {
            id
            feedback
            classAdvice
            ableDay
            ableTime
            replyTime
            artistId
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
        return ArtistProfile.fromJson(responseData['data']['searchChattingArtistProfile']);
      } else {
        if (kDebugMode) {
          print('Error updating profile picture: ${response.body}');
        }
        return ArtistProfile();
      }
    } catch (e) {
      print('error ${e}');
      return ArtistProfile();
    }
  }
}
