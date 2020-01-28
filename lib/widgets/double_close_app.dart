import 'package:flutter/material.dart';

class DoubleBackToCloseApp extends StatefulWidget {
  final SnackBar snackBar;
  final Widget child;

  const DoubleBackToCloseApp({
    Key key,
    @required this.snackBar,
    @required this.child,
  })  : assert(snackBar != null),
        assert(child != null),
        super(key: key);

  @override
  DoubleBackToCloseAppState createState() => DoubleBackToCloseAppState();
}

@visibleForTesting
class DoubleBackToCloseAppState extends State<DoubleBackToCloseApp> {
  DateTime lastTimeBackButtonWasTapped;

  bool get isAndroid => Theme.of(context).platform == TargetPlatform.android;

  bool get isSnackBarVisible =>
      (lastTimeBackButtonWasTapped != null) &&
      (widget.snackBar.duration >
          DateTime.now().difference(lastTimeBackButtonWasTapped));

  bool get willHandlePopInternally =>
      ModalRoute.of(context).willHandlePopInternally;

  @override
  Widget build(BuildContext context) {
    ensureThatContextContainsScaffold();

    if (isAndroid) {
      return WillPopScope(
        onWillPop: onWillPop,
        child: widget.child,
      );
    } else {
      return widget.child;
    }
  }

  Future<bool> onWillPop() async {
    if (isSnackBarVisible || willHandlePopInternally) {
      return true;
    } else {
      lastTimeBackButtonWasTapped = DateTime.now();
      Scaffold.of(context).showSnackBar(widget.snackBar);
      return false;
    }
  }

  void ensureThatContextContainsScaffold() {
    if (Scaffold.of(context, nullOk: true) == null) {
      throw StateError(
        '`DoubleBackToCloseApp` must be wrapped in a `Scaffold`.',
      );
    }
  }
}
