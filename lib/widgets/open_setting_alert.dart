import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'awesome_alert.dart';
import 'flutter_18n.dart';

void openLocationSettingsAlert(BuildContext context) {
  showAwesomeAlert(
    context,
    dialogType: DialogType.WARNING,
    titleText: CustomFlutterI18n.translate(context, 'location'),
    btnOkOnPress: () async {
      await PermissionHandler().openAppSettings();
    },
    messageText: CustomFlutterI18n.translate(context, 'locationDescription'),
    btnOkText: CustomFlutterI18n.translate(context, 'yes'),
  );
}

void openNotificationSettingsAlert(BuildContext context) {
  showAwesomeAlert(
    context,
    dialogType: DialogType.WARNING,
    titleText: CustomFlutterI18n.translate(context, 'notification'),
    btnOkOnPress: () async {
      await PermissionHandler().openAppSettings();
    },
    messageText:
        CustomFlutterI18n.translate(context, 'notificationDescription'),
    btnOkText: CustomFlutterI18n.translate(context, 'yes'),
  );
}
