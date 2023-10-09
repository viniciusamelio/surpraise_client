import 'package:blurple/sizes/spacings.dart';
import 'package:blurple/themes/theme_data.dart';
import 'package:blurple/tokens/color_tokens.dart';
import 'package:flutter/material.dart';

import '../../../../core/di/di.dart';
import '../../../../core/extensions/theme.dart';
import '../../../../core/external_dependencies.dart';
import '../../../../core/state/state.dart';
import '../../../../shared/presentation/controllers/controllers.dart';
import '../../../../shared/presentation/molecules/molecules.dart';
import '../../settings.dart';
import '../widgets/widgets.dart';

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
    controller.deleteAccountState.listenState(
      onError: (left) {
        if (mounted) {
          const ErrorSnack(
            message: "Deu ruim ao excluir sua conta",
          ).show(context: context);
        }
      },
      onSuccess: (_) {
        injected<SessionController>().logout();
      },
    );

    super.initState();
  }

  BlurpleThemeData get theme => context.theme;

  @override
  void dispose() {
    controller.deleteAccountState.removeListeners();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenPadding = EdgeInsets.all(
      Spacings.lg,
    );
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProjectSupportSection(
                controller: controller,
              ),
              SizedBox(
                height: Spacings.xxl * 2,
              ),
              SettingsSectionOrganism(
                controller: controller,
              ),
              SizedBox(
                height: Spacings.xl * 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SettingsButton(
                    label: "Excluir conta",
                    icon: const Icon(HeroiconsOutline.power),
                    foregroundColor: theme.colorScheme.dangerColor,
                    onPressed: () {
                      ConfirmSnack(
                        leadingIcon: Icon(
                          HeroiconsOutline.power,
                          color: ColorTokens.red,
                        ),
                        message:
                            "Tem certeza que deseja excluir sua conta? Não será possível recuperar seu acesso após isso",
                        onConfirm: () {
                          controller.deleteAccount();
                        },
                      ).show(context: context);
                    },
                  ),
                  SizedBox(
                    width: Spacings.md,
                  ),
                  SettingsButton(
                    onPressed: () {
                      injected<SessionController>().logout();
                    },
                    label: "Sair",
                    icon: const Icon(HeroiconsOutline.arrowLeftOnRectangle),
                    foregroundColor: ColorTokens.greyDarker,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
