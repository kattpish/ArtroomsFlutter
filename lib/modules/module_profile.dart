
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../api/api.dart';
import '../data/module_datastore.dart';
import '../main.dart';


class UserModule {

  Future<Map<String, dynamic>?> getMyProfile() async {

    MyDataStore myDataStore = MyDataStore();

    const String query = '''
      query WhoAmI {
        whoAmI {
          ... on User {
            id
            type
            email
            createdAt
            updatedAt
            student {
              id
              nickname
              name
              phoneNumber
              acceptMarketing
              certificationPhone
              point {
                id
                createdAt
                updatedAt
                studentId
                point
              }
              studentCart {
                id
              }
              paymentClasses {
                imp_uid
                paymentClasses {
                  id
                  artClassMain {
                    id
                  }
                }
              }
            }
            profileImgId
            profileImg {
              id
              accessUrl
              originalFilename
              filename
              location
              mimeType
              size
            }
          }
          ... on Error {
            status
            message
          }
        }
      }
    '''
    ;

    var response = await http.post(
      Uri.parse(apiUrlGraphQL),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': myDataStore.getAccessToken(),
      },
      body: jsonEncode({
        'query': query,
        'operationName': 'WhoAmI',
      }),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data['data']['whoAmI'] as Map<String, dynamic>?;
    } else {
      print('Error fetching profile: ${response.body}');
      return null;
    }
  }

  Future<Map<String, dynamic>?> updateProfile({
    required int userId,
    required String name,
    required String nickname,
    bool acceptMarketing = false,
    bool certificationPhone = false,
  }) async {

    MyDataStore myDataStore = MyDataStore();

    const String mutation = '''
      mutation UpdateUser(\$updateUserId: Int, \$updateStudentInput: UpdateStudentInput) {
        updateUser(
          id: \$updateUserId
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
        'Authorization': myDataStore.getAccessToken(),
      },
      body: jsonEncode({
        'operationName': 'UpdateUser',
        'variables': {
          'updateUserId': userId,
          'updateStudentInput': {
            'acceptMarketing': acceptMarketing,
            'certificationPhone': certificationPhone,
            'name': name,
            'nickname': nickname,
          },
        },
        'query': mutation,
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      return data['data']['updateUser'] as Map<String, dynamic>?;
    } else {
      if (kDebugMode) {
        print('Error updating profile: ${response.body}');
      }
      return null;
    }

  }

  Future<Map<String, dynamic>?> uploadProfileImage(XFile fileImage) async {
    try {
      var uri = Uri.parse('https://artrooms-api-upload.com/file');
      var request = http.MultipartRequest('POST', uri);

      request.files.add(await http.MultipartFile.fromPath(
        'file',
        fileImage.path,
        contentType: null,
      ));

      request.headers.addAll({
        'Accept': 'application/json, text/plain, */*',
      });

      var streamedResponse = await request.send();

      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201) {
        myDataStore.saveProfilePicture(jsonDecode(response.body));
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        if (kDebugMode) {
          print('Failed to upload image: ${response.body}');
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error uploading image: $e');
      }
      return null;
    }
  }

}
