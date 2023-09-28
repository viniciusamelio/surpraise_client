import 'package:blurple/sizes/spacings.dart';
import 'package:blurple/themes/theme_data.dart';
import 'package:blurple/tokens/color_tokens.dart';
import 'package:flutter/material.dart';

import '../../../../../core/core.dart';
import '../../../../../core/external_dependencies.dart';
import '../../../../../shared/shared.dart';
import '../../../settings.dart';

class SettingsSectionOrganism extends StatelessWidget {
  const SettingsSectionOrganism({
    super.key,
    required this.controller,
  });

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    final BlurpleThemeData theme = context.theme;
    return PolymorphicAtomObserver(
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
                          inactiveThumbColor: ColorTokens.concreteDarker,
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
        });
  }
}
