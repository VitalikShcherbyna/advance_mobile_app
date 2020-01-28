import 'package:flutter/material.dart';

T whenDevice<T>(
  BuildContext context, {
  @required T small,
  @required T medium,
  @required T large,
  @required T xl,
  @required T xxl,
}) {
  double height = MediaQuery.of(context).size.height;
  if (height >= 800) {
    return xxl;
  } else if (height < 800 && height > 700) {
    return xl;
  } else if (height <= 700 && height > 665) {
    return large;
  } else if (height <= 660 && height > 540) {
    return medium;
  } else {
    return small;
  }
}

bool isSmallDevice(BuildContext context) {
  return MediaQuery.of(context).size.height < 667;
}
