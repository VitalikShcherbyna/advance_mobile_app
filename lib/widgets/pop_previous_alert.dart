import 'package:flutter/material.dart';

void popPreviosAlert(BuildContext context) {
  if (Navigator.canPop(context)) {
    Navigator.pop(context);
  }
}
