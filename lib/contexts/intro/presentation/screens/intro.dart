import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../../../shared/presentation/molecules/loader.dart';
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
    controller.handleFirstPage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: LoaderMolecule());
  }
}
