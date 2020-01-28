import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:app/data/user_data.dart';
import 'package:app/models/user_model.dart';
import 'package:app/widgets/activity_indicator.dart';
import 'package:app/widgets/awesome_alert.dart';
import 'package:app/widgets/flutter_18n.dart';
import 'package:app/widgets/pop_previous_alert.dart';
import 'package:app/widgets/submit_button.dart';
import 'package:app/widgets/text_field_arg.dart';
import 'package:provider/provider.dart';

import '../../../../routes.dart';
import '../../../../style_provider.dart';
import '../../../../typedef.dart';

class EmployeesQuantity {
  const EmployeesQuantity._internal(this._value, this._number);

  final String _value;
  final int _number;

  @override
  String toString() => '$_value';

  int toValue() => _number;

  static EmployeesQuantity getEmployeesQuantity(int quantity) {
    switch (quantity) {
      case 50:
        return EmployeesQuantity.LESS_50;
      case 150:
        return EmployeesQuantity.LESS_150;
      case 300:
        return EmployeesQuantity.LESS_300;
      case 400:
        return EmployeesQuantity.MORE_300;
      default:
        return null;
    }
  }

  static const EmployeesQuantity LESS_50 =
      const EmployeesQuantity._internal('less50', 50);
  static const EmployeesQuantity LESS_150 =
      const EmployeesQuantity._internal('less150', 150);
  static const EmployeesQuantity LESS_300 =
      const EmployeesQuantity._internal('less300', 300);
  static const EmployeesQuantity MORE_300 =
      const EmployeesQuantity._internal('more300', 400);
}

class AddFirmView extends StatefulWidget {
  const AddFirmView({
    Key key,
    @required this.marker,
    @required this.user,
  }) : super(key: key);
  final Marker marker;
  final UserModel user;

  @override
  _AddFirmViewState createState() => _AddFirmViewState();
}

class _AddFirmViewState extends State<AddFirmView> {
  final _formKey = GlobalKey<FormBuilderState>(debugLabel: '_AddFirmViewState');
  bool _isValid = true;
  bool _autovalidate = false;
  bool _isParking = false;
  DateTime _arrivalTime = DateTime.now();
  EmployeesQuantity _employeesQuantity = EmployeesQuantity.LESS_50;
  final FocusNode _firmNameFocus = FocusNode();
  final FocusNode _floorFocus = FocusNode();
  final TextEditingController _firmNameController = TextEditingController();
  final TextEditingController _floorController = TextEditingController();
  TextFields _textFields;
  EmployeesRadioButton _employeesRadio;

  @override
  void initState() {
    super.initState();
    if (widget.user?.work != null) {
      _firmNameController.text = widget.user.work.company;
      _floorController.text = widget.user.work.floor?.toString();
      _arrivalTime = widget.user.work.arrivingTime?.toDate() ?? DateTime.now();
      _isParking = widget.user.work.parking ?? false;
      _employeesQuantity =
          widget.user.work.employeesCount ?? EmployeesQuantity.LESS_50;
    }

    _employeesRadio = (BuildContext context) => [
          MapEntry(
            EmployeesQuantity.LESS_50,
            CustomFlutterI18n.translate(
                context, 'AddFirmView.${EmployeesQuantity.LESS_50}'),
          ),
          MapEntry(
            EmployeesQuantity.LESS_150,
            CustomFlutterI18n.translate(
                context, 'AddFirmView.${EmployeesQuantity.LESS_150}'),
          ),
          MapEntry(
            EmployeesQuantity.LESS_300,
            CustomFlutterI18n.translate(
                context, 'AddFirmView.${EmployeesQuantity.LESS_300}'),
          ),
          MapEntry(
            EmployeesQuantity.MORE_300,
            CustomFlutterI18n.translate(
                context, 'AddFirmView.${EmployeesQuantity.MORE_300}'),
          ),
        ];
    _textFields = (BuildContext context) => {
          TextFieldArg(
              name: 'firmName',
              controller: _firmNameController,
              keyboardType: TextInputType.text,
              hintText: CustomFlutterI18n.translate(
                  context, 'AddFirmView.hintFirmName'),
              focusNode: _firmNameFocus,
              onFieldSubmitted:
                  _fieldFocusChange(_firmNameFocus, _floorFocus)): [
            FormBuilderValidators.required(
              errorText:
                  CustomFlutterI18n.translate(context, 'TextField.error.empty'),
            ),
          ],
          TextFieldArg(
            name: 'floorPoint',
            controller: _floorController,
            keyboardType: TextInputType.number,
            hintText: CustomFlutterI18n.translate(
                context, 'AddFirmView.hintFirmFloor'),
            focusNode: _floorFocus,
            onFieldSubmitted: (_) => _submit(),
          ): [
            FormBuilderValidators.required(
              errorText:
                  CustomFlutterI18n.translate(context, 'TextField.error.empty'),
            ),
          ],
        };
  }

