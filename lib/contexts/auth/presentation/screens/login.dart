// ignore_for_file: deprecated_member_use

import 'package:blurple/widgets/buttons/buttons.dart';
import 'package:flutter/material.dart';
import '../../../../core/core.dart';
import '../../../../core/external_dependencies.dart';
import '../../application/application.dart';
import '../controllers/signin_controller.dart';

import '../mixins/social_auth.dart';
import '../widgets/widgets.dart';
import 'signup.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const String routeName = "/auth/login";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SocialAuthWidget {
  late final GlobalKey<FormState> formKey;
  late final SignInController controller;

  @override
  void initState() {
    controller = injected();
    formKey = GlobalKey<FormState>();
    listenToSocialAuth();
    super.initState();
  }

  @override
  void dispose() {
    disposeSocialAuth();
    super.dispose();
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
                    child: AtomObserver(
                      atom: controller.state,
                      builder: (context, state) {
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      BaseButton.icon(
                        onPressed: () {
                          // TODO: extrair isso para método de controller
                          injected<AuthService>()
                              .socialLogin(SocialProvider.discord);
                        },
                        padding: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 40,
                        ),
                        backgroundColor: const Color(0XFF5865f2),
                        borderRadius: 6,
                        icon: SvgPicture.asset(
                          "assets/images/discord.svg",
                          width: 24,
                          color: Colors.white,
                        ),
                      ),
                      BaseButton.icon(
                        onPressed: () {},
                        padding: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 40,
                        ),
                        borderRadius: 6,
                        backgroundColor: Colors.black,
                        icon: SvgPicture.asset(
                          "assets/images/github.svg",
                          width: 24,
                          color: Colors.white,
                        ),
                      ),
                    ],
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
