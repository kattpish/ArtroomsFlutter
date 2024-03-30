
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
      mass: 0.1,
      stiffness: 1000.0,
      ratio: 1.0,
    );
  }
}
