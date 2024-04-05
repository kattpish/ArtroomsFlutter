
import 'package:channel_talk_flutter/channel_talk_flutter.dart';


Future<void> initChannelTak() async {

  await ChannelTalk.boot(
    pluginKey: 'a2700e01-158d-4561-a81a-e4a899890724',
    memberId: '',
    email: '',
    name: '',
    memberHash: '',
    mobileNumber: '',
    trackDefaultEvent: false,
    hidePopup: false,
    language: 'english',
  );

}

Future<void> doShowChannelTak() async {

  await initChannelTak();

  await ChannelTalk.showMessenger();

}