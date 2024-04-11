
import 'package:flutter/cupertino.dart';


class NoGlowScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context,
      Widget child,
      AxisDirection axisDirection) {
    return child;
  }
}
