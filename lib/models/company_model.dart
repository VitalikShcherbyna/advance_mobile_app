import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:app/widgets/get_id_from_refrence.dart';

class CompanyModel {
  final String email;
  final bool isActive;
  final String logo;
  final String name;
  final String phone;
  final DocumentReference companyRef;

  CompanyModel({
    @required this.email,
    @required this.isActive,
    @required this.logo,
    @required this.name,
    @required this.phone,
    @required this.companyRef,
  });

  CompanyModel.fromMap(
    Map data,
    this.companyRef,
  )   : email = data['email'],
        isActive = data['isActive'],
        logo = data['logo'],
        name = data['name'],
        phone = data['phone'];

  Map<String, dynamic> toMap({bool fullData = true}) => fullData
      ? <String, dynamic>{
          "email": email,
          "isActive": isActive,
          "logo": logo,
          "name": name,
          "phone": phone,
        }
      : <String, dynamic>{
          "logo": logo,
          "name": name,
        };

  static int sortByCompanies(CompanyModel a, CompanyModel b,
      {List<CompanyModel> companies = const <CompanyModel>[]}) {
    if (companies?.firstWhere(
            (CompanyModel company) =>
                getIdFromReference(company.companyRef) ==
                getIdFromReference(a.companyRef),
            orElse: () => null) !=
        null) {
      return -1;
    } else if (companies?.firstWhere(
            (CompanyModel company) =>
                getIdFromReference(company.companyRef) ==
                getIdFromReference(b.companyRef),
            orElse: () => null) !=
        null) {
      return 1;
    } else {
      return 0;
    }
  }
}
