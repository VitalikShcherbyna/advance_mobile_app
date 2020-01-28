import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app/style_provider.dart';

class SubmitButton extends StatelessWidget {
  const SubmitButton({
    Key key,
    @required this.onPress,
    @required this.text,
    @required this.icon,
    this.loading = false,
    this.paddingInsideButton = 18,
    this.height,
    this.textSize = 20,
    this.backgroundColor = Colors.white,
    this.textWidget,
  }) : super(key: key);
  final Function onPress;
  final String text;
  final Widget textWidget;
  final double height;
  final Widget icon;
  final bool loading;
  final double textSize;
  final Color backgroundColor;
  final double paddingInsideButton;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius:
              StylesProvider.of(context).boxDecoration.buttonBorderRadius,
          boxShadow: <BoxShadow>[
            BoxShadow(blurRadius: 6, spreadRadius: 1, color: Colors.black26)
          ]),
      child: FlatButton(
        padding: EdgeInsets.all(paddingInsideButton),
        color: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius:
              StylesProvider.of(context).boxDecoration.buttonBorderRadius,
        ),
        child: Row(
          children: <Widget>[
            if (icon != null)
              Expanded(
                flex: 1,
                child: icon,
              ),
            if (text != null)
              Expanded(
                flex: 4,
                child: Container(
                  height: height,
                  alignment: Alignment.center,
                  child: loading
                      ? Transform.scale(
                          child: CupertinoActivityIndicator(),
                          scale: 1.5,
                        )
                      : textWidget ??
                          Text(
                            text,
                            style: StylesProvider.of(context)
                                .fonts
                                .normalWhite
                                .copyWith(fontSize: textSize),
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                ),
              )
          ],
        ),
        onPressed: loading ? () {} : onPress,
      ),
    );
  }
}
