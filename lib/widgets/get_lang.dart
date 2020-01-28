import 'package:flutter/material.dart';

import '../main.dart';

String getLanguage(BuildContext context, String defaultLang, String enLang) {
  bool enLangExist = enLang?.isNotEmpty ?? false;
  Locale locale = StartUp.getLocale(context) ?? Localizations.localeOf(context);
  return locale.languageCode != 'pl' && enLangExist ? enLang : defaultLang;
}
