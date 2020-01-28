import 'package:flutter/material.dart';

class StylesProvider extends InheritedWidget {
  StylesProvider(Widget child, this.sandwichCardTag, {Key key})
      : colors = _ProviderColors(),
        boxDecoration = _ProviderBoxDecoration(_ProviderColors()),
        fonts = _ProviderFonts(_ProviderColors()),
        super(key: key, child: child);
  final _ProviderColors colors;
  final _ProviderFonts fonts;
  final _ProviderBoxDecoration boxDecoration;
  final String sandwichCardTag;

  static StylesProvider of(BuildContext context) {
    return context.findAncestorWidgetOfExactType<StylesProvider>();
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return oldWidget != this;
  }
}

class _ProviderColors {
  final scaffoldBackground = Color(0xFFe8edf2);
  final careAdviserHeaderGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFF21455B),
      Color(0xFF102036),
    ],
  );
  final careGiverHeaderGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFF2AABA4),
      Color(0xFF75CBC7),
    ],
  );
  final startPagesBackground = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFF2AABA4),
      Color(0xFF75CBC7),
    ],
  );
  final cardContainerBackground = Colors.white;
  //Active checkboxs, some texts, send message button
  final primaryColor = Color(0xFF93c714);
  //Buttons color, some border button, downloading arrow, checkboxs
  final orange = Color(0xFFff7b44);
  //use this color for content text color
  final contentText = Color(0xFF21455B);

  //use this color for content text color inside disable buttons
  final lowOpacityContentText = Color(0xFF5B7585);

  //use this color for notification ring bell, remove button
  final red = Color(0xFFEF462F);
  final messageBackgroundColor = Color(0xFFf4f4f4);
  final blueAccent = Color(0xFF329af0);
  final mapMarker = Color(0xFFdd4b3e);

  final bookmarkColor = Color(0xFFff9d33);
  final disabledBookmark = Color(0xFFb6babe);
  final disableButton = Color(0xFFD3DCDF);
  final disablePreference = Color(0xFFacb3b5);
  final splashColor = Color(0xFFb0b0b0);
}

class _ProviderBoxDecoration {
  _ProviderBoxDecoration(
    _ProviderColors colors,
  )   : buttonBorderRadius = BorderRadius.circular(12),
        cards = BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(16),
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(color: Colors.black45, blurRadius: 8)
          ],
          border: Border.all(width: 1, color: colors.scaffoldBackground),
          color: colors.cardContainerBackground,
        ),
        border = Border.all(width: 1, color: colors.scaffoldBackground),
        currentMessageUser = BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(messageBorderRadius),
            bottomLeft: Radius.circular(messageBorderRadius),
          ),
        ),
        circleImage = BorderRadius.all(Radius.circular(26)),
        messageUser = BoxDecoration(
          color: colors.primaryColor,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(messageBorderRadius),
            bottomRight: Radius.circular(messageBorderRadius),
          ),
        ),
        deliverItem = BoxDecoration(
          color: colors.cardContainerBackground,
          boxShadow: <BoxShadow>[
            BoxShadow(color: Colors.black45, blurRadius: 2)
          ],
        );
  final BoxDecoration cards;
  final Border border;
  //MESSAGES
  static const double messageBorderRadius = 26;
  final BoxDecoration currentMessageUser;
  final BorderRadius buttonBorderRadius;
  final BoxDecoration messageUser;
  //MESSAGE_LIST_VIEW
  final BoxDecoration deliverItem;
  final BorderRadius circleImage;
}

class _ProviderFonts {
  _ProviderFonts(_ProviderColors colors)
      //BLUE COLOR
      : boldBlue = TextStyle(
          color: colors.contentText,
          fontSize: 12.0,
          fontFamily: 'Poppins Bold',
          letterSpacing: 0.5,
        ),
        normalBlue = TextStyle(
          color: colors.contentText,
          fontSize: 12.0,
          fontFamily: 'Poppins',
          letterSpacing: 0.5,
        ),
        lightBlue = TextStyle(
          color: colors.contentText,
          fontSize: 12.0,
          letterSpacing: 0.5,
          fontFamily: 'Poppins Light',
        ),
        thinBlue = TextStyle(
          color: colors.contentText,
          fontSize: 12.0,
          fontFamily: 'Poppins Thin',
          letterSpacing: 0.5,
        ),

