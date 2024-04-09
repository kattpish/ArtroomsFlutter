import 'package:flutter/cupertino.dart';


class ScrollPhysicsBouncingFast extends BouncingScrollPhysics {

  const ScrollPhysicsBouncingFast({ScrollPhysics? parent}) : super(parent: parent);

  @override
  ScrollPhysicsBouncingFast applyTo(ScrollPhysics? ancestor) {
    return ScrollPhysicsBouncingFast(parent: buildParent(ancestor));
  }

  @override
  SpringDescription get spring {
    return SpringDescription.withDampingRatio(
      mass: 0.01,
      stiffness: 2000.0,
      ratio: 1.0,
    );
  }

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    return super.applyPhysicsToUserOffset(position, offset * 0.15);
  }

}
