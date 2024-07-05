import 'package:blurple/widgets/buttons/buttons.dart';
import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../../../core/external_dependencies.dart';
import '../../../../shared/shared.dart';
import '../../application/services/services.dart';
import '../../dtos/dtos.dart';
import '../controllers/signup_controller.dart';
import '../widgets/widgets.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key, this.formData});
  final SignupFormDataDto? formData;
  static const String routeName = '/auth/signup';

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  late final GlobalKey<FormState> formKey;
  late final AuthService authService;
  late final SignupController controller;

  bool socialSignup = false;

  @override
  void initState() {
    formKey = GlobalKey<FormState>();
    authService = injected();
    controller = injected();
    if (widget.formData != null) {
      controller.setFormData(widget.formData!);
      socialSignup = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffoldTemplate(
      title: translations.signupTitle,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Builder(builder: (context) {
        return AtomObserver(
          atom: controller.state,
          builder: (context, state) {
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
                              ErrorSnack(
                                message: translations.profilePictureLabel,
                              ).build(context),
                            );
                            return;
                          }
                          controller.formData.profilePicture =
                              controller.profilePicture.value!;
                          formKey.currentState!.save();
                          controller.signup(isSocial: socialSignup);
                        }
                      },
                      backgroundColor: context.theme.colorScheme.accentColor,
                      foregroundColor:
                          context.theme.colorScheme.foregroundColor,
                      text: translations.send,
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
