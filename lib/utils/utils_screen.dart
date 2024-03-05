
import 'package:flutter/cupertino.dart';
import 'dart:math' as math;


bool isTablet(BuildContext context) {
  var screenWidth = MediaQuery.of(context).size.width;
  return screenWidth > 715;
}
