import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../core/core.dart';

class EmptyStateOrganism extends StatelessWidget {
  const EmptyStateOrganism({
    super.key,
    required this.message,
    this.fontSize,
    this.animationSize,
  });

  final String message;
  final double? fontSize;
  final double? animationSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LottieBuilder.asset(
          "assets/animations/empty-state.json",
          height: animationSize ?? 280,
        ),
        Text(
          message,
          style: context.theme.fontScheme.p2.copyWith(
            fontSize: fontSize ?? 18,
            color: context.theme.colorScheme.foregroundColor,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
