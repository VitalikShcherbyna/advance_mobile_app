import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:app/data/user_data.dart';
import 'package:app/routes.dart';
import 'package:app/screens/pdf_view/pdf_view.dart';
import 'package:app/screens/registration_view/widgets/registration_errors.dart';
import 'package:app/screens/registration_view/widgets/registration_form_view.dart';
import 'package:app/widgets/activity_indicator.dart';
import 'package:app/widgets/flutter_18n.dart';
import 'package:app/widgets/pop_previous_alert.dart';
import 'package:app/widgets/submit_button.dart';
import 'package:app/widgets/text_field_arg.dart';

import '../../style_provider.dart';
import '../../typedef.dart';

class RegistrationView extends StatefulWidget {
  RegistrationView({
    Key key,
  }) : super(key: key);

  @override
  _RegistrationViewState createState() => _RegistrationViewState();
}

class _RegistrationViewState extends State<RegistrationView> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isValid = true;
  bool _autovalidate = false;
  bool _obscureText = true;
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  TextFields _textFields;
  //CHECKBOXS
  bool _acceptRegulation = false;

  @override
  void initState() {
    super.initState();
    _textFields = (BuildContext context) => {
          TextFieldArg(
              name: 'email',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              hintText: CustomFlutterI18n.translate(
                  context, 'RegistrationView.email'),
              focusNode: _emailFocus,
              onFieldSubmitted:
                  _fieldFocusChange(_emailFocus, _passwordFocus)): [
            FormBuilderValidators.required(
              errorText:
                  CustomFlutterI18n.translate(context, 'TextField.error.empty'),
            ),
            FormBuilderValidators.email(
                errorText: CustomFlutterI18n.translate(
                    context, 'TextField.error.emailError'))
          ],
          TextFieldArg(
              name: 'password',
              controller: _passwordController,
              hintText: CustomFlutterI18n.translate(
                  context, 'RegistrationView.password'),
              focusNode: _passwordFocus,
              showPassword: _showPassword,
              onFieldSubmitted: (_) => _submit(),
              obscureText: _obscureText): [
            FormBuilderValidators.required(
              errorText:
                  CustomFlutterI18n.translate(context, 'TextField.error.empty'),
            ),
          ],
        };
  }

  void trimWhitespaces() {
    _emailController.value =
        TextEditingValue(text: _emailController.text.trim());
  }

  void _showPassword() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Function _fieldFocusChange(FocusNode currentFocus, FocusNode nextFocus) =>
      (String text) {
        trimWhitespaces();
        currentFocus.unfocus();
        FocusScope.of(context).requestFocus(nextFocus);
      };

  void _onChangedFormBuilder(Map<String, dynamic> changed) {
    setState(() {
      _isValid = _formKey.currentState.validate();
    });
  }

  void _submit() {
    setState(() {
      _isValid = _formKey.currentState.validate();
      _autovalidate = true;
    });
    if (_isValid) _createAccount();
  }

  void _createAccount() async {
    _emailFocus.unfocus();
    _passwordFocus.unfocus();
    showActivityDialog(
      context,
      label: CustomFlutterI18n.translate(context, 'RegulationView.loading'),
    );
    try {
      FirebaseUser user = await UserData().createUserWithEmailAndPassword(
          _emailController.text.trim(), _passwordController.text);
      await user.sendEmailVerification();
    } on PlatformException catch (error) {
      popPreviosAlert(context);
      showRegistrationError(context, error.code);
    }
  }

  void _onChangedAcceptRegulation(dynamic value) {
    setState(() {
      _acceptRegulation = value;
    });
  }

  void _goToRegulationView() {
    Navigator.of(context).pushNamed('/documents',
        arguments: NavigationArguments(pdfDoc: PdfDoc.Regulation));
  }

  void _goToPrivacy() {
    Navigator.of(context).pushNamed('/documents',
        arguments: NavigationArguments(pdfDoc: PdfDoc.Pravicy));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: StylesProvider.of(context).colors.scaffoldBackground,
      child: ListView(
        primary: false,
        shrinkWrap: true,
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: RegistrationFormView(
              acceptRegulation: _acceptRegulation,
              autovalidate: _autovalidate,
              enabled: true,
              formKey: _formKey,
              onPressRegulation: _goToRegulationView,
              onChangedAcceptRegulation: _onChangedAcceptRegulation,
              onChangedFormBuilder: _onChangedFormBuilder,
              textFields: _textFields,
              onPressPolicy: _goToPrivacy,
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 5),
            padding: EdgeInsets.symmetric(vertical: 30),
            child: SubmitButton(
              icon: null,
              onPress: _submit,
              height: 30,
              backgroundColor: StylesProvider.of(context).colors.primaryColor,
              text: CustomFlutterI18n.translate(
                context,
                'RegistrationView.submit',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