  void _trimWhitespaces() {
    _firmNameController.value =
        TextEditingValue(text: _firmNameController.text.trim());
  }

  Function _fieldFocusChange(FocusNode currentFocus, FocusNode nextFocus) =>
      (String text) {
        _trimWhitespaces();
        currentFocus.unfocus();
        FocusScope.of(context).requestFocus(nextFocus);
      };

  void _onChangedFormBuilder(Map<String, dynamic> changed) {
    setState(() {
      _isValid = _formKey.currentState.validate();
    });
  }

  void _onParkingChanged(dynamic value) {
    setState(() {
      _isParking = value;
    });
  }

  void _onEmployeesChanged(EmployeesQuantity employeesQuantity) {
    setState(() {
      _employeesQuantity = employeesQuantity;
    });
  }

  void _submit() {
    setState(() {
      _isValid = _formKey.currentState.validate();
      _autovalidate = true;
    });
    if (_isValid) _addLocation();
    ;
  }

  Future<void> _setUserLocation() async {
    try {
      UserModel user = Provider.of<UserBase>(context) as UserModel;
      user.work.company = _firmNameController.text;
      user.work.floor = int.tryParse(_floorController.text);
      user.work.employeesCount = _employeesQuantity;
      user.work.parking = _isParking;
      user.work.arrivingTime = Timestamp.fromDate(_arrivalTime);

      popPreviosAlert(context);
      Timer(Duration(seconds: 1), () {
        Navigator.of(context).pushNamed(
          '/user/preferences',
          arguments: NavigationArguments(canPop: false),
        );
      });
    } catch (e) {
      showAwesomeAlert(
        context,
        titleText: CustomFlutterI18n.translate(context, 'error'),
      );
    }
  }

  Future<void> _updateLocationForExistingUser() async {
    try {
      UserModel user = Provider.of<UserBase>(context) as UserModel;
      user.work.company = _firmNameController.text;
      user.work.floor = int.tryParse(_floorController.text);
      user.work.employeesCount = _employeesQuantity;
      user.work.parking = _isParking;
      user.work.arrivingTime = Timestamp.fromDate(_arrivalTime);
      await UserData().refetchUser();
      popPreviosAlert(context);
      showActivityDialog(
        context,
        child: Image.asset("assets/completed.png"),
        label: CustomFlutterI18n.translate(context, 'done'),
      );
      Timer(Duration(seconds: 1), () {
        popPreviosAlert(context);
        popPreviosAlert(context);
      });
    } catch (e) {
      showAwesomeAlert(
        context,
        titleText: CustomFlutterI18n.translate(context, 'error'),
      );
    }
  }

  void _onChangedArrivalTime(DateTime arrivalTime) {
    setState(() {
      _arrivalTime = arrivalTime;
    });
  }

