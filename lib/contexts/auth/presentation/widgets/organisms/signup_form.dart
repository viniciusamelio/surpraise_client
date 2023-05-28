import 'package:blurple/widgets/input/base_input.dart';
import 'package:flutter/material.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';

import '../../../../../core/core.dart';
import '../../../../../core/extensions/theme.dart';

class SignupFormOrganism extends StatefulWidget {
  const SignupFormOrganism({
    super.key,
    required this.formKey,
    required this.onSaved,
  });

  final FormKey formKey;
  final VoidCallback onSaved;

  @override
  State<SignupFormOrganism> createState() => _SignupFormOrganismState();
}

class _SignupFormOrganismState extends State<SignupFormOrganism> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          const BaseInput(
            label: "Nome",
            preffixIcon: Icon(
              HeroiconsSolid.user,
            ),
          ),
          SizedBox(
            height: context.theme.spacingScheme.verticalSpacing,
          ),
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
            label: "Tag",
            preffixIcon: Icon(
              HeroiconsSolid.atSymbol,
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
