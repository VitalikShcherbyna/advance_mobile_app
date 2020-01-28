import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:app/widgets/awesome_alert.dart';
import 'package:app/widgets/flutter_18n.dart';

import '../../../typedef.dart';

void existUserAlert(BuildContext context, RefetchFunction logout) {
  showAwesomeAlert(context,
      dialogType: DialogType.WARNING,
      barrierDismissible: false,
      titleText: CustomFlutterI18n.translate(context, 'LoginView.newAccount'),
      messageText:
          CustomFlutterI18n.translate(context, 'LoginView.existingRole'),
      btnOkOnPress: () async {
    await logout();
  });
}
