import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:app/screens/customer/location_view/widgets/firm_data.dart';
import 'package:app/widgets/text_field_arg.dart';

///CAROUSEL
typedef CarouselBuilder = Widget Function(
    BuildContext context, Animation<Decoration> animation);

typedef CallbackFunction = void Function();

///ANNIMATED LIST
typedef InsertItem<T> = void Function(T item);
typedef ItemBuilderCallback = Widget Function(
    BuildContext context,
    CallbackFunction removeItem,
    InsertItem insertItem,
    Animation<double> animation);
typedef ItemRemoveCallback = Widget Function(
    BuildContext context, Animation<double> animation);

typedef SentString = void Function(String);

///FORM VIEW
typedef Validators = String Function(dynamic);
typedef OnChanged = void Function(dynamic);
typedef FieldSubmitted = void Function(String);

///Registration View
typedef OnChangedFormBuilder = void Function(Map<String, dynamic>);

//Menu VIew
typedef RefetchFunction = Future<void> Function();

///LOGIN
typedef TextFields = Map<TextFieldArg, List<String Function(dynamic)>> Function(
    BuildContext);

//AddFirm
typedef EmployeesRadioButton = List<MapEntry<EmployeesQuantity, String>>
    Function(BuildContext);

typedef CallBackWithContext = void Function(BuildContext);
typedef BoolCallback = void Function(bool);
typedef DoubleCallback = void Function(double);

typedef FutureBoolFunction = Future<bool> Function();

double get bottomListPadding => Device.get().isIphoneX ? 40.0 : 10.0;
