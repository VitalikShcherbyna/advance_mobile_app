import 'package:flutter/material.dart';

class PlaceModel {
  final String name;
  final String address;
  final String city;
  final int floor;

  PlaceModel({
    @required this.name,
    @required this.address,
    @required this.city,
    @required this.floor,
  });

  PlaceModel.fromMap(Map data)
      : name = data['name'],
        address = data['address'],
        city = data['city'],
        floor =
            data["floor"] is int ? int.parse(data["floor"].toString()) : null;

  Map<String, dynamic> toMap() => <String, dynamic>{
        "name": name,
        "address": address,
        "city": city,
        "floor": floor,
      };
}
