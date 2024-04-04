
import 'package:flutter/cupertino.dart';

class ScrollPhysicsBouncing extends BouncingScrollPhysics {

  const ScrollPhysicsBouncing({ScrollPhysics? parent}) : super(parent: parent);

  @override
  ScrollPhysicsBouncing applyTo(ScrollPhysics? ancestor) {
    return ScrollPhysicsBouncing(parent: buildParent(ancestor));
  }

  @override
  SpringDescription get spring {
    return SpringDescription.withDampingRatio(
      mass: 0.09,
      stiffness: 1000.0,
      ratio: 17.0,
    );
  }

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    return super.applyPhysicsToUserOffset(position, offset * 0.65);
  }


}
