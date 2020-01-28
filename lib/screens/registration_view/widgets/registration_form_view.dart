import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:app/widgets/flutter_18n.dart';
import 'package:app/widgets/text_field_arg.dart';

import '../../../style_provider.dart';
import '../../../typedef.dart';

class RegistrationFormView extends StatelessWidget {
  RegistrationFormView({
    Key key,
    @required this.autovalidate,
    @required this.onChangedFormBuilder,
    @required this.formKey,
    @required this.textFields,
    @required this.enabled,
    @required this.acceptRegulation,
    @required this.onChangedAcceptRegulation,
    @required this.onPressRegulation,
    @required this.onPressPolicy,
  }) : super(key: key);
  final bool enabled;
  final bool autovalidate;
  final bool acceptRegulation;
  final OnChanged onChangedAcceptRegulation;
  final VoidCallback onPressRegulation;
  final VoidCallback onPressPolicy;
  final OnChangedFormBuilder onChangedFormBuilder;
  final GlobalKey<FormBuilderState> formKey;
  final TextFields textFields;
  final TextEditingController email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bool isAcceptTermsHasError = false;
    if (formKey?.currentState?.fields != null) {
      isAcceptTermsHasError =
          formKey.currentState.fields['accept_terms']?.currentState?.hasError ??
              false;
    }
    return FormBuilder(
      autovalidate: autovalidate,
      onChanged: autovalidate ? onChangedFormBuilder : null,
      key: formKey,
      child: Container(
        decoration: StylesProvider.of(context).boxDecoration.cards,
        padding: EdgeInsets.only(
            left: 18, right: 18, bottom: isAcceptTermsHasError ? 20 : 0),
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
            FormBuilderCheckbox(
              leadingInput: true,
              initialValue: acceptRegulation,
              decoration: InputDecoration(
                border: InputBorder.none,
                errorMaxLines: 2,
                errorStyle: TextStyle(
                  height: 1.5,
                ),
              ),
              activeColor: StylesProvider.of(context).colors.primaryColor,
              attribute: 'accept_terms',
              onChanged: onChangedAcceptRegulation,
              validators: [
                FormBuilderValidators.requiredTrue(
                  errorText: CustomFlutterI18n.translate(
                      context, 'RegulationView.shouldAccept'),
                )
              ],
              label: RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: CustomFlutterI18n.translate(
                        context, 'RegulationView.acceptRegulation'),
                    style: StylesProvider.of(context).fonts.lightBlue.copyWith(
                          fontSize: 11,
                        ),
                  ),
                  TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = onPressRegulation,
                    text: CustomFlutterI18n.translate(
                        context, 'RegulationView.regulationModify'),
                    style: StylesProvider.of(context).fonts.boldBlue.copyWith(
                          decoration: TextDecoration.underline,
                          fontSize: 12,
                          letterSpacing: 1.2,
                        ),
                  ),
                  TextSpan(
                    text: CustomFlutterI18n.translate(
                        context, 'RegulationView.and'),
                    style: StylesProvider.of(context).fonts.lightBlue.copyWith(
                          fontSize: 11,
                        ),
                  ),
                  TextSpan(
                    text: CustomFlutterI18n.translate(
                        context, 'RegulationView.policy'),
                    recognizer: TapGestureRecognizer()..onTap = onPressPolicy,
                    style: StylesProvider.of(context).fonts.boldBlue.copyWith(
                          decoration: TextDecoration.underline,
                          fontSize: 12,
                          letterSpacing: 1.2,
                        ),
                  ),
                  TextSpan(
                    text: CustomFlutterI18n.translate(
                        context, 'RegulationView.continueRegulation'),
                    style: StylesProvider.of(context).fonts.lightBlue.copyWith(
                          fontSize: 11,
                        ),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
