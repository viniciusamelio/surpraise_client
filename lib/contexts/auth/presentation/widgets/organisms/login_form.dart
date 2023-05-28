import 'package:blurple/widgets/input/base_input.dart';
import 'package:flutter/material.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';

import '../../../../../core/extensions/theme.dart';

class LoginFormOrganism extends StatelessWidget {
  const LoginFormOrganism({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const BaseInput(
            label: "E-mail",
            preffixIcon: Icon(
              HeroiconsSolid.envelope,
            ),
          ),
          SizedBox(
            height: context.theme.spacingScheme.verticalSpacing,
          ),
          const BaseInput(
            label: "Password",
            preffixIcon: Icon(
              HeroiconsSolid.lockClosed,
            ),
            obscureText: true,
          ),
        ],
      ),
    );
  }
}
