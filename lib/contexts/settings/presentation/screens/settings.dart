import 'package:blurple/sizes/spacings.dart';
import 'package:blurple/themes/theme_data.dart';
import 'package:flutter/material.dart';

import '../../../../core/di/di.dart';
import '../../../../core/extensions/theme.dart';
import '../../../../core/state/state.dart';
import '../../../../shared/presentation/molecules/molecules.dart';
import '../../settings.dart';
import '../widgets/organisms/organisms.dart';

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

    return Scaffold(
      body: SafeArea(
        child: Padding(
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
            ],
          ),
        ),
      ),
    );
  }
}
