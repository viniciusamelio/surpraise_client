import 'package:blurple/sizes/spacings.dart';
import 'package:blurple/themes/theme_data.dart';
import 'package:blurple/tokens/color_tokens.dart';
import 'package:blurple/widgets/buttons/buttons.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../core/core.dart';
import '../../../links.dart';
import '../../../settings.dart';

class ProjectSupportSection extends StatelessWidget {
  const ProjectSupportSection({
    super.key,
    required this.controller,
  });

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    final BlurpleThemeData theme = context.theme;

    final buttonPadding = EdgeInsets.symmetric(
      horizontal: Spacings.xl,
      vertical: Spacings.md,
    );
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
                  coffeeLink,
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
                  linkedinUrl,
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
      ],
    );
  }
}
