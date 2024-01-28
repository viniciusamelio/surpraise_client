import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../../../core/external_dependencies.dart';
import '../../../../shared/presentation/molecules/molecules.dart';
import '../controllers/intro.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});
  static const String routeName = "/";
  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  late final IntroController controller;

  @override
  void initState() {
    controller = injected();
    controller.state.on<ErrorState<Exception, bool>>(
      (value) {
        String message = "Deu ruim ao iniciar o app";
        if (value.exception is ApplicationException) {
          message = (value.exception as ApplicationException).message;
        }
        ErrorSnack(message: message).show(context: context);
      },
    );
    controller.handleFirstPage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFF210F4F),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Animate(
            effects: const [
              FadeEffect(duration: Duration(milliseconds: 300)),
              ScaleEffect(
                delay: Duration(milliseconds: 300),
                duration: Duration(
                  milliseconds: 400,
                ),
              ),
            ],
            child: Image.asset("assets/images/logo_original.png"),
          ),
        ),
      ),
    );
  }
}
