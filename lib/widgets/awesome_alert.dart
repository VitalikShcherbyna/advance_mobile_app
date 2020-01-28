import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:app/widgets/awesome_dialog.dart';
import 'package:app/widgets/custom_animated_button.dart';

import '../style_provider.dart';
import 'flutter_18n.dart';

void showAwesomeAlert(
  BuildContext context, {
  Widget message,
  String titleText,
  String messageText,
  String btnCancelText,
  Widget customHeader,
  Function onClose,
  VoidCallback btnOkOnPress,
  String btnOkText,
  DialogType dialogType = DialogType.ERROR,
  bool barrierDismissible = true,
  bool showOkButton = true,
}) {
  CustomAwesomeDialog(
    context: context,
    customHeader: customHeader,
    animType: AnimType.SCALE,
    dialogType: dialogType,
    body: message ??
        Column(
          children: <Widget>[
            if (titleText != null)
              Text(
                titleText,
                style: StylesProvider.of(context)
                    .fonts
                    .normalBlue
                    .copyWith(fontSize: 22),
                textAlign: TextAlign.center,
              ),
            if (messageText != null)
              Container(
                margin: EdgeInsets.only(top: 20),
                padding: EdgeInsets.all(8),
                child: Text(
                  messageText,
                  style: StylesProvider.of(context)
                      .fonts
                      .normalBlue
                      .copyWith(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              )
          ],
        ),
    tittle: titleText,
    btnOkColor: StylesProvider.of(context).colors.primaryColor,
    desc: messageText,
    btnOkText: btnOkText,
    btnCancel: onClose != null
        ? CustomAnimatedButton(
            pressEvent: () {
              Navigator.of(context).pop();
              onClose();
            },
            text:
                btnCancelText ?? CustomFlutterI18n.translate(context, 'close'),
            color: Colors.red,
          )
        : null,
    btnOk: showOkButton
        ? CustomAnimatedButton(
            pressEvent: () {
              Navigator.of(context).pop();
              if (btnOkOnPress != null) {
                btnOkOnPress();
              }
            },
            text: btnOkText ?? 'Ok',
            color: StylesProvider.of(context).colors.primaryColor,
          )
        : null,
    dismissOnTouchOutside: barrierDismissible,
  ).show();
}
