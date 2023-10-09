import '../../core/di/di.dart';
import '../../core/external_dependencies.dart';
import 'settings.dart';

Future<void> settingsDependencies() async {
  inject<SettingsRepository>(
    DefaultSettingsRepository(
      databaseDatasource: injected(),
    ),
  );
  inject<SettingsController>(
    DefaultSettingsController(
      linkHandler: injected(),
      settingsRepository: injected(),
      sessionController: injected(),
      authService: injected(),
    ),
  );
}
