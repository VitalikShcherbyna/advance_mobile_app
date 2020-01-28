import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:app/data/user_data.dart';
import 'package:app/style_provider.dart';
import 'package:app/widgets/push_and_clean.dart';

import '../routes.dart';
import 'flutter_18n.dart';

class DisabledAccountView extends StatelessWidget {
  const DisabledAccountView({Key key}) : super(key: key);
  Future<void> _logout(BuildContext context) async {
    await UserData().signOut();
    pushRouteAndClean(context, initialRoute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StylesProvider.of(context).colors.scaffoldBackground,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset('assets/warning.png'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 8),
            child: Text(
              CustomFlutterI18n.translate(
                  context, 'DisabledAccountView.yourAccountDisabled'),
              style: StylesProvider.of(context)
                  .fonts
                  .boldBlue
                  .copyWith(fontSize: 22),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FlatButton(
              padding: EdgeInsets.all(15),
              disabledColor: StylesProvider.of(context).colors.disableButton,
              color: StylesProvider.of(context).colors.primaryColor,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    FontAwesomeIcons.signOutAlt,
                    color: StylesProvider.of(context)
                        .colors
                        .cardContainerBackground,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Text(
                      CustomFlutterI18n.translate(
                          context, 'ProfileView.logout'),
                      style: StylesProvider.of(context)
                          .fonts
                          .normalWhite
                          .copyWith(fontSize: 22),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              onPressed: () => _logout(context),
            ),
          )
        ],
      ),
    );
  }
}
