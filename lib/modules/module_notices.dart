import 'dart:async';
import 'dart:convert';
import 'package:artrooms/beans/bean_chatting_artist_profile.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../api/api.dart';
import '../beans/bean_notice.dart';
import '../main.dart';

class ModuleNotice {
  Future<DataNotice> getNotice(final String channelUrl) async {
    final DataNotice dataNotice;

    final List<DataNotice> notices = await getNotices(channelUrl);

    if (notices.isNotEmpty) {
      dataNotice = notices[0];
    } else {
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

    final Uri uri = Uri.parse(apiUrlGraphQL);

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

  Future<ArtistProfile> getArtistProfileInfo({required int artistId}) async {
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
        Uri.parse(apiUrlGraphQL),
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
        if (kDebugMode) {
          print('Get artist info: $responseData');
        }
        return ArtistProfile.fromJson(
            responseData['data']['searchChattingArtistProfile']);
      } else {
        if (kDebugMode) {
          // print('Failed to get artist info: ${response.body}');
        }
        return ArtistProfile();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting artist info $e');
      }
      return ArtistProfile();
    }
  }

  Future<Map<String, dynamic>?> getArtistProfileInfoByEmail(
      {required String email}) async {
    Map<String, dynamic> body = {
      "operationName": "ArtistFromUserEmail",
      "variables": {"email": email},
      "query": """
         query ArtistFromUserEmail(\$email: String!) {
          artistFromUserEmail(email: \$email) {
            ... on Artist {
              id
              nameEn
              nameKo
              user {
                id
                profileImgId
                profileImg {
                  accessUrl
                }
                socialImg
              }
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
        print('>> response of profile $responseData');
      }
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (kDebugMode) {
          // print('!!!! Get artist info: $responseData');
        }
        if (responseData.isEmpty) {
          return null;
        }
        return {
          "name": responseData['data']['artistFromUserEmail']['nameKo'],
          "profilePictureUrl": responseData['data']['artistFromUserEmail']
              ['user']['profileImg']['accessUrl']
        };
      } else {
        if (kDebugMode) {
          print('Failed to get artist info $email ${response.body}');
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting artist profile $email $e');
      }
      return null;
    }
  }

  Future<Map<String, dynamic>?> getAdminProfileByEmail(
      {required String email}) async {
    Map<String, dynamic> body = {
      "operationName": "AdminFromEmail",
      "variables": {"email": email},
      "query": """
         query AdminFromEmail(\$email: String!) {
          adminFromEmail(email: \$email) {
            ... on Admin {
              id
              name
              profileImage {
                accessUrl        
              }
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
        print('>> response of profile $responseData');
      }
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (kDebugMode) {
          // print('!!!! Get student info: $email $responseData');
        }
        if (responseData.isEmpty) {
          return null;
        }
        return {
          "name": responseData['data']['adminFromEmail']['name'],
          "profilePictureUrl": responseData['data']['adminFromEmail']
              ['profileImage']['accessUrl']
        };
      } else {
        if (kDebugMode) {
          print('Failed to get student info: ${response.body}');
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting student profile $e');
      }
      return null;
    }
  }
}
