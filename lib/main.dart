import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:app/routes.dart';
import 'package:app/style_provider.dart';
import 'package:app/widgets/flutter_18n.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/user_data.dart';
import 'models/user_model.dart';

const I18N_FALLBACK_FILE = 'pl';
const I18N_PATH = 'assets/flutter_i18n';

void main() async {
  final FlutterI18nDelegate flutterI18nDelegate = FlutterI18nDelegate(
      useCountryCode: false, fallbackFile: I18N_FALLBACK_FILE, path: I18N_PATH);
  runApp(SplashScreen());
  flutterI18nDelegate.load(null).then((_) {
    runApp(StartUp(flutterI18nDelegate));
  });
}

class StartUp extends StatefulWidget {
  final FlutterI18nDelegate flutterI18nDelegate;
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  static void setLocale(BuildContext context, Locale locale) {
    _StartUpState startUpView =
        context.findRootAncestorStateOfType<_StartUpState>();
    if (startUpView != null) {
      startUpView.setLocale(locale);
    }
  }

  static Locale getLocale(BuildContext context) {
    _StartUpState startUpView =
        context.findRootAncestorStateOfType<_StartUpState>();
    return startUpView._locale;
  }

  StartUp(this.flutterI18nDelegate);

  @override
  _StartUpState createState() => _StartUpState();
}

class _StartUpState extends State<StartUp> {
  Locale _locale;
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback(_setUpLocale);
  }

  Future<void> _setUpLocale(Object object) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String languageCode = await prefs.getString('languageCode');

    if (languageCode != null) {
      setLocale(Locale(languageCode));
    }
  }

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      child: StylesProvider(
        MaterialApp(
          localizationsDelegates: <LocalizationsDelegate<dynamic>>[
            //Fix bug on ios when add localizations in info.plist
            FallbackCupertinoLocalisationsDelegate(),
            widget.flutterI18nDelegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate
          ],
          locale: _locale,
          supportedLocales: [
            const Locale('pl'),
            const Locale('en'),
          ],
          builder: (context, child) => MediaQuery(
              data:
                  MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
              child: child),
          debugShowCheckedModeBanner: false,
          routes: routes,
        ),
        'profile',
      ),
      providers: <SingleChildCloneableWidget>[
        StreamProvider<UserBase>.value(
          value: UserData().user,
        ),
      ],
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFe8edf2),
    );
  }
}

class FallbackCupertinoLocalisationsDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const FallbackCupertinoLocalisationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<CupertinoLocalizations> load(Locale locale) =>
      DefaultCupertinoLocalizations.load(locale);

  @override
  bool shouldReload(FallbackCupertinoLocalisationsDelegate old) => false;
}
