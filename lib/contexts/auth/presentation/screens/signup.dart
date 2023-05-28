import 'package:blurple/widgets/buttons/buttons.dart';
import 'package:flutter/material.dart';
import '../../../../core/extensions/theme.dart';
import '../../../../shared/presentation/templates/content_scaffold.dart';

import '../widgets/widgets.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  static const String routeName = '/auth/signup';

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  late final GlobalKey<FormState> formKey;

  @override
  void initState() {
    formKey = GlobalKey<FormState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ContentScaffoldTemplate(
        title: "Crie sua conta",
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: SizedBox(
          width: MediaQuery.of(context).size.width -
              (context.theme.spacingScheme.verticalSpacing * 4) * 2,
          child: BaseButton.text(
            onPressed: () {},
            backgroundColor: context.theme.colorScheme.accentColor,
            foregroundColor: context.theme.colorScheme.foregroundColor,
            text: "Enviar",
          ),
        ),
        child: SignupFormOrganism(
          formKey: formKey,
          onSaved: () {},
        ));
  }
}
