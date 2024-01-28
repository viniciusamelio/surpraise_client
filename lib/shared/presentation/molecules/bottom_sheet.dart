import 'package:flutter/material.dart';

import '../../../core/core.dart';

class BottomSheetMolecule extends StatelessWidget {
  const BottomSheetMolecule({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
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
      ),
    );
  }
}
