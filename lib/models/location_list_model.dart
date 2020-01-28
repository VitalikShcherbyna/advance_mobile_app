import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LocationListModel {
  final DocumentReference supplierRef;
  final GeoPoint geoPoint;
  final String code;

  LocationListModel({
    @required this.geoPoint,
    @required this.code,
    @required this.supplierRef,
  });

  LocationListModel.fromMap(Map data)
      : geoPoint = data['geoPoint'],
        supplierRef = data['supplierID'],
        code = data['code'];

  @override
  String toString() => toMap().toString();

  Map<String, dynamic> toMap() => <String, dynamic>{
        "geoPoint": geoPoint,
        "supplierID": supplierRef,
        "code": code,
      };
}