        //LOW OPACITY BLUE COLOR
        boldBlueLowOpacity = TextStyle(
          color: colors.lowOpacityContentText,
          fontSize: 12.0,
          fontFamily: 'Poppins Bold',
          letterSpacing: 0.5,
        ),
        normalBlueLowOpacity = TextStyle(
          color: colors.lowOpacityContentText,
          fontSize: 12.0,
          fontFamily: 'Poppins',
          letterSpacing: 0.5,
        ),
        lightBlueLowOpacity = TextStyle(
          color: colors.lowOpacityContentText,
          fontSize: 12.0,
          fontFamily: 'Poppins Light',
          letterSpacing: 0.5,
        ),
        thinBlueLowOpacity = TextStyle(
          color: colors.lowOpacityContentText,
          fontSize: 12.0,
          fontFamily: 'Poppins Thin',
          letterSpacing: 0.5,
        ),

        //WHITE COLOR
        boldWhite = TextStyle(
          color: Colors.white,
          fontSize: 12.0,
          fontFamily: 'Poppins Bold',
          letterSpacing: 0.5,
        ),
        normalWhite = TextStyle(
          color: Colors.white,
          fontSize: 12.0,
          letterSpacing: 0.5,
          fontFamily: 'Poppins',
        ),
        lightWhite = TextStyle(
          color: Colors.white,
          fontSize: 12.0,
          fontFamily: 'Poppins Light',
          letterSpacing: 0.5,
        ),
        thinWhite = TextStyle(
          color: Colors.white,
          fontSize: 12.0,
          letterSpacing: 0.5,
          fontFamily: 'Poppins Thin',
        ),

        //LIGHT GREEN COLOR
        boldLightGreen = TextStyle(
          color: colors.primaryColor,
          fontSize: 12.0,
          letterSpacing: 0.5,
          fontFamily: 'Poppins Bold',
        ),
        normalLightGreen = TextStyle(
          color: colors.primaryColor,
          fontSize: 12.0,
          letterSpacing: 0.5,
          fontFamily: 'Poppins',
        ),
        lightLightGreen = TextStyle(
          color: colors.primaryColor,
          letterSpacing: 0.5,
          fontSize: 12.0,
          fontFamily: 'Poppins Light',
        ),
        thinLightGreen = TextStyle(
          color: colors.primaryColor,
          fontSize: 12.0,
          letterSpacing: 0.5,
          fontFamily: 'Poppins Thin',
        ),

        //Red COLOR
        boldRed = TextStyle(
          color: colors.red,
          fontSize: 12.0,
          letterSpacing: 0.5,
          fontFamily: 'Poppins Bold',
        ),
        normalRed = TextStyle(
          color: colors.red,
          fontSize: 12.0,
          letterSpacing: 0.5,
          fontFamily: 'Poppins',
        ),
        lightRed = TextStyle(
          color: colors.red,
          fontSize: 12.0,
          letterSpacing: 0.5,
          fontFamily: 'Poppins Light',
        ),
        thinRed = TextStyle(
          color: colors.red,
          letterSpacing: 0.5,
          fontSize: 12.0,
          fontFamily: 'Poppins Thin',
        ),
        boldText = TextStyle(
          fontSize: 19,
          fontFamily: 'Poppins Bold',
        );

  final TextStyle boldBlue;
  final TextStyle normalBlue;
  final TextStyle lightBlue;
  final TextStyle thinBlue;

  final TextStyle boldBlueLowOpacity;
  final TextStyle normalBlueLowOpacity;
  final TextStyle lightBlueLowOpacity;
  final TextStyle thinBlueLowOpacity;

  final TextStyle boldWhite;
  final TextStyle normalWhite;
  final TextStyle lightWhite;
  final TextStyle thinWhite;

  final TextStyle boldLightGreen;
  final TextStyle normalLightGreen;
  final TextStyle lightLightGreen;
  final TextStyle thinLightGreen;

  final TextStyle boldRed;
  final TextStyle normalRed;
  final TextStyle lightRed;
  final TextStyle thinRed;

  final TextStyle boldText;
}
