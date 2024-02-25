
import 'package:artrooms/data/module_datastore.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../beans/bean_chat.dart';


class ChatModule {

  Future<List<MyChat>> getUserChats() async {

    List<MyChat> chats = [];

    await fetchUserChannels().then((List<Map<String, dynamic>> listChannels) {

      for(Map<String, dynamic> data in listChannels) {
        MyChat chat = MyChat.fromUrl(data);
        chats.add(chat);
      }

      return chats;
    });

    return chats;
  }

  Future<List<Map<String, dynamic>>> fetchUserChannels() async {

    MyDataStore myDataStore = MyDataStore();

    String email = myDataStore.getEmail();
    String encodedEmail = Uri.encodeComponent(email);

    String baseUrl = 'https://api-01cfffe8-f1b8-4bb4-a576-952abdc8d08a.sendbird.com/v3/users/$encodedEmail/my_group_channels';
    Map<String, String> queryParams = {
      'token': myDataStore.getAccessToken(),
      'limit': '20',
      'order': 'latest_last_message',
      'show_member': 'true',
      'show_read_receipt': 'true',
      'show_delivery_receipt': 'true',
      'show_empty': 'true',
      'member_state_filter': 'all',
      'super_mode': 'all',
      'public_mode': 'all',
      'unread_filter': 'all',
      'hidden_mode': 'unhidden_only',
      'show_frozen': 'true',
      'show_metadata': 'true',
    };

    Uri uri = Uri.parse(baseUrl).replace(queryParameters: queryParams);
    final response = await http.get(
      uri,
      headers: {
        'Accept': 'application/json',
        'Api-Token': myDataStore.getAccessToken(),
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      return data['channels'];
    } else {
      print('Error fetching channels: ${response.body}');
      return [];
    }

  }

}
