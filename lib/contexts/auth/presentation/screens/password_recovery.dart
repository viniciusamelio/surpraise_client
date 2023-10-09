// ignore_for_file: use_build_context_synchronously

import 'package:blurple/widgets/buttons/buttons.dart';
import 'package:blurple/widgets/input/base_input.dart';
import 'package:flutter/material.dart';

import '../../../../core/di/di.dart';
import '../../../../core/extensions/theme.dart';
import '../../../../core/external_dependencies.dart';
import '../../../../core/services/string/field_validations.dart';
import '../../../../core/state/state.dart';
import '../../../../core/types.dart';
import '../../../../shared/presentation/molecules/molecules.dart';
import '../../../../shared/presentation/templates/templates.dart';
import '../../auth.dart';
import '../controllers/controllers.dart';

class PasswordRecoveryScreen extends StatefulWidget {
  const PasswordRecoveryScreen({super.key});
  static const String routeName = '/auth/password-recovery';

  @override
  State<PasswordRecoveryScreen> createState() => _PasswordRecoveryScreenState();
}

class _PasswordRecoveryScreenState extends State<PasswordRecoveryScreen> {
  late final GlobalKey<FormState> formKey;
  late final PasswordRecoveryController controller;

  late final TextEditingController emailController,
      code,
      password,
      confirmPassword;

  late final PageController pageController;

  @override
  void initState() {
    initDependencies();
    setupListeners();
    super.initState();
  }

  @override
  void dispose() {
    controller.state.removeListeners();
    controller.checkState.removeListeners();
    controller.changePasswordState.removeListeners();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffoldTemplate(
      title: "Reset de senha",
      child: Form(
        key: formKey,
        child: MultiAtomObserver(
          atoms: [
            controller.state,
            controller.checkState,
            controller.changePasswordState,
          ],
          builder: (context) {
            bool loading = controller.state.value is LoadingState ||
                controller.changePasswordState.value is LoadingState ||
                controller.checkState.value is LoadingState;

            if (loading) {
              ConfirmSnack(
                  leadingIcon: const Icon(HeroiconsMini.circleStack),
                  message: "Carregando",
                  onConfirm: () {});
            }

            return SizedBox(
              height: MediaQuery.of(context).size.height - 200,
              child: PageView(
                controller: pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _RecoveryPageTemplate(
                    loading: loading,
                    buttonText: "Próximo",
                    onValidate: () => controller.sendEmail(
                      email: emailController.text,
                    ),
                    formKey: formKey,
                    children: [
                      BaseInput(
                        label: "E-mail",
                        validator: (value) => email(value ?? ""),
                        controller: emailController,
                        type: TextInputType.emailAddress,
                      ),
                    ],
                  ),
                  _RecoveryPageTemplate(
                    loading: loading,
                    buttonText: "Próximo",
                    onValidate: () => controller.checkCode(
                      code: code.text,
                    ),
                    formKey: formKey,
                    children: [
                      BaseInput(
                        label: "Código",
                        validator: (value) => minLength(value ?? "", 6),
                        controller: code,
                        type: TextInputType.number,
                      ),
                    ],
                  ),
                  _RecoveryPageTemplate(
                    loading: loading,
                    buttonText: "Enviar",
                    onValidate: () => controller.changePassword(
                      password: confirmPassword.text,
                    ),
                    formKey: formKey,
                    children: [
                      BaseInput(
                        label: "Nova Senha",
                        controller: password,
                        obscureText: true,
                        maxLines: 1,
                      ),
                      SizedBox(
                        height: context.theme.spacingScheme.verticalSpacing,
                      ),
                      BaseInput(
                        label: "Confirmar Nova Senha",
                        controller: confirmPassword,
                        maxLines: 1,
                        obscureText: true,
                        validator: (value) {
                          if (value != password.text) {
                            return "As senhas não coincidem";
                          }
                          return minLength(
                            value ?? "",
                            8,
                            message: "Senha deve ter no mínimo 8 caracteres",
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void setupListeners() {
    controller.state.listenState(
      onSuccess: (right) async {
        await Future.delayed(const Duration(milliseconds: 200));
        pageController.nextPage(
          duration: const Duration(milliseconds: 200),
          curve: Curves.bounceInOut,
        );
      },
      onError: (left) {
        const ErrorSnack(
          message: "Deu ruim ao enviar o código",
        ).show(context: context);
      },
    );
    controller.checkState.listenState(
      onSuccess: (right) async {
        await Future.delayed(const Duration(milliseconds: 200));

        pageController.nextPage(
          duration: const Duration(milliseconds: 200),
          curve: Curves.bounceInOut,
        );
      },
      onError: (left) {
        const ErrorSnack(
          message: "Deu ruim ao confirmar o código",
        ).show(context: context);
      },
    );
    controller.changePasswordState.listenState(
      onSuccess: (right) async {
        await Future.delayed(const Duration(milliseconds: 200));

        Navigator.pushReplacementNamed(context, LoginScreen.routeName);
        if (mounted) {
          const SuccessSnack(
            message: "Senha alterada",
          ).show(context: context);
        }
      },
      onError: (left) {
        const ErrorSnack(
          message: "Deu ruim ao alterar sua senha",
        ).show(context: context);
      },
    );
  }

  void initDependencies() {
    controller = injected();
    pageController = PageController();
    formKey = GlobalKey<FormState>();
    emailController = TextEditingController();
    code = TextEditingController();
    password = TextEditingController();
    confirmPassword = TextEditingController();
  }
}

class _RecoveryPageTemplate extends StatelessWidget {
  const _RecoveryPageTemplate({
    this.loading = false,
    required this.children,
    required this.buttonText,
    required this.onValidate,
    required this.formKey,
  });

  final List<Widget> children;
  final String buttonText;
  final VoidCallback onValidate;
  final FormKey formKey;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ...children,
        SizedBox(
          height: context.theme.spacingScheme.verticalSpacing,
        ),
        Visibility(
          visible: !loading,
          replacement: const BaseButton(
            child: Center(
              child: LoaderMolecule(),
            ),
          ),
          child: BaseButton.icon(
            label: buttonText,
            suffixIcon: const Icon(HeroiconsMini.arrowRight),
            foregroundColor: context.theme.colorScheme.accentColor,
            onPressed: () {
              if (formKey.currentState!.validate()) {
                onValidate();
              }
            },
          ),
        ),
      ],
    );
  }
}
