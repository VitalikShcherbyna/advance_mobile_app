import 'package:flutter/material.dart';
import 'package:app/widgets/awesome_alert.dart';
import 'package:app/widgets/flutter_18n.dart';

void showRegistrationError(BuildContext context, String code) {
  switch (code) {
    case "ERROR_INVALID_EMAIL":
      showAwesomeAlert(
        context,
        messageText: CustomFlutterI18n.translate(
            context, 'RegistrationView.invalidEmail'),
        titleText: CustomFlutterI18n.translate(context, 'error'),
      );
      break;
    case "ERROR_WEAK_PASSWORD":
      showAwesomeAlert(
        context,
        messageText: CustomFlutterI18n.translate(
            context, 'RegistrationView.weakPassword'),
        titleText: CustomFlutterI18n.translate(context, 'error'),
      );
      break;
    case "ERROR_EMAIL_ALREADY_IN_USE":
      showAwesomeAlert(
        context,
        messageText:
            CustomFlutterI18n.translate(context, 'RegistrationView.emailExist'),
        titleText: CustomFlutterI18n.translate(context, 'error'),
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
