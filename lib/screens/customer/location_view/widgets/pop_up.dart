import 'package:flutter/material.dart';
import 'package:app/widgets/flutter_18n.dart';

import '../../../../style_provider.dart';

class InformaitonPopup extends StatelessWidget {
  const InformaitonPopup({
    Key key,
    @required this.closePopup,
    @required this.canPop,
    @required this.instructionInfo,
  }) : super(key: key);
  final Function closePopup;
  final bool canPop;
  final bool instructionInfo;

  String _getAlertInfo(BuildContext context) {
    if (canPop || instructionInfo) {
      return CustomFlutterI18n.translate(
          context, 'GoogleMapsView.pressAndHold');
    } else {
      return CustomFlutterI18n.translate(
          context, 'GoogleMapsView.shareLocation');
    }
  }

  @override
  Widget build(BuildContext context) {
    String infoAlert = _getAlertInfo(context);
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        child: AlertDialog(
          actions: <Widget>[
            FlatButton(
              child: Text(
                CustomFlutterI18n.translate(context, 'ok'),
                style: StylesProvider.of(context).fonts.boldText,
              ),
              onPressed: closePopup,
            )
          ],
          content: Text(
            infoAlert,
            style: StylesProvider.of(context)
                .fonts
                .lightBlue
                .copyWith(fontSize: 25),
          ),
        ),
      ),
    );
  }
}
