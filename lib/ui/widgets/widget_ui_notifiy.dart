
import 'package:artrooms/ui/widgets/widget_chatroom_message_pin.dart';
import 'package:flutter/cupertino.dart';


class WidgetUiNotify extends StatefulWidget {

  final Widget child;

  const WidgetUiNotify({super.key, required this.child});

  @override
  State<StatefulWidget> createState() {
    return _WidgetUiNotify();
  }

}

class _WidgetUiNotify extends State<WidgetUiNotify> {

  @override
  void initState() {
    super.initState();
    statePin = this;
  }

  @override
  void dispose() {
    statePin = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack (
      children: [
        Container(
          child: widget.child,
        ),
        buildMessagePin(context, this),
      ],
    );
  }

}