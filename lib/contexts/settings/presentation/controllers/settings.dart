import '../../../../core/core.dart';
import '../../../../core/external_dependencies.dart';
import '../../../../shared/presentation/controllers/controllers.dart';
import '../../dtos/dtos.dart';

import '../../../auth/auth.dart';

abstract class SettingsController
    extends BaseStateController<GetSettingsOutput> {
  AtomNotifier<SettingsDto> get settings;

  AtomNotifier<DefaultState<Exception, SettingsDto>> get updateState;
  Future<void> updateSettings();
  AtomNotifier<DefaultState<Exception, String>> get deleteAccountState;
  Future<void> deleteAccount();

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
    required AuthService authService,
  })  : _linkHandler = linkHandler,
        _authService = authService,
        _sessionController = sessionController,
        _settingsRepository = settingsRepository;
  final LinkHandler _linkHandler;
  final SettingsRepository _settingsRepository;
  final SessionController _sessionController;
  final AuthService _authService;

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

  @override
  Future<void> deleteAccount() async {
    deleteAccountState.set(LoadingState());
    final deleteAccountOrError = await _authService.deleteAccount(
      injected<SessionController>().currentUser.value!.id,
    );
    deleteAccountState.set(
      deleteAccountOrError.fold(
        (left) => ErrorState(left),
        (right) => const SuccessState(
          "Ok",
        ),
      ),
    );
  }

  @override
  final AtomNotifier<DefaultState<Exception, String>> deleteAccountState =
      AtomNotifier(InitialState());
}
