import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

const kDefaultDelayDurationMs = 200;
const kDefaultIntervalDurationMs = 300;
const kDefaultAnimationDurationMs = 450;
const kDefaultBegin = Offset(-0.02, 0);


extension PageAnimation on Widget {
  Widget enterAnimation({int order = 1, bool enabled = true, int duration = kDefaultAnimationDurationMs}) {
    if (!enabled) {
      return this;
    }

    order -= 1;

    return animate(
      delay: kDefaultDelayDurationMs.ms + (order * kDefaultIntervalDurationMs).ms,
    )
        .fadeIn(
          duration: kDefaultAnimationDurationMs.ms,
          curve: Curves.easeIn,
        )
        .slide(
          duration: kDefaultAnimationDurationMs.ms,
          curve: Curves.easeInOutCubic,
          begin: kDefaultBegin,
        );
  }
}
