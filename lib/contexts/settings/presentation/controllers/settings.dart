import '../../../../core/external_dependencies.dart';
import '../../../../core/protocols/protocols.dart';
import '../../../../core/state/state.dart';
import '../../dtos/dtos.dart';

abstract class SettingsController extends BaseStateController<SettingsDto> {
  AtomNotifier<DefaultState> get updateState;
  Future<void> updateSettings();

  Future<void> getSettings();

  Future<void> openLink(String link);
}

class DefaultSettingsController
    with BaseState<Exception, SettingsDto>
    implements SettingsController {
  DefaultSettingsController({
    required LinkHandler linkHandler,
  }) : _linkHandler = linkHandler;
  final LinkHandler _linkHandler;

  @override
  Future<void> getSettings() async {
    // TODO: implement getSettings
    throw UnimplementedError();
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
}
