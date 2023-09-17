import 'package:flutter/widgets.dart';

abstract class TranslationService {
  Future<void> init({
    required List<Locale> supportedLocales,
  });
  Future<void> load(Locale locale);
  String get(String key);
}
