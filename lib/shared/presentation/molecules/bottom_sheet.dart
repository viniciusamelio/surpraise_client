import 'package:flutter/material.dart';

import '../../../core/core.dart';

class BottomSheetMolecule extends StatelessWidget {
  const BottomSheetMolecule({Key? key, required this.child}) : super(key: key);
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(16),
        ),
        color: context.theme.colorScheme.inputBackgroundColor,
      ),
      padding: const EdgeInsets.only(
        bottom: 12,
        top: 24,
        right: 24,
        left: 24,
      ),
      child: child,
    );
  }
}
