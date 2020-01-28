import 'package:flutter/material.dart';
import 'package:app/routes.dart';

void pushRouteAndClean(BuildContext context, String route,
    {bool fullscreenDialog = false, NavigationArguments arguments}) {
  Navigator.pushNamedAndRemoveUntil(
    context,
    route,
    (Route<dynamic> route) => false,
    arguments: arguments,
  );
}
