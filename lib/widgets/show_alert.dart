import 'package:flutter/material.dart';
import 'package:app/style_provider.dart';

import 'flutter_18n.dart';

void showAlert(
  BuildContext context, {
  Widget message,
  String titleText,
  String messageText,
  Function onClose,
  Color backgroundColor = Colors.transparent,
  List<Widget> actions = const <Widget>[],
  bool barrierDismissible = true,
}) {
  showDialog<void>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (BuildContext context) {
      // return object of type Dialog
      return Scaffold(
        backgroundColor: backgroundColor,
        body: AlertDialog(
          title: titleText != null
              ? Column(
                  children: <Widget>[
                    Text(
                      titleText,
                      style: StylesProvider.of(context)
                          .fonts
                          .normalBlue
                          .copyWith(fontSize: 22),
                    ),
                    if (messageText != null)
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: Text(
                          messageText,
                          style: StylesProvider.of(context)
                              .fonts
                              .normalBlue
                              .copyWith(fontSize: 16),
                        ),
                      )
                  ],
                )
              : null,
          content: message,
          actions: <Widget>[
            FlatButton(
              splashColor: StylesProvider.of(context)
                  .colors
                  .primaryColor
                  .withOpacity(0.1),
              child: Text(
                CustomFlutterI18n.translate(context, 'close'),
                style: StylesProvider.of(context)
                    .fonts
                    .boldLightGreen
                    .copyWith(fontSize: 14),
              ),
              onPressed: onClose ??
                  () {
                    Navigator.of(context).pop();
                  },
            ),
            ...actions,
          ],
        ),
      );
    },
  );
}
