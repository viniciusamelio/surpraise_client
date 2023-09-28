import '../../../../core/external_dependencies.dart';
import '../../../../core/protocols/protocols.dart';
import '../../../../core/state/state.dart';
import '../../../../shared/presentation/controllers/controllers.dart';
import '../../dtos/dtos.dart';

abstract class SettingsController
    extends BaseStateController<GetSettingsOutput> {
  AtomNotifier<SettingsDto> get settings;

  AtomNotifier<DefaultState<Exception, SettingsDto>> get updateState;
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
  Future<void> updateSettings() async {
    final updatedSettingsOrError = await _settingsRepository.save(
      input: SaveSettingsInput(
        pushNotificationsEnabled: settings.value.notificationEnabled,
        userId: _sessionController.currentUser.value!.id,
      ),
    );
    updateState.set(
      updatedSettingsOrError.fold(
        (left) => ErrorState(left),
        (right) => SuccessState(
          SettingsDto(
            notificationEnabled: right.pushNotificationsEnabled,
          ),
        ),
      ),
    );
  }

  @override
  final AtomNotifier<DefaultState<Exception, SettingsDto>> updateState =
      AtomNotifier(InitialState());

  @override
  final AtomNotifier<SettingsDto> settings = AtomNotifier(
    const SettingsDto(
      notificationEnabled: false,
    ),
  );
}
