
import 'package:channel_talk_flutter/channel_talk_flutter.dart';

import '../../main.dart';


Future<void> initChannelTak() async {

  await ChannelTalk.boot(
    pluginKey: 'a2700e01-158d-4561-a81a-e4a899890724',
    memberId: '${dbStore.getUserId()}',
    email: dbStore.getEmail(),
    name: dbStore.getName(),
    memberHash: '',
    mobileNumber: dbStore.getPhoneNumber(),
    trackDefaultEvent: false,
    hidePopup: false,
    language: 'korean',
  );

}

Future<void> doShowChannelTak() async {

  await initChannelTak();

  await ChannelTalk.showMessenger();

}