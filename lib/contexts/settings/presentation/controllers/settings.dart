import '../../../../core/external_dependencies.dart';
import '../../../../core/protocols/protocols.dart';
import '../../../../core/state/state.dart';
import '../../../../shared/presentation/controllers/controllers.dart';
import '../../dtos/dtos.dart';

abstract class SettingsController
    extends BaseStateController<GetSettingsOutput> {
  AtomNotifier<SettingsDto> get settings;

  AtomNotifier<DefaultState> get updateState;
  Future<void> updateSettings();

  Future<void> getSettings();

  Future<void> openLink(String link);
}

class DefaultSettingsController
    with BaseState<Exception, GetSettingsOutput>
    implements SettingsController {
  DefaultSettingsController({
    required LinkHandler linkHandler,
    required SettingsRepository settingsRepository,
    required SessionController sessionController,
  })  : _linkHandler = linkHandler,
        _sessionController = sessionController,
        _settingsRepository = settingsRepository;
  final LinkHandler _linkHandler;
  final SettingsRepository _settingsRepository;
  final SessionController _sessionController;

  @override
  Future<void> getSettings() async {
    state.set(LoadingState());
    final settingsOrError = await _settingsRepository.get(
      userId: _sessionController.currentUser.value!.id,
    );
    stateFromEither(settingsOrError);
    settingsOrError.fold(
      (left) => null,
      (right) {
        settings.set(
          SettingsDto(
            notificationEnabled: right.pushNotificationsEnabled,
          ),
        );
      },
    );
  }

  @override
  Future<void> openLink(String link) async {
    await _linkHandler.openLink(link: link);
  }

  @override
  Future<void> updateSettings() {
    // TODO: implement updateSettings
    throw UnimplementedError();
  }

  @override
  // TODO: implement updateState
  AtomNotifier<DefaultState<Exception, dynamic>> get updateState =>
      throw UnimplementedError();

  @override
  final AtomNotifier<SettingsDto> settings = AtomNotifier(
    const SettingsDto(
      notificationEnabled: false,
    ),
  );
}
