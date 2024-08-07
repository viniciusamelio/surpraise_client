// ignore_for_file: deprecated_member_use

import 'package:blurple/sizes/spacings.dart';
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
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height - 120,
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
                                  ? translations.signIn
                                  : translations.signInLoading,
                            );
                          },
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            translations.orSignInWith,
                            style: context.theme.fontScheme.p2.copyWith(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: Spacings.sm,
                          ),
                          SizedBox(
                            height: 36,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: BaseButton.icon(
                                    onPressed: () {
                                      controller.socialSignIn(
                                        provider: SocialProvider.discord,
                                      );
                                    },
                                    padding: const EdgeInsets.all(4),
                                    backgroundColor: const Color(0XFF5865f2),
                                    borderRadius: 6,
                                    icon: SvgPicture.asset(
                                      "assets/images/discord.svg",
                                      width: 24,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: BaseButton.icon(
                                    onPressed: () {
                                      controller.socialSignIn(
                                        provider: SocialProvider.github,
                                      );
                                    },
                                    padding: const EdgeInsets.all(4),
                                    borderRadius: 6,
                                    backgroundColor: Colors.black,
                                    icon: SvgPicture.asset(
                                      "assets/images/github.svg",
                                      width: 24,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: BaseButton.icon(
                                    onPressed: () {
                                      controller.socialSignIn(
                                        provider: SocialProvider.slack,
                                      );
                                    },
                                    padding: const EdgeInsets.all(4),
                                    borderRadius: 6,
                                    backgroundColor: const Color(0xff4a154b),
                                    icon: SvgPicture.asset(
                                      "assets/images/slack.svg",
                                      width: 24,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
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
                              translations.doesNotHaveAnAccount,
                              style: context.theme.fontScheme.p2.copyWith(
                                fontSize: 15,
                                color:
                                    context.theme.colorScheme.foregroundColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(
                              height:
                                  context.theme.spacingScheme.verticalSpacing *
                                      2,
                            ),
                            BaseButton.icon(
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed(SignupScreen.routeName);
                              },
                              padding:
                                  context.theme.spacingScheme.buttonPadding /
                                      1.5,
                              backgroundColor:
                                  context.theme.colorScheme.accentColor,
                              foregroundColor:
                                  context.theme.colorScheme.foregroundColor,
                              label: translations.signUp,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
