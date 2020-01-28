import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../style_provider.dart';
import '../typedef.dart';
import 'flutter_18n.dart';

InputDecoration inputDecoration(BuildContext context) => InputDecoration(
      errorBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          const Radius.circular(10.0),
        ),
        borderSide: BorderSide(
          color: StylesProvider.of(context).colors.red,
        ),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          const Radius.circular(10.0),
        ),
        borderSide: BorderSide(
          color: StylesProvider.of(context).colors.disableButton,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          const Radius.circular(10.0),
        ),
        borderSide: BorderSide(
          color: StylesProvider.of(context).colors.red,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          const Radius.circular(10.0),
        ),
        borderSide: BorderSide(
          color: StylesProvider.of(context).colors.primaryColor,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          const Radius.circular(10.0),
        ),
        borderSide: BorderSide(
          color: StylesProvider.of(context).colors.disableButton,
        ),
      ),
    );

class TextFieldArg {
  const TextFieldArg({
    this.name,
    this.controller,
    this.onFieldSubmitted,
    this.focusNode,
    this.onChanged,
    this.keyboardType,
    this.hintText,
    this.showPassword,
    this.maxLines = 1,
    this.obscureText = false,
  });
  final String name;
  final TextEditingController controller;
  final bool obscureText;
  final FieldSubmitted onFieldSubmitted;
  final FocusNode focusNode;
  final OnChanged onChanged;
  final String hintText;
  final int maxLines;
  final VoidCallback showPassword;
  final TextInputType keyboardType;
}

class FormTextField extends StatelessWidget {
  final TextFieldArg textFieldArg;
  final bool enabled;
  final List<Validators> validators;

  const FormTextField({
    Key key,
    this.textFieldArg,
    this.validators,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 15),
          alignment: Alignment.centerLeft,
          child: Text(
            CustomFlutterI18n.translate(
                    context, 'TextField.${textFieldArg.name}')
                .toUpperCase(),
            style: StylesProvider.of(context).fonts.normalBlue,
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 10),
          child: FormBuilderTextField(
            readOnly: !enabled,
            keyboardType: textFieldArg.keyboardType,
            attribute: '${textFieldArg.name}',
            onChanged: textFieldArg.onChanged,
            controller: textFieldArg.controller,
            focusNode: textFieldArg.focusNode,
            autocorrect: false,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: textFieldArg.onFieldSubmitted,
            decoration: inputDecoration(context).copyWith(
              hintText: '${textFieldArg.hintText}',
              errorMaxLines: 2,
              hintStyle: StylesProvider.of(context)
                  .fonts
                  .normalBlueLowOpacity
                  .copyWith(fontSize: 14),
              suffixIcon: textFieldArg.showPassword != null
                  ? IconButton(
                      icon: Icon(
                        textFieldArg.obscureText
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: StylesProvider.of(context).colors.primaryColor,
                      ),
                      onPressed: textFieldArg.showPassword,
                    )
                  : null,
            ),
            style: StylesProvider.of(context)
                .fonts
                .normalBlue
                .copyWith(fontSize: 14),
            obscureText: textFieldArg.obscureText,
            maxLines: textFieldArg.maxLines,
            validators: validators,
          ),
        ),
      ],
    );
  }
}
