
import 'package:flutter/cupertino.dart';


bool isTablet(BuildContext context) {
  double screenWidth = MediaQuery.of(context).size.width;
  return screenWidth > 715;
}
