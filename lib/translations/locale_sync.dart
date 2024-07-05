import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:locale_sync/locale_sync.dart';

import 'translations.dart';

abstract class LocaleSync {
  static late String _token;
  static late String _repositoryId;
  static late Map<String, dynamic> _data;
  static late LocaleSyncStorage _storage;

  static setup({
    required String apiToken,
    required String repositoryId,
  }) async {
    _token = apiToken;
    _repositoryId = repositoryId;
    await Hive.initFlutter();
    _storage = LocaleSyncStorage(box: await Hive.openBox("localeSync"));
  }

  static fetch() async {
    try {
      final LocaleSyncAPI api = LocaleSyncAPI();
      _data = await api.fetch(
        apiToken: _token,
        repositoryId: _repositoryId,
      );
      _storage.save(_data);
    } catch (e) {
      final cachedData = _storage.data;
      if (cachedData?["data"] != null && cachedData?["data"].isNotEmpty) {
        _data = cachedData!["data"].cast<String, dynamic>();
      }
    }
  }

  static Map<String, dynamic> get data => _data;

  static BaseLocaleSyncLocalization of(BuildContext context) =>
      Localizations.of<BaseLocaleSyncLocalization>(
        context,
        BaseLocaleSyncLocalization,
      )!;

  static LocalizationsDelegate<BaseLocaleSyncLocalization> get delegate =>
      const LocaleSyncLocalizationsDelegate();
}

class LocaleSyncLocalizationsDelegate
    extends LocalizationsDelegate<BaseLocaleSyncLocalization> {
  const LocaleSyncLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return kMaterialSupportedLanguages.contains(locale.languageCode);
  }

  Future<BaseLocaleSyncLocalization> _fallbackHandler(Locale locale) async {
    switch (locale.toString().toLowerCase().replaceFirst('_', '-')) {
      case 'pt':
        return const PTLocaleSyncLocalization();
      default:
        return const PTLocaleSyncLocalization();
    }
  }

  @override
  Future<BaseLocaleSyncLocalization> load(Locale locale) async {
    try {
      await LocaleSync.fetch();
      if (LocaleSync.data.isNotEmpty &&
          (LocaleSync.data[
                      "${locale.languageCode.toLowerCase()}-${locale.countryCode?.toLowerCase()}"] !=
                  null ||
              LocaleSync.data[locale.languageCode.toLowerCase()] != null)) {
        return In_Memory_LocaleSyncLocalization(
          map: LocaleSync.data,
          language: locale.languageCode.toLowerCase(),
        );
      }
    } catch (_) {}
    return await _fallbackHandler(locale);
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate old) {
    return old != this;
  }
}
