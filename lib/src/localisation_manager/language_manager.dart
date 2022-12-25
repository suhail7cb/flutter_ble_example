
import 'dart:convert';
import 'package:flutter/services.dart';

class LanguageManager {
  static final LanguageManager _instance = LanguageManager._internal();
  LanguageManager._internal();
  factory LanguageManager() {
    return _instance;
  }

  static Map<String, dynamic> _localisedValues = <String, dynamic>{};

  Future<Map<String, dynamic>> loadLanguage({required languageCode}) async {
    final String jsonContent = await rootBundle.loadString('assets/locales/$languageCode.json');
    _localisedValues = await json.decode(jsonContent);
    return _localisedValues;
  }

  String localize(String key){
    if(_localisedValues.isEmpty)
      return '';
    else
      return _localisedValues[key] ?? '$key';
  }
}