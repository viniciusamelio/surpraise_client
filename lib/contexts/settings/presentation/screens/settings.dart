import 'package:blurple/sizes/spacings.dart';
import 'package:blurple/themes/theme_data.dart';
import 'package:blurple/tokens/color_tokens.dart';
import 'package:blurple/widgets/buttons/buttons.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/di/di.dart';
import '../../../../core/extensions/theme.dart';
import '../../../../core/external_dependencies.dart';
import '../../../../core/state/state.dart';
import '../../../../shared/presentation/molecules/molecules.dart';
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
    controller.updateState.listenState(
      onError: (left) {
        if (mounted) {
          const ErrorSnack(
            message: "Deu ruim ao salvar suas configurações",
          ).show(
            context: context,
          );
        }
      },
    );

    super.initState();
  }

  BlurpleThemeData get theme => context.theme;

  @override
  Widget build(BuildContext context) {
    final screenPadding = EdgeInsets.all(
      Spacings.lg,
    );
    final buttonPadding = EdgeInsets.symmetric(
      horizontal: Spacings.xl,
      vertical: Spacings.md,
    );
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    padding: buttonPadding,
                    foregroundColor: theme.colorScheme.warningColor,
                    borderRadius: 4,
                    backgroundColor:
                        theme.colorScheme.elevatedWidgetsColor.withOpacity(.8),
                    borderSide: BorderSide(
                      width: .15,
                      color: theme.colorScheme.borderColor,
                    ),
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
                    padding: buttonPadding,
                    preffixIcon: const Icon(
                      FontAwesomeIcons.linkedin,
                      size: 20,
                    ),
                    borderSide: BorderSide(
                      width: .15,
                      color: theme.colorScheme.borderColor,
                    ),
                    borderRadius: 4,
                    foregroundColor: theme.colorScheme.infoColor,
                    backgroundColor:
                        theme.colorScheme.elevatedWidgetsColor.withOpacity(.8),
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
                    TypedAtomHandler(
                      type: ErrorState<Exception, GetSettingsOutput>,
                      builder: (context, state) {
                        return const ErrorWidgetMolecule(
                          message: "Deu ruim ao carregar suas configurações",
                        );
                      },
                    ),
                  ],
                  defaultBuilder: (state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                              "Receber notificações push ?",
                              style: theme.fontScheme.p2.copyWith(
                                fontSize: 16,
                              ),
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
                                    inactiveThumbColor:
                                        ColorTokens.concreteDarker,
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
      ),
    );
  }
}
