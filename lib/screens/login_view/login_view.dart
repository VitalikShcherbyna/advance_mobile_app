import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:app/data/user_data.dart';
import 'package:app/models/user_model.dart';
import 'package:app/screens/login_view/widgets/login_errors.dart';
import 'package:app/screens/login_view/widgets/login_form_view.dart';
import 'package:app/screens/login_view/widgets/remid_me_password.dart';
import 'package:app/widgets/activity_indicator.dart';
import 'package:app/widgets/awesome_alert.dart';
import 'package:app/widgets/flutter_18n.dart';
import 'package:app/widgets/pop_previous_alert.dart';
import 'package:app/widgets/submit_button.dart';
import 'package:app/widgets/text_field_arg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../style_provider.dart';
import '../../typedef.dart';

class LogInView extends StatefulWidget {
  LogInView({
    Key key,
  }) : super(key: key);

  @override
  _LogInViewState createState() => _LogInViewState();
}

class _LogInViewState extends State<LogInView>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isValid = true;
  bool _autovalidate = false;
  bool _obscureText = true;
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  TextFields _textFields;

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
                  context, 'TextField.error.emailError'),
            )
          ],
          TextFieldArg(
              name: 'password',
              controller: _passwordController,
              showPassword: _showPassword,
              hintText: CustomFlutterI18n.translate(
                  context, 'RegistrationView.password'),
              focusNode: _passwordFocus,
              onFieldSubmitted: (_) => _submit(),
              obscureText: _obscureText): [
            FormBuilderValidators.required(
              errorText:
                  CustomFlutterI18n.translate(context, 'TextField.error.empty'),
            ),
          ],
        };
    SchedulerBinding.instance.addPostFrameCallback(_setUp);
  }

  void _showPassword() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _trimWhitespaces() {
    _emailController.value =
        TextEditingValue(text: _emailController.text.trim());
  }

  Function _fieldFocusChange(FocusNode currentFocus, FocusNode nextFocus) =>
      (String text) {
        _trimWhitespaces();
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
    if (_isValid) _login();
  }

  void _login() async {
    FocusScope.of(context).requestFocus(FocusNode());
    _startLoading();
    try {
      FirebaseUser user = await UserData().signInWithEmailAndPassword(
          _emailController.text.trim(), _passwordController.text);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('email', _emailController.text);
      if (user?.displayName == UserRole.MANAGER.toString() ||
          user?.displayName == UserRole.OWNER.toString()) {
        _stopLoading();
      }
    } on PlatformException catch (e) {
      _stopLoading();
      showLoginError(
        context,
        e.code,
        () => remindMePassword(
          context,
          _emailController,
          _sentPasswordToEmail,
        ),
      );
    } on Exception {
      _stopLoading();
      showAwesomeAlert(
        context,
        titleText: CustomFlutterI18n.translate(context, 'error'),
      );
    }
  }

  void _startLoading() {
    setState(() {
      showActivityDialog(
        context,
        label: CustomFlutterI18n.translate(context, 'LoginView.loading'),
      );
    });
  }

  void _stopLoading() {
    setState(() {
      popPreviosAlert(context);
    });
  }

  void _setUp(Object obj) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _emailController.text = prefs.getString('email');
  }

  void _signInWithGmail() async {
    try {
      await UserData().signInWithGmail(_startLoading);
    } on Exception {
      _stopLoading();
      showAwesomeAlert(
        context,
        titleText: CustomFlutterI18n.translate(context, 'error'),
      );
    }
  }

  void _signInWithFaceBook() async {
    try {
      await UserData().signInWithFaceBook(_startLoading, _stopLoading);
    } on PlatformException {
      _stopLoading();
      showAwesomeAlert(
        context,
        titleText: CustomFlutterI18n.translate(context, 'error'),
        messageText: CustomFlutterI18n.translate(
          context,
          'LoginView.tooManyRequests',
        ),
      );
    }
  }

  void _sentPasswordToEmail() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text);
      popPreviosAlert(context);
      showActivityDialog(
        context,
        child: Image.asset("assets/completed.png"),
        label: CustomFlutterI18n.translate(context, 'reset'),
      );
      Timer(Duration(seconds: 1), () {
        popPreviosAlert(context);
      });
    } on PlatformException catch (error) {
      popPreviosAlert(context);
      showAwesomeAlert(context,
          titleText: CustomFlutterI18n.translate(context, 'error'),
          messageText: error.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: StylesProvider.of(context).colors.scaffoldBackground,
      child: ListView(
        shrinkWrap: true,
        primary: false,
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: LogInFormView(
              signInWithFaceBook: _signInWithFaceBook,
              logInForm: true,
              remindMePassword: () => remindMePassword(
                  context, _emailController, _sentPasswordToEmail),
              autovalidate: _autovalidate,
              formKey: _formKey,
              textFields: _textFields,
              onChangedFormBuilder: _onChangedFormBuilder,
              signInWithGmail: _signInWithGmail,
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
              text: CustomFlutterI18n.translate(context, 'LoginView.submit'),
            ),
          ),
        ],
      ),
    );
  }
}
