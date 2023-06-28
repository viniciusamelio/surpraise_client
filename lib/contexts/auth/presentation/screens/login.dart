import 'package:blurple/widgets/buttons/buttons.dart';
import 'package:flutter/material.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';
import '../../../../core/core.dart';
import '../controllers/signin_controller.dart';

import '../widgets/widgets.dart';
import 'signup.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const String routeName = "/auth/login";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final GlobalKey<FormState> formKey;
  late final SignInController controller;

  @override
  void initState() {
    controller = injected();
    formKey = GlobalKey<FormState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(
                  context.theme.spacingScheme.verticalSpacing * 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const LoginDisplayerOrganism(),
                  LoginFormOrganism(
                    formKey: formKey,
                    onSaveEmail: (value) {
                      controller.formData.username = value!;
                    },
                    onSavePassword: (value) {
                      controller.formData.password = value!;
                    },
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ValueListenableBuilder(
                      valueListenable: controller.state,
                      builder: (context, state, _) {
                        return BorderedIconButton(
                          onPressed: () {
                            if (formKey.currentState!.validate() &&
                                state is! LoadingState) {
                              formKey.currentState!.save();
                              controller.signIn();
                            }
                          },
                          borderSide: BorderSide(
                            color: context.theme.colorScheme.accentColor,
                          ),
                          backgroundColor:
                              context.theme.colorScheme.shadowColor,
                          foregroundColor:
                              context.theme.colorScheme.accentColor,
                          preffixIcon: state is! LoadingState
                              ? const Icon(
                                  HeroiconsSolid.arrowRightOnRectangle,
                                )
                              : const Icon(
                                  HeroiconsSolid.arrowPathRoundedSquare),
                          text: state is! LoadingState
                              ? "Entrar"
                              : "Carregando...",
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Não possui uma conta?",
                          style: context.theme.fontScheme.p2.copyWith(
                            fontSize: 15,
                            color: context.theme.colorScheme.foregroundColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(
                          height:
                              context.theme.spacingScheme.verticalSpacing * 2,
                        ),
                        BaseButton.icon(
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(SignupScreen.routeName);
                          },
                          padding:
                              context.theme.spacingScheme.buttonPadding / 1.5,
                          backgroundColor:
                              context.theme.colorScheme.accentColor,
                          foregroundColor:
                              context.theme.colorScheme.foregroundColor,
                          label: "Cadastre-se",
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
