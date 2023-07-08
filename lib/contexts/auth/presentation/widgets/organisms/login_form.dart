import 'package:blurple/widgets/input/base_input.dart';
import 'package:flutter/material.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';

import '../../../../../core/extensions/theme.dart';

class LoginFormOrganism extends StatelessWidget {
  const LoginFormOrganism({
    super.key,
    required this.onSaveEmail,
    required this.onSavePassword,
    required this.formKey,
  });

  final void Function(String? value) onSaveEmail;
  final void Function(String? value) onSavePassword;
  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BaseInput(
            onSaved: onSaveEmail,
            label: "E-mail",
            preffixIcon: const Icon(
              HeroiconsSolid.envelope,
            ),
          ),
          SizedBox(
            height: context.theme.spacingScheme.verticalSpacing,
          ),
          BaseInput(
            onSaved: onSavePassword,
            label: "Password",
            maxLines: 1,
            preffixIcon: const Icon(
              HeroiconsSolid.lockClosed,
            ),
            obscureText: true,
          ),
        ],
      ),
    );
  }
}
