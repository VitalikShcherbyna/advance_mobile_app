import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:app/models/user_model.dart';
import 'package:app/screens/customer/location_view/google_maps.dart';
import 'package:app/screens/customer/location_view/widgets/firm_data.dart';
import 'package:app/screens/pdf_view/pdf_view.dart';
import 'package:app/screens/registration_view/registration_view.dart';
import 'package:app/screens/start_view/start_view.dart';
import 'package:app/widgets/disabled_account_view.dart';

enum PageAccess { PROFILE, HOME, OWN_PROFILE, SEARCH }

class NavigationArguments {
  const NavigationArguments({
    bool isProfile,
    this.user,
    bool canSkip,
    this.selectedFirmIndex,
    this.canPop,
    Marker marker,
    PdfDoc pdfDoc,
    ValueNotifier<bool> isNewMarker,
    this.isRefresh = false,
  })  : _isProfile = isProfile,
        _canSkip = canSkip,
        _pdfDoc = pdfDoc,
        _isNewMarker = isNewMarker,
        _marker = marker;

  final PdfDoc _pdfDoc;
  final bool _isProfile;
  final bool _canSkip;
  final bool isRefresh;
  final UserBase user;
  final bool canPop;
  final int selectedFirmIndex;
  final Marker _marker;
  final ValueNotifier<bool> _isNewMarker;

  bool get canSkip => _canSkip == null ? throw NullThrownError() : _canSkip;
  Marker get marker => _marker == null ? throw NullThrownError() : _marker;
  PdfDoc get pdfDoc => _pdfDoc == null ? throw NullThrownError() : _pdfDoc;
  bool get isProfile =>
      _isProfile == null ? throw NullThrownError() : _isProfile;
  ValueNotifier<bool> get isNewMarker =>
      _isNewMarker == null ? throw NullThrownError() : _isNewMarker;
}

Map<String, Widget Function(BuildContext)> routes = {
  '/': (context) => StartView(),
  '/disabledAccount': (context) => DisabledAccountView(),
  '/user/addFirmView': (context) => AddFirmView(
        marker:
            (ModalRoute.of(context).settings.arguments as NavigationArguments)
                .marker,
        user: (ModalRoute.of(context).settings.arguments as NavigationArguments)
            .user,
      ),
  '/user/googleMapsView': (context) {
    NavigationArguments args =
        ModalRoute.of(context).settings.arguments as NavigationArguments;
    return GoogleMaps(
      user: args.user,
      isRegistrationProcess: args.canPop,
    );
  },
  '/registrationView': (context) => RegistrationView(),
};

const String initialRoute = '/';

class MyCupertinoPageRoute extends CupertinoPageRoute<Route<dynamic>> {
  MyCupertinoPageRoute({
    @required WidgetBuilder builder,
    @required RouteSettings settings,
    bool fullscreenDialog,
  }) : super(
            builder: builder,
            settings: settings,
            fullscreenDialog: fullscreenDialog);

  @override
  Duration get transitionDuration => Duration(milliseconds: 790);
}

class PageRouteState extends StatefulWidget {
  const PageRouteState(
      {Key key, @required this.context, @required this.builder})
      : super(key: key);
  final BuildContext context;
  final WidgetBuilder builder;

  @override
  _AdditionalState createState() => _AdditionalState();
}

class _AdditionalState extends State<PageRouteState> {
  Widget child;

  @override
  void initState() {
    super.initState();
    child = widget.builder(widget.context);
  }

  @override
  Widget build(BuildContext context) => child;
}
