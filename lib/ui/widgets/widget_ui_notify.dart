
import 'dart:async';

import 'package:artrooms/ui/widgets/widget_chatroom_message_pin.dart';
import 'package:flutter/cupertino.dart';

import '../../beans/bean_chat.dart';


List<State<StatefulWidget>> listStates = [];
DataChat dataChatPin = DataChat.empty();
Timer? _timer;

void addState(State<StatefulWidget> state) {
  listStates.add(state);
}

void removeState(State<StatefulWidget> state) {
  listStates.remove(state);
}

void notifyState(DataChat dataChat) {

  for(State<StatefulWidget> state in listStates) {
    state.setState(() {
      dataChatPin = dataChat;
    });
  }

  if(dataChatPin.id.isNotEmpty) {
    final timer = _timer;
    if(timer != null) {
      timer.cancel();
    }
    _timer = Timer(const Duration(seconds: 3), () {
      notifyState(DataChat.empty());
    });
  }

}

class WidgetUiNotify extends StatefulWidget {

  final Widget child;
  final DataChat? dataChat;

  const WidgetUiNotify({super.key, required this.child, this.dataChat});

  @override
  State<StatefulWidget> createState() {
    return _WidgetUiNotify();
  }

}

class _WidgetUiNotify extends State<WidgetUiNotify> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack (
      children: [
        Container(
          child: widget.child,
        ),
        Visibility(
            visible: widget.dataChat != dataChatPin,
            child: widgetChatMessagePin(context, this)
        ),
      ],
    );
  }

}