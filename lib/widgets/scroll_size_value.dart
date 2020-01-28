import 'package:flutter/material.dart';
import 'dart:core';

double scrollSizeValue(ScrollUpdateNotification scrollNotification,
    double currentSize, double initSize) {
  if (scrollNotification.metrics.pixels <= 0) {
    return initSize;
  } else if ((scrollNotification.metrics.maxScrollExtent + initSize) < 240.0) {
    return currentSize;
  } else if (scrollNotification.scrollDelta >= -5 &&
      scrollNotification.scrollDelta <= 5) {
    return currentSize;
  } else if (scrollNotification.metrics.atEdge) {
    return currentSize;
  } else if (scrollNotification.metrics.axis == Axis.vertical &&
      !scrollNotification.metrics.outOfRange) {
    if (scrollNotification.scrollDelta > 0 && currentSize >= 0) {
      return 0;
    } else if (scrollNotification.scrollDelta < 0 && currentSize <= initSize) {
      return initSize;
    }
  }
  return currentSize;
}
