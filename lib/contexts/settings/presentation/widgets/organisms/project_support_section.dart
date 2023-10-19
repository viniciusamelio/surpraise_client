import 'package:blurple/sizes/spacings.dart';
import 'package:blurple/themes/theme_data.dart';
import 'package:blurple/tokens/color_tokens.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../core/core.dart';
import '../../../links.dart';
import '../../../settings.dart';
import '../widgets.dart';

class ProjectSupportSection extends StatelessWidget {
  const ProjectSupportSection({
    super.key,
    required this.controller,
  });

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    final BlurpleThemeData theme = context.theme;

    return Column(
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
            text: "Você pode contribuir diretamente com o desenvolvimento do",
            children: [
              TextSpan(
                text: " #surpraise",
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
            SettingsButton(
              onPressed: () async {
                controller.openLink(
                  coffeeLink,
                );
              },
              label: "Me pague um café",
              icon: const Icon(
                Icons.coffee,
                size: 20,
              ),
              foregroundColor: theme.colorScheme.warningColor,
            ),
            SizedBox(
              width: Spacings.md,
            ),
            SettingsButton(
              onPressed: () async {
                controller.openLink(
                  linkedinUrl,
                );
              },
              label: "Linkedin",
              icon: const Icon(
                FontAwesomeIcons.linkedin,
                size: 20,
              ),
              foregroundColor: theme.colorScheme.infoColor,
            ),
          ],
        ),
      ],
    );
  }
}
