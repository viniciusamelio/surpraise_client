import 'package:blurple/sizes/spacings.dart';
import 'package:blurple/themes/theme_data.dart';
import 'package:blurple/tokens/color_tokens.dart';
import 'package:blurple/widgets/buttons/buttons.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/di/di.dart';
import '../../../../core/extensions/theme.dart';
import '../../../../core/external_dependencies.dart';
import '../../../../core/state/default_state.dart';
import '../../../../shared/presentation/molecules/loader.dart';
import '../../settings.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final SettingsController controller;

  @override
  void initState() {
    controller = injected();
    controller.getSettings();
    super.initState();
  }

  BlurpleThemeData get theme => context.theme;

  @override
  Widget build(BuildContext context) {
    final screenPadding = EdgeInsets.symmetric(
      horizontal: Spacings.xxl,
    );
    const buttonColor = Color(0xFF343336);
    return Scaffold(
      body: Padding(
        padding: screenPadding,
        child: Column(
          children: [
            Text(
              "Quer apoiar o projeto?",
              style: theme.fontScheme.h3.copyWith(
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: Spacings.md,
            ),
            Text.rich(
              TextSpan(
                text:
                    "Você pode contribuir diretamente com o desenvolvimento do",
                children: [
                  TextSpan(
                    text: " Sur#praise",
                    style: theme.fontScheme.p2.copyWith(
                      color: theme.colorScheme.accentColor,
                    ),
                  ),
                  const TextSpan(
                    text: " através dos links abaixo",
                  ),
                ],
              ),
              style: theme.fontScheme.p2.copyWith(
                color: ColorTokens.greyLighter,
              ),
            ),
            SizedBox(
              height: Spacings.xxl,
            ),
            Row(
              children: [
                BorderedIconButton(
                  onPressed: () async {
                    controller.openLink(
                      "https://github.com/viniciusamelio/surpraise_client",
                    );
                  },
                  text: "Me pague um café",
                  preffixIcon: const Icon(
                    Icons.coffee,
                    size: 20,
                  ),
                  foregroundColor: theme.colorScheme.warningColor,
                  backgroundColor: buttonColor,
                ),
                SizedBox(
                  width: Spacings.md,
                ),
                BorderedIconButton(
                  onPressed: () async {
                    controller.openLink(
                      "https://linkedin.com/in/vinicius-amelio-jesus/",
                    );
                  },
                  text: "Linkedin",
                  preffixIcon: const Icon(
                    FontAwesomeIcons.linkedin,
                    size: 20,
                  ),
                  foregroundColor: theme.colorScheme.infoColor,
                  backgroundColor: buttonColor,
                ),
              ],
            ),
            SizedBox(
              height: Spacings.xxl * 2,
            ),
            PolymorphicAtomObserver(
                atom: controller.state,
                types: [
                  TypedAtomHandler(
                    type: LoadingState<Exception, GetSettingsOutput>,
                    builder: (context, state) {
                      return const LoaderMolecule();
                    },
                  ),
                ],
                defaultBuilder: (state) {
                  return Column(
                    children: [
                      Text(
                        "Suas configurações",
                        style: theme.fontScheme.h3.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: Spacings.xxl,
                      ),
                      Row(
                        children: [
                          Text(
                            "Receber notifações push? ",
                            style: theme.fontScheme.p2,
                          ),
                          SizedBox(
                            width: Spacings.md,
                          ),
                          AtomObserver(
                              atom: controller.settings,
                              builder: (context, state) {
                                return Switch(
                                  value: state.notificationEnabled,
                                  activeColor: theme.colorScheme.accentColor,
                                  inactiveThumbColor: ColorTokens.concrete,
                                  activeTrackColor: ColorTokens.concrete,
                                  onChanged: (value) async {
                                    controller.settings.set(
                                      state.copyWith(
                                        notificationEnabled: value,
                                      ),
                                    );
                                    await controller.updateSettings();
                                  },
                                );
                              }),
                        ],
                      ),
                    ],
                  );
                }),
          ],
        ),
      ),
    );
  }
}
