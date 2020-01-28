import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:app/models/user_model.dart';
import 'package:app/routes.dart';
import 'package:app/screens/customer/location_view/widgets/pop_up.dart';
import 'package:app/style_provider.dart';
import 'package:app/widgets/awesome_alert.dart';
import 'package:app/widgets/flutter_18n.dart';
import 'package:app/widgets/open_setting_alert.dart';
import 'package:permission_handler/permission_handler.dart';

//Lodz position
const LatLng INIT_CAM_POS = LatLng(51.760911, 19.456810);

class GoogleMaps extends StatefulWidget {
  const GoogleMaps(
      {Key key, @required this.user, @required this.isRegistrationProcess})
      : super(key: key);
  final UserModel user;
  final bool isRegistrationProcess;

  @override
  _GoogleMapsState createState() => _GoogleMapsState();
}

class _GoogleMapsState extends State<GoogleMaps> {
  GoogleMapController _mapController;
  final ValueNotifier<Set<Marker>> _markers =
      ValueNotifier<Set<Marker>>(<Marker>{});
  final ValueNotifier<bool> _showAlertInfo = ValueNotifier<bool>(true);
  bool _instructionInfo = false;

  @override
  void initState() {
    super.initState();
    if (widget.user != null && widget.user.work.geoPoint != null) {
      _markers.value = <Marker>{
        Marker(
          infoWindow: InfoWindow(title: widget.user.work.company),
          position: LatLng(widget.user.work.geoPoint.latitude,
              widget.user.work.geoPoint.longitude),
          markerId: MarkerId(widget.user.userInfo.uid),
          icon: BitmapDescriptor.defaultMarker,
        ),
      };
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _mapController = controller;
    });
  }

  Future<void> _onLongPress(LatLng position) async {
    _markers.value = <Marker>{
      Marker(
        position: position,
        markerId: MarkerId(position.latitude.toString()),
        icon: BitmapDescriptor.defaultMarker,
      ),
    };
  }

  Future<LocationData> _getUserLocation() async {
    try {
      Location location = Location();
      Map<PermissionGroup, PermissionStatus> permissionStatus =
          await PermissionHandler().requestPermissions(
        <PermissionGroup>[PermissionGroup.locationWhenInUse],
      );
      if (permissionStatus.values.first == PermissionStatus.granted) {
        var locationData = await location.getLocation();
        _onLongPress(LatLng(locationData.latitude, locationData.longitude));
        if (_mapController != null) {
          await _mapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(locationData.latitude, locationData.longitude),
                zoom: 18,
              ),
            ),
          );
        }
      } else {
        openLocationSettingsAlert(context);
      }
    } on Exception {
      showAwesomeAlert(
        context,
        titleText: CustomFlutterI18n.translate(context, 'error'),
      );
    }
    return null;
  }

  void _addFirmName() {
    if (_markers.value.isNotEmpty) {
      Navigator.of(context).pushNamed(
        '/user/addFirmView',
        arguments: NavigationArguments(
            marker: _markers.value.first, user: widget.user),
      );
    } else {
      _instructionInfo = true;
      _showAlertInfo.value = true;
    }
  }

  void _closePopup() {
    _showAlertInfo.value = false;
  }

  @override
  Widget build(BuildContext context) {
    bool isCompanyExist =
        widget.user != null && widget.user?.work?.company != null;
    String addEditFirm = CustomFlutterI18n.translate(
        context, 'GoogleMapsView.${isCompanyExist ? 'editFirm' : 'addFirm'}');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: StylesProvider.of(context).colors.primaryColor,
        title: Text(
          CustomFlutterI18n.translate(context, 'GoogleMapsView.firmLocation'),
          style: StylesProvider.of(context)
              .fonts
              .normalWhite
              .copyWith(fontSize: 22),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: FloatingActionButton(
              heroTag: 'Location',
              onPressed: _getUserLocation,
              child: Icon(Icons.gps_fixed),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: FloatingActionButton.extended(
                heroTag: 'Add',
                shape: RoundedRectangleBorder(
                    borderRadius: StylesProvider.of(context)
                        .boxDecoration
                        .buttonBorderRadius),
                onPressed: _addFirmName,
                icon: Icon(isCompanyExist ? Icons.edit : Icons.add),
                backgroundColor: StylesProvider.of(context).colors.primaryColor,
                label: Text(
                  addEditFirm,
                )),
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          ValueListenableBuilder<Set<Marker>>(
            builder: (BuildContext context, Set<Marker> value, Widget child) {
              return GoogleMap(
                initialCameraPosition: CameraPosition(
                    target: widget.user?.work?.geoPoint != null
                        ? LatLng(widget.user.work.geoPoint.latitude,
                            widget.user.work.geoPoint.longitude)
                        : INIT_CAM_POS,
                    zoom: 14),
                onMapCreated: _onMapCreated,
                myLocationEnabled: false,
                myLocationButtonEnabled: false,
                onLongPress: _onLongPress,
                mapType: MapType.normal,
                mapToolbarEnabled: true,
                markers: value,
              );
            },
            valueListenable: _markers,
          ),
          ValueListenableBuilder<bool>(
            valueListenable: _showAlertInfo,
            builder: (BuildContext context, bool value, Widget child) {
              return value
                  ? InformaitonPopup(
                      instructionInfo: _instructionInfo,
                      closePopup: _closePopup,
                      canPop: widget.isRegistrationProcess,
                    )
                  : IgnorePointer(
                      ignoring: true,
                    );
            },
          ),
        ],
      ),
    );
  }
}
