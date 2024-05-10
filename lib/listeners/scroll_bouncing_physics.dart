
import 'package:flutter/cupertino.dart';


ScrollBehavior scrollBehavior = const ScrollBehavior().copyWith(overscroll: false);

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
    return super.applyPhysicsToUserOffset(position, offset * 0.15);
  }

}


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

