import 'package:flutter/material.dart';
import 'package:app/widgets/awesome_alert.dart';
import 'package:app/widgets/flutter_18n.dart';

void showLoginError(
    BuildContext context, String code, VoidCallback remindMePassword) {
  switch (code) {
    case "ERROR_WRONG_PASSWORD":
      showAwesomeAlert(
        context,
        messageText: CustomFlutterI18n.translate(
            context, 'LoginView.wrongEmailPassword'),
        titleText: CustomFlutterI18n.translate(context, 'error'),
      );
      break;
    case "ERROR_USER_NOT_FOUND":
      showAwesomeAlert(
        context,
        messageText: CustomFlutterI18n.translate(
            context, 'LoginView.notExistingAccount'),
        titleText: CustomFlutterI18n.translate(context, 'error'),
      );
      break;
    case "ERROR_TOO_MANY_REQUESTS":
      showAwesomeAlert(
        context,
        messageText:
            CustomFlutterI18n.translate(context, 'LoginView.tooManyRequests'),
        titleText: CustomFlutterI18n.translate(context, 'error'),
        btnOkText: CustomFlutterI18n.translate(context, 'LoginView.remindMe'),
        btnOkOnPress: () {
          remindMePassword();
        },
      );
      break;
    default:
      showAwesomeAlert(
        context,
        titleText: CustomFlutterI18n.translate(context, 'error'),
      );
      break;
  }
}
