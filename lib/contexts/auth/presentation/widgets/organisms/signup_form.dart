import 'package:blurple/widgets/input/base_input.dart';
import 'package:flutter/material.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';
import '../../controllers/signup_controller.dart';

import '../../../../../core/core.dart';

class SignupFormOrganism extends StatefulWidget {
  const SignupFormOrganism({
    super.key,
    required this.formKey,
    required this.controller,
  });

  final FormKey formKey;
  final SignupController controller;

  @override
  State<SignupFormOrganism> createState() => _SignupFormOrganismState();
}

class _SignupFormOrganismState extends State<SignupFormOrganism> {
  SignupController get controller => widget.controller;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          BaseInput(
            label: "Nome",
            onSaved: (value) => controller.formData.name = value!,
            validator: (value) => name(value ?? ""),
            preffixIcon: const Icon(
              HeroiconsSolid.user,
            ),
          ),
          SizedBox(
            height: context.theme.spacingScheme.verticalSpacing,
          ),
          BaseInput(
            label: "E-mail",
            onSaved: (value) => controller.formData.email = value!,
            validator: (value) => email(value ?? ""),
            preffixIcon: const Icon(
              HeroiconsSolid.envelope,
            ),
          ),
          SizedBox(
            height: context.theme.spacingScheme.verticalSpacing,
          ),
          BaseInput(
            label: "Tag",
            onSaved: (value) => controller.formData.tag = value!,
            validator: (value) => tag(value ?? ""),
            preffixIcon: const Icon(
              HeroiconsSolid.atSymbol,
            ),
          ),
          SizedBox(
            height: context.theme.spacingScheme.verticalSpacing,
          ),
          BaseInput(
            label: "Password",
            onSaved: (value) => controller.formData.password = value!,
            validator: (value) => password(value ?? ""),
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
