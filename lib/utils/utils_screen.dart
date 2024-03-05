
import 'package:flutter/cupertino.dart';
import 'dart:math' as math;


bool isTablet(BuildContext context) {

  var screenSize = MediaQuery.of(context).size;

  var devicePixelRatio = MediaQuery.of(context).devicePixelRatio;

  var screenWidth = screenSize.width / devicePixelRatio;
  var screenHeight = screenSize.height / devicePixelRatio;
  var diagonalScreenSize = math.sqrt((screenWidth * screenWidth) + (screenHeight * screenHeight));

  return diagonalScreenSize > 7.0;
}