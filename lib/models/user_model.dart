import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import 'package:app/models/work_model.dart';

class UserRole {
  const UserRole._internal(this._value);

  final dynamic _value;

  @override
  String toString() => '$_value';

  static const UserRole CUSTOMER = const UserRole._internal('customer');
  static const UserRole DELIVER = const UserRole._internal('deliver');
  static const UserRole OWNER = const UserRole._internal('owner');
  static const UserRole MANAGER = const UserRole._internal('manager');
  static const UserRole NONE = const UserRole._internal('none');
}

abstract class UserBase {
  final FirebaseUser userInfo;
  UserRole userRole;
  bool isActive;
  String notificationToken;

  UserBase({
    @required this.userInfo,
    @required this.userRole,
    @required this.isActive,
    @required this.notificationToken,
  });
}

UserRole getUserRole(String role) {
  switch (role) {
    case 'customer':
      return UserRole.CUSTOMER;
    case 'deliver':
      return UserRole.DELIVER;
    default:
      return UserRole.NONE;
  }
}

class UserModel extends UserBase {
  final WorkModel work;
  final bool ordersAvailable;
  String email;
  String phone;
  String languageCode;
  String displayName;
  bool betaUser;

  UserModel({
    @required this.work,
    @required this.email,
    @required this.phone,
    @required this.displayName,
    @required this.languageCode,
    @required this.ordersAvailable,
  });

  UserModel.fromMap(
    Map data,
    FirebaseUser user,
  )   : work = WorkModel.fromMap(data != null ? data['work'] : null),
        displayName = data != null ? data['displayName'] : null,
        betaUser = data != null ? data['betaUser'] : null,
        email = data != null ? data['email'] : null,
        phone = data != null ? data['phone'] : null,
        languageCode = data != null ? data['languageCode'] : null,
        ordersAvailable = data != null ? data['ordersAvailable'] ?? true : true,
        super(
            userInfo: user,
            notificationToken: data != null ? data['notificationToken'] : null,
            userRole: data != null ? getUserRole(data['role']) : null,
            isActive: data != null ? data['isActive'] : true);

  Map<String, dynamic> toMap() => <String, dynamic>{
        "displayName": displayName,
        "email": email,
        "phone": phone,
        "ordersAvailable": ordersAvailable,
        "languageCode": languageCode,
        "work": work?.toMap(),
        "role": userRole.toString(),
        "isActive": isActive,
      };

  Map<String, dynamic> toCopy() => <String, dynamic>{
        "displayName": displayName,
        "email": email,
        "phone": phone,
        "betaUser": betaUser,
        "ordersAvailable": ordersAvailable,
        "languageCode": languageCode,
        "work": work?.toMap(),
        "role": userRole.toString(),
        "isActive": isActive,
      };
}
