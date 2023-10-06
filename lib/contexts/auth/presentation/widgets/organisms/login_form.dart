import 'package:blurple/widgets/input/base_input.dart';
import 'package:flutter/material.dart';

import '../../../../../core/extensions/theme.dart';
import '../../../../../core/external_dependencies.dart';

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
    final AtomNotifier<bool> showPassword = AtomNotifier(false);

    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BaseInput(
            onSaved: onSaveEmail,
            label: "E-mail",
            type: TextInputType.emailAddress,
            preffixIcon: const Icon(
              HeroiconsSolid.envelope,
            ),
          ),
          SizedBox(
            height: context.theme.spacingScheme.verticalSpacing,
          ),
          AtomObserver(
              atom: showPassword,
              builder: (context, show) {
                return BaseInput(
                  onSaved: onSavePassword,
                  label: "Senha",
                  maxLines: 1,
                  preffixIcon: const Icon(
                    HeroiconsSolid.lockClosed,
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      showPassword.set(!show);
                    },
                    child: Icon(
                      show ? HeroiconsSolid.eye : HeroiconsMini.eyeSlash,
                    ),
                  ),
                  obscureText: !show,
                );
              }),
        ],
      ),
    );
  }
}
