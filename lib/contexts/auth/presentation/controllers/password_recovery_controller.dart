import '../../../../core/external_dependencies.dart';
import '../../../../core/state/state.dart';
import '../../application/application.dart';

abstract class PasswordRecoveryController extends BaseStateController<void> {
  Future<void> sendEmail({required String email});

  Future<void> checkCode({
    required String code,
  });
  AtomNotifier<DefaultState<Exception, void>> get checkState;

  Future<void> changePassword({
    required String password,
  });

  AtomNotifier<DefaultState<Exception, void>> get changePasswordState;
}

class DefaultPasswordController
    with BaseState<Exception, void>
    implements PasswordRecoveryController {
  DefaultPasswordController({
    required AuthService authService,
  }) : _authService = authService;
  final AuthService _authService;

  String? _email;

  @override
  Future<void> checkCode({
    required String code,
  }) async {
    checkState.set(LoadingState());
    final confirmationOrError = await _authService.confirmRecoveryCode(
      code: code,
      email: _email!,
    );
    checkState.set(
      confirmationOrError.fold(
        (left) => ErrorState(left),
        (right) => const SuccessState(null),
      ),
    );
  }

  @override
  final AtomNotifier<DefaultState<Exception, void>> checkState =
      AtomNotifier(InitialState());

  @override
  Future<void> sendEmail({required String email}) async {
    state.set(LoadingState());
    final requestOrError = await _authService.requestPasswordReset(email);
    state.set(requestOrError.fold(
      (left) => ErrorState(left),
      (right) {
        _email = email;
        return const SuccessState(null);
      },
    ));
  }

  @override
  Future<void> changePassword({required String password}) async {
    changePasswordState.set(
      LoadingState(),
    );
    final confirmationOrError = await _authService.confirmPasswordReset(
      password,
    );
    changePasswordState.set(
      confirmationOrError.fold(
        (left) => ErrorState(left),
        (right) => const SuccessState(null),
      ),
    );
  }

  @override
  final AtomNotifier<DefaultState<Exception, void>> changePasswordState =
      AtomNotifier(InitialState());
}
