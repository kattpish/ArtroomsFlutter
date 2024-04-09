
import 'package:flutter/cupertino.dart';


class ScrollPhysicsBouncingNormal extends BouncingScrollPhysics {

  const ScrollPhysicsBouncingNormal({ScrollPhysics? parent}) : super(parent: parent);

  @override
  ScrollPhysicsBouncingNormal applyTo(ScrollPhysics? ancestor) {
    return ScrollPhysicsBouncingNormal(parent: buildParent(ancestor));
  }

  @override
  SpringDescription get spring {
    return SpringDescription.withDampingRatio(
      mass: 0.09,
      stiffness: 1000.0,
      ratio: 5.0,
    );
  }

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    return super.applyPhysicsToUserOffset(position, offset * 0.15);
  }

}