  Future<void> _addLocation() async {
    showActivityDialog(context);
    if (widget.user == null) {
      await _setUserLocation();
    } else {
      await _updateLocationForExistingUser();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StylesProvider.of(context).colors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: StylesProvider.of(context).colors.primaryColor,
        title: Text(
          CustomFlutterI18n.translate(context, 'GoogleMapsView.firm'),
          style: StylesProvider.of(context)
              .fonts
              .normalWhite
              .copyWith(fontSize: 22),
        ),
      ),
      body: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: SingleChildScrollView(
          child: Container(
            color: StylesProvider.of(context).colors.scaffoldBackground,
            child: Container(
              margin: EdgeInsets.only(left: 15, right: 15, top: 15),
              child: Column(
                children: <Widget>[
                  FormBuilder(
                    autovalidate: _autovalidate,
                    onChanged: _autovalidate ? _onChangedFormBuilder : null,
                    key: _formKey,
                    child: Container(
                      decoration:
                          StylesProvider.of(context).boxDecoration.cards,
                      padding: EdgeInsets.symmetric(
                        horizontal: 18,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ..._textFields(context)
                              .entries
                              .map<Widget>(
                                (MapEntry<TextFieldArg, List> map) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: FormTextField(
                                    textFieldArg: map.key,
                                    validators: map.value,
                                  ),
                                ),
                              )
                              .toList(),
                          //ARRIVAL TIME
                          Container(
                            margin: EdgeInsets.only(top: 15),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              CustomFlutterI18n.translate(
                                      context, 'AddFirmView.arrivingTime')
                                  .toUpperCase(),
                              style:
                                  StylesProvider.of(context).fonts.normalBlue,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Theme(
                              child: FormBuilderDateTimePicker(
                                initialValue: _arrivalTime,
                                resetIcon: null,
                                attribute: "date",
                                decoration: inputDecoration(context).copyWith(
                                  hintText: CustomFlutterI18n.translate(
                                      context, 'AddFirmView.addArrivingTime'),
                                  hintStyle: StylesProvider.of(context)
                                      .fonts
                                      .normalBlueLowOpacity
                                      .copyWith(fontSize: 14),
                                ),
                                style: StylesProvider.of(context)
                                    .fonts
                                    .normalBlue
                                    .copyWith(fontSize: 14),
                                onChanged: _onChangedArrivalTime,
                                initialTime: TimeOfDay.now(),
                                inputType: InputType.time,
                                format: DateFormat("hh:mm"),
                              ),
                              data: ThemeData(
                                primaryColor: StylesProvider.of(context)
                                    .colors
                                    .primaryColor,
                                accentColor: StylesProvider.of(context)
                                    .colors
                                    .primaryColor,
                              ),
                            ),
                          ),
                          //PARKING
                          FormBuilderCheckbox(
                            leadingInput: true,
                            initialValue: _isParking,
                            decoration:
                                InputDecoration(border: InputBorder.none),
                            activeColor:
                                StylesProvider.of(context).colors.primaryColor,
                            attribute: 'accept_terms',
                            onChanged: _onParkingChanged,
                            label: Text(
                              CustomFlutterI18n.translate(
                                  context, 'AddFirmView.parking'),
                              style: StylesProvider.of(context)
                                  .fonts
                                  .boldBlue
                                  .copyWith(fontSize: 17),
                            ),
                          ),
                          //EMPLOYEES
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              CustomFlutterI18n.translate(
                                      context, 'AddFirmView.employeesQuantity')
                                  .toUpperCase(),
                              style:
                                  StylesProvider.of(context).fonts.normalBlue,
                            ),
                          ),
                          Wrap(
                            direction: Axis.horizontal,
                            spacing: 10,
                            alignment: WrapAlignment.center,
                            children: _employeesRadio(context)
                                .map(
                                  (MapEntry<EmployeesQuantity, String>
                                          employeeRadio) =>
                                      Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Radio<EmployeesQuantity>(
                                        value: employeeRadio.key,
                                        groupValue: _employeesQuantity,
                                        onChanged: _onEmployeesChanged,
                                        activeColor: StylesProvider.of(context)
                                            .colors
                                            .primaryColor,
                                      ),
                                      Text(
                                        employeeRadio.value,
                                        style: StylesProvider.of(context)
                                            .fonts
                                            .normalBlue
                                            .copyWith(fontSize: 17),
                                      ),
                                    ],
                                  ),
                                )
                                .toList(),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 30),
                    child: SubmitButton(
                      icon: null,
                      onPress: _submit,
                      height: 30,
                      backgroundColor:
                          StylesProvider.of(context).colors.primaryColor,
                      text: CustomFlutterI18n.translate(
                        context,
                        widget.user != null &&
                                widget.user?.work?.company != null
                            ? 'edit'
                            : 'add',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
