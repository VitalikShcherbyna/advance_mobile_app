import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart';
import 'package:intl/intl_standalone.dart';

class FlutterI18nDelegate extends LocalizationsDelegate<CustomFlutterI18n> {
  final bool useCountryCode;
  final String fallbackFile;
  final String path;
  static CustomFlutterI18n _currentTranslationObject;

  FlutterI18nDelegate(
      {this.useCountryCode = false,
      this.fallbackFile,
      this.path = "assets/flutter_i18n"});

  @override
  bool isSupported(final Locale locale) {
    return true;
  }

  @override
  Future<CustomFlutterI18n> load(final Locale locale) async {
    if (FlutterI18nDelegate._currentTranslationObject == null ||
        FlutterI18nDelegate._currentTranslationObject.locale != locale) {
      FlutterI18nDelegate._currentTranslationObject =
          CustomFlutterI18n(useCountryCode, fallbackFile, path);
      await FlutterI18nDelegate._currentTranslationObject.load(locale);
    }
    return FlutterI18nDelegate._currentTranslationObject;
  }

  @override
  bool shouldReload(final LocalizationsDelegate old) {
    return _currentTranslationObject == null ||
        !_currentTranslationObject.forcedLocale;
  }
}

class CustomFlutterI18n {
  static final RegExp _parameterRegexp = RegExp("{(.+)}");
  final bool _useCountryCode;
  final String _fallbackFile;
  final String _basePath;
  bool forcedLocale = false;

  Locale locale;

  Map<String, dynamic> decodedMap;
  //ignore: avoid_positional_boolean_parameters
  CustomFlutterI18n(this._useCountryCode, [this._fallbackFile, this._basePath]);

  Future<bool> load(Locale locale) async {
    try {
      await _loadCurrentTranslation(locale);
    } catch (e) {
      await _loadFallback();
    }
    return true;
  }

  Future _loadCurrentTranslation([final Locale locale]) async {
    this.locale = locale != null ? locale : await _findCurrentLocale();
    await _loadFile(_composeFileName());
  }

  Future _loadFallback() async {
    try {
      await _loadFile(_fallbackFile);
    } catch (e) {
      decodedMap = Map<String, dynamic>();
    }
  }

  Future _loadFile(final String fileName) async {
    var localeString = await rootBundle.loadString('$_basePath/$fileName.json');
    decodedMap = json.decode(localeString);
  }

  Future<Locale> _findCurrentLocale() async {
    final String systemLocale = await findSystemLocale();
    final List<String> systemLocaleSplitted = systemLocale.split("_");
    return Future(
        () => Locale(systemLocaleSplitted[0], systemLocaleSplitted[1]));
  }

  static String plural(final BuildContext context, final String translationKey,
      final int pluralValue) {
    final CustomFlutterI18n currentInstance = _retrieveCurrentInstance(context);
    final Map<String, dynamic> decodedSubMap =
        _calculateSubmap(currentInstance.decodedMap, translationKey);
    final String correctKey =
        _findCorrectKey(decodedSubMap, translationKey, pluralValue);
    final String parameterName =
        _findParameterName(decodedSubMap[correctKey.split(".").last]);
    return translate(context, correctKey,
        Map.fromIterables([parameterName], [pluralValue.toString()]));
  }

  static String _findCorrectKey(Map<String, dynamic> decodedSubMap,
      String translationKey, final int pluralValue) {
    final List<String> splittedKey = translationKey.split(".");
    translationKey = splittedKey.removeLast();
    List<int> possiblePluralValues = decodedSubMap.keys
        .where((mapKey) => mapKey.startsWith(translationKey))
        .where((mapKey) => mapKey.split("-").length == 2)
        .map((mapKey) => int.tryParse(mapKey.split("-")[1]))
        .where((mapKeyPluralValue) => mapKeyPluralValue != null)
        .where((mapKeyPluralValue) => mapKeyPluralValue <= pluralValue)
        .toList();
    possiblePluralValues.sort();
    final String pluralValues =
        possiblePluralValues.length > 0 ? possiblePluralValues.last : '';
    final String lastKeyPart = "$translationKey-$pluralValues";
    splittedKey.add(lastKeyPart);
    return splittedKey.join(".");
  }

  static Map<String, dynamic> _calculateSubmap(
      Map<String, dynamic> decodedMap, final String translationKey) {
    final List<String> translationKeySplitted = translationKey.split(".");
    translationKeySplitted.removeLast();
    translationKeySplitted.forEach((listKey) => decodedMap =
        decodedMap != null && decodedMap[listKey] != null
            ? decodedMap[listKey]
            : Map<String, dynamic>());
    return decodedMap;
  }

  static String _findParameterName(final String translation) {
    String parameterName = "";
    if (translation != null && _parameterRegexp.hasMatch(translation)) {
      final Match match = _parameterRegexp.firstMatch(translation);
      parameterName = match.groupCount > 0 ? match.group(1) : "";
    }
    return parameterName;
  }

  static Future refresh(
      final BuildContext context, final Locale forcedLocale) async {
    final CustomFlutterI18n currentInstance = _retrieveCurrentInstance(context);
    currentInstance.forcedLocale = true;
    await currentInstance._loadCurrentTranslation(forcedLocale);
  }

  static String translate(final BuildContext context, final String key,
      [final Map<String, String> translationParams]) {
    String translation = _translateWithKeyFallback(context, key);
    if (translationParams != null) {
      translation = _replaceParams(translation, translationParams);
    }
    return translation;
  }

  static Locale currentLocale(final BuildContext context) {
    return _retrieveCurrentInstance(context).locale;
  }

  static String _replaceParams(
      String translation, final Map<String, String> translationParams) {
    for (final String paramKey in translationParams.keys) {
      translation = translation.replaceAll(
          RegExp('{$paramKey}'), translationParams[paramKey]);
    }
    return translation;
  }

  static String _translateWithKeyFallback(
      final BuildContext context, final String key) {
    final Map<String, dynamic> decodedStrings =
        _retrieveCurrentInstance(context).decodedMap;
    String translation = _decodeFromMap(decodedStrings, key);
    if (translation == null) {
      print("**$key** not found");
      translation = key;
    }
    return translation;
  }

  static CustomFlutterI18n _retrieveCurrentInstance(BuildContext context) {
    return Localizations.of<CustomFlutterI18n>(context, CustomFlutterI18n);
  }

  static String _decodeFromMap(
      Map<String, dynamic> decodedStrings, final String key) {
    final Map<String, dynamic> subMap = _calculateSubmap(decodedStrings, key);
    final String lastKeyPart = key.split(".").last;
    return subMap[lastKeyPart];
  }

  String _composeFileName() {
    return "${locale.languageCode}${_composeCountryCode()}";
  }

  String _composeCountryCode() {
    String countryCode = "";
    if (_useCountryCode && locale.countryCode != null) {
      countryCode = "_${locale.countryCode}";
    }
    return countryCode;
  }
}
