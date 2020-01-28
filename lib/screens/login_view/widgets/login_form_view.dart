import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:app/style_provider.dart';
import 'package:app/widgets/flutter_18n.dart';
import 'package:app/widgets/text_field_arg.dart';

import '../../../typedef.dart';

class LogInFormView extends StatelessWidget {
  final bool enabled;
  final bool autovalidate;
  final bool logInForm;
  final VoidCallback signInWithGmail;
  final VoidCallback signInWithFaceBook;
  final VoidCallback remindMePassword;
  final OnChangedFormBuilder onChangedFormBuilder;
  final GlobalKey<FormBuilderState> formKey;
  final TextFields textFields;

  LogInFormView({
    Key key,
    @required this.autovalidate,
    this.signInWithGmail,
    this.signInWithFaceBook,
    this.remindMePassword,
    @required this.onChangedFormBuilder,
    @required this.formKey,
    @required this.textFields,
    this.logInForm = false,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      autovalidate: autovalidate,
      onChanged: autovalidate ? onChangedFormBuilder : null,
      key: formKey,
      child: Container(
        decoration:
            logInForm ? StylesProvider.of(context).boxDecoration.cards : null,
        padding: EdgeInsets.symmetric(
          horizontal: 18,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...textFields(context)
                .entries
                .map<Widget>(
                  (MapEntry<TextFieldArg, List> map) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: FormTextField(
                      enabled: enabled,
                      textFieldArg: map.key,
                      validators: map.value,
                    ),
                  ),
                )
                .toList(),
            if (logInForm)
              Container(
                alignment: Alignment.centerRight,
                margin: EdgeInsets.symmetric(vertical: 10),
                child: GestureDetector(
                  onTap: remindMePassword,
                  child: Text(
                    CustomFlutterI18n.translate(
                        context, 'LoginView.remindMePassword'),
                    style: StylesProvider.of(context)
                        .fonts
                        .boldLightGreen
                        .copyWith(
                          fontSize: 14,
                        ),
                  ),
                ),
              ),
            if (logInForm)
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    IconButton(
                      icon: Image.asset(
                        'assets/facebook_icon.png',
                      ),
                      onPressed: enabled ? signInWithFaceBook : () {},
                    ),
                    IconButton(
                      icon: Image.asset(
                        'assets/gmail_icon.png',
                      ),
                      onPressed: enabled ? signInWithGmail : () {},
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
