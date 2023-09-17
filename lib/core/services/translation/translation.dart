import 'dart:convert';
import 'dart:ui';

import 'package:flutter/services.dart';

import '../../protocols/protocols.dart';

class DefaultTranslationService implements TranslationService {
  final List<Locale> _supportedLocales = [];

  final Map<String, dynamic> _translations = {};

  @override
  String get(String key) {
    if (_translations.containsKey(key)) {
      return _translations[key]!;
    }

    return key;
  }

  @override
  Future<void> init({
    required List<Locale> supportedLocales,
  }) async {
    _supportedLocales.addAll(supportedLocales);
  }

  @override
  Future<void> load(Locale locale) async {
    if (_supportedLocales.contains(locale)) {
      final translations =
          await rootBundle.loadStructuredData<Map<String, dynamic>>(
        "assets/translations/${locale.languageCode}.json",
        (source) async => await jsonDecode(source),
      );
      _translations
        ..clear()
        ..addAll(translations);
      return;
    }

    _translations
      ..clear()
      ..addAll(
        await rootBundle.loadStructuredData(
          "assets/translations/${_supportedLocales.first.languageCode}.json",
          (source) async => await jsonDecode(source),
        ),
      );
  }
}
