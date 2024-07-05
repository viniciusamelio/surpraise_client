import 'package:blurple/tokens/color_tokens.dart';
import 'package:blurple/widgets/input/base_input.dart';
import 'package:flutter/material.dart';
import 'package:pressable/pressable.dart';

import '../../../../../core/core.dart';
import '../../../../../core/external_dependencies.dart';
import '../../../auth.dart';

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
            label: translations.email,
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
                  label: translations.password,
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
          SizedBox(
            height: context.theme.spacingScheme.verticalSpacing,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Pressable.scale(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  PasswordRecoveryScreen.routeName,
                );
              },
              child: Text(
                translations.forgetPassword,
                style: TextStyle(
                  color: ColorTokens.grey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
