import 'package:blurple/widgets/buttons/buttons.dart';
import 'package:flutter/material.dart';
import 'package:surpraise_client/shared/shared.dart';

import '../../../../core/core.dart';
import '../../application/services/services.dart';
import '../controllers/signup_controller.dart';
import '../widgets/widgets.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  static const String routeName = '/auth/signup';

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  late final GlobalKey<FormState> formKey;
  late final AuthService authService;
  late final SignupController controller;

  @override
  void initState() {
    formKey = GlobalKey<FormState>();
    authService = injected();
    controller = injected();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ContentScaffoldTemplate(
      title: "Crie sua conta",
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Builder(builder: (context) {
        return ValueListenableBuilder(
          valueListenable: controller.state,
          builder: (context, state, _) {
            return SizedBox(
              width: MediaQuery.of(context).size.width -
                  (context.theme.spacingScheme.verticalSpacing * 4) * 2,
              child: (state is LoadingState)
                  ? BaseButton(
                      backgroundColor: context.theme.colorScheme.accentColor,
                      foregroundColor:
                          context.theme.colorScheme.foregroundColor,
                      child: CircularProgressIndicator(
                        color: context.theme.colorScheme.foregroundColor,
                      ),
                    )
                  : BaseButton.text(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          if (controller.profilePicture.value == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const ErrorSnack(
                                      message: "Selecione uma imagem de perfil")
                                  .build(context),
                            );
                            return;
                          }
                          controller.formData.profilePicture =
                              controller.profilePicture.value!;
                          formKey.currentState!.save();
                          controller.signup();
                        }
                      },
                      backgroundColor: context.theme.colorScheme.accentColor,
                      foregroundColor:
                          context.theme.colorScheme.foregroundColor,
                      text: "Enviar",
                    ),
            );
          },
        );
      }),
      child: SignupFormOrganism(
        formKey: formKey,
        controller: controller,
      ),
    );
  }
}
