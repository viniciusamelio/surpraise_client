import 'package:flutter/material.dart';

import '../../../core/extensions/theme.dart';
import '../../../core/external_dependencies.dart';

class ErrorWidgetMolecule extends StatelessWidget {
  const ErrorWidgetMolecule({
    super.key,
    required this.message,
  });
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LottieBuilder.asset(
            "assets/animations/error.json",
            height: 180,
            width: 180,
            fit: BoxFit.fill,
          ),
          Text(
            message,
            style: context.theme.fontScheme.p2.copyWith(
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
