import 'package:flutter/material.dart';

import '../../../../core/events/events.dart';
import '../../../../core/external_dependencies.dart';
import '../../../../core/navigator.dart';
import '../../../../core/state/default_state.dart';
import '../../../../shared/presentation/molecules/success_snack.dart';
import '../../auth.dart';
import '../../presentation/controllers/controllers.dart';
import '../../presentation/screens/signup.dart';

void socialAuthConsumer({
  required ApplicationEventBus eventBus,
  required GetUserQuery getUserQuery,
  required SignInController signInController,
}) {
  eventBus.on<SocialSignedInEvent>((event) async {
    const SuccessSnack(
      message: "Autenticado! Aguarde um instante...",
      duration: 1,
    ).show(context: navigatorKey.currentContext!);
    final userOrError = await getUserQuery(
      GetUserQueryInput(
        id: event.data.id,
      ),
    );
    if (userOrError.isLeft()) {
      Navigator.of(navigatorKey.currentContext!).pushNamed(
        SignupScreen.routeName,
        arguments: SignupFormDataDto()
          ..name = event.data.name
          ..email = event.data.email,
      );
    }

    final result = userOrError.fold((left) => null, (right) => right)!.value;
    signInController.state.set(
      SuccessState(
        GetUserOutput(
          tag: result.tag,
          name: result.name,
          email: result.email,
          id: result.id,
        ),
      ),
    );
  });
}
