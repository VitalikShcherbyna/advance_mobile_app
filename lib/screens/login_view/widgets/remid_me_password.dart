import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:app/widgets/awesome_alert.dart';
import 'package:app/widgets/flutter_18n.dart';

import '../../../style_provider.dart';

void remindMePassword(BuildContext context,
    TextEditingController emailController, VoidCallback sentPasswordToEmail) {
  showAwesomeAlert(
    context,
    dialogType: DialogType.INFO,
    messageText:
        CustomFlutterI18n.translate(context, 'LoginView.tooManyRequests'),
    btnOkText: CustomFlutterI18n.translate(context, 'sent'),
    btnOkOnPress: sentPasswordToEmail,
    titleText: CustomFlutterI18n.translate(context, 'LoginView.writeYourEmail'),
    message: Padding(
      padding: const EdgeInsets.all(15.0),
      child: TextField(
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        onSubmitted: (_) => sentPasswordToEmail,
        autocorrect: false,
        decoration: InputDecoration(
          hintText:
              CustomFlutterI18n.translate(context, 'RegistrationView.email'),
          focusColor: StylesProvider.of(context).colors.primaryColor,
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: StylesProvider.of(context).colors.primaryColor)),
          hintStyle: StylesProvider.of(context)
              .fonts
              .normalBlueLowOpacity
              .copyWith(fontSize: 13),
        ),
        style:
            StylesProvider.of(context).fonts.normalBlue.copyWith(fontSize: 13),
      ),
    ),
  );
}
