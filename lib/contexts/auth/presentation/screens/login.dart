import 'package:blurple/widgets/buttons/buttons.dart';
import 'package:blurple/widgets/input/base_input.dart';
import 'package:flutter/material.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';
import 'package:surpraise_client/core/extensions/theme.dart';

import '../widgets/widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const String routeName = "/auth/login";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(
                  context.theme.spacingScheme.verticalSpacing * 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const LoginDisplayerOrganism(),
                  Form(
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
                          inputFormatters: [],
                          obscureText: true,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: BorderedIconButton(
                      onPressed: () {},
                      borderSide: BorderSide(
                        color: context.theme.colorScheme.accentColor,
                      ),
                      backgroundColor: context.theme.colorScheme.shadowColor,
                      foregroundColor: context.theme.colorScheme.accentColor,
                      preffixIcon:
                          const Icon(HeroiconsSolid.arrowRightOnRectangle),
                      text: "Entrar",
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Não possui uma conta?",
                          style: context.theme.fontScheme.p2.copyWith(
                            fontSize: 15,
                            color: context.theme.colorScheme.foregroundColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(
                          height:
                              context.theme.spacingScheme.verticalSpacing * 2,
                        ),
                        BaseButton.icon(
                          onPressed: () {},
                          padding:
                              context.theme.spacingScheme.buttonPadding / 1.5,
                          backgroundColor:
                              context.theme.colorScheme.accentColor,
                          foregroundColor:
                              context.theme.colorScheme.foregroundColor,
                          label: "Cadastre-se",
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
