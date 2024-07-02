import 'package:artrooms/utils/utils_media.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../listeners/scroll_bouncing_physics.dart';
import '../../main.dart';
import '../theme/theme_colors.dart';
import '../widgets/widget_notifications.dart';
import '../widgets/widget_ui_notify.dart';

class ScreenNotifications extends StatefulWidget {
  const ScreenNotifications({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ScreenNotificationsState();
  }
}

class _ScreenNotificationsState extends State<ScreenNotifications> {
  List<String> _tunes = [];
  late String _notificationEnabled;

  @override
  void initState() {
    super.initState();
    setTunes();
    _notificationEnabled = dbStore.getNotificationValue();
  }

  Future<void> setTunes() async {
    List<String> tunes = await getAllTunes();
    setState(() {
      _tunes = tunes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 10.0),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: colorMainGrey250,
              size: 20,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        toolbarHeight: 60,
        titleSpacing: 0,
        leadingWidth: 46,
        title: const Text(
          '알림음',
          style: TextStyle(
            color: colorMainGrey900,
            fontSize: 18,
            fontFamily: 'SUIT',
            fontWeight: FontWeight.w700,
            height: 0,
            letterSpacing: -0.36,
          ),
        ),
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      backgroundColor: colorMainScreen,
      body: WidgetUiNotify(
        child: StretchingOverscrollIndicator(
          axisDirection: AxisDirection.down,
          child: ScrollConfiguration(
            behavior: scrollBehavior,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Column(
                    children: _tunes.map((tune) {
                      int index = _tunes.indexOf(tune);
                      return InkWell(
                          onTap: () {
                            _doToggleNotification(index);
                            audioPlayer ??= AudioPlayer();
                            audioPlayer?.play(
                                AssetSource('sounds/${_tunes[index]}.mp3'));
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: ListTile(
                              title: Text(
                                tune,
                                style: const TextStyle(
                                  color: Color(0xFF111111),
                                  fontSize: 16,
                                  fontFamily: 'SUIT',
                                  fontWeight: FontWeight.w400,
                                  height: 0,
                                  letterSpacing: -0.32,
                                ),
                              ),
                              trailing: SvgPicture.asset(
                                _notificationEnabled == _tunes[index]
                                    ? 'assets/images/icons/icon_tick_on.svg'
                                    : 'assets/images/icons/icon_tick_off.svg',
                              ),
                            ),
                          ));
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _doToggleNotification(int index) {
    dbStore.setNotificationValue(_tunes[index]);
    setState(() {
      _notificationEnabled = _tunes[index];
    });
  }
}
