import 'package:flutter/material.dart';
import 'package:app/widgets/custom_animated_button.dart';

import '../style_provider.dart';
import 'flutter_18n.dart';

/// ### Displays activity dialog
/// to dismiss use `Navigator.pop(context);`
void showActivityDialog(BuildContext context,
    {Widget child,
    String label,
    Widget labelWidget,
    double height,
    Function onClose,
    bool dismissible = false,
    bool showCloseButton = false,
    String closeButtonText}) {
  String loading = CustomFlutterI18n.translate(context, "loading");
  showDialog<void>(
    context: context,
    barrierDismissible: dismissible,
    builder: (BuildContext context) => WillPopScope(
      onWillPop: () async => dismissible,
      child: Dialog(
        backgroundColor:
            StylesProvider.of(context).colors.cardContainerBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              height: height ?? 180,
              margin: EdgeInsets.symmetric(horizontal: 50),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    child ??
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(
                              StylesProvider.of(context).colors.primaryColor),
                        ),
                    SizedBox(height: 15),
                    labelWidget ??
                        Text(
                          label ?? "${loading}...",
                          style: StylesProvider.of(context)
                              .fonts
                              .boldBlue
                              .copyWith(
                                fontSize: 15,
                              ),
                          textAlign: TextAlign.center,
                        )
                  ],
                ),
              ),
            ),
            if (showCloseButton)
              Padding(
                padding: const EdgeInsets.only(
                    left: 20.0, right: 20, top: 5, bottom: 15),
                child: CustomAnimatedButton(
                  pressEvent: onClose ?? Navigator.of(context).pop,
                  text: closeButtonText ??
                      CustomFlutterI18n.translate(context, 'close'),
                  color: StylesProvider.of(context).colors.primaryColor,
                ),
              )
          ],
        ),
      ),
    ),
  );
}
