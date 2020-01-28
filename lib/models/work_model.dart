import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:app/models/company_model.dart';
import 'package:app/screens/customer/location_view/widgets/firm_data.dart';

class WorkModel {
  String company;
  GeoPoint geoPoint;
  int floor;
  dynamic firmRequests;
  List<DocumentReference> buyOnlineRequest;
  List<CompanyModel> companies;
  bool parking;
  Timestamp arrivingTime;
  EmployeesQuantity employeesCount;

  WorkModel({
    @required this.company,
    @required this.geoPoint,
    @required this.floor,
    @required this.companies,
    @required this.firmRequests,
    @required this.parking,
    @required this.arrivingTime,
    @required this.employeesCount,
    @required this.buyOnlineRequest,
  });

  WorkModel.fromMap(
    Map data,
  )   : company = data != null ? data['company'] : null,
        geoPoint = data != null ? data['geoPoint'] : null,
        parking = data != null ? data['parking'] : null,
        buyOnlineRequest = data != null
            ? (data['buyOnlineRequest'] as List<dynamic>)
                ?.cast<DocumentReference>()
            : null,
        arrivingTime = data != null ? data['arrivingTime'] : null,
        employeesCount = data != null && data['employeesCount'] != null
            ? EmployeesQuantity.getEmployeesQuantity(data['employeesCount'])
            : null,
        firmRequests = data != null ? data['firmRequests'] : null,
        floor = data != null ? data['floor'] : null;

  Map<String, dynamic> toMap() => <String, dynamic>{
        "company": company,
        "firmRequests": firmRequests,
        "floor": floor,
        "geoPoint": geoPoint,
        "parking": parking,
        "buyOnlineRequest": buyOnlineRequest,
        "arrivingTime": arrivingTime,
        "employeesCount": employeesCount?.toValue(),
      };
}
