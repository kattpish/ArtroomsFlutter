
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../data/module_datastore.dart';


class UserModule {

  Future<Map<String, dynamic>?> getMyProfile() async {

    MyDataStore myDataStore = MyDataStore();

    const String url = 'https://artrooms-api-elasticbeanstalk.com/graphql';

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
      Uri.parse(url),
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

    const String url = 'https://artrooms-api-elasticbeanstalk.com/graphql';

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
      Uri.parse(url),
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
      print('Error updating profile: ${response.body}');
      return null;
    }
  }

}
