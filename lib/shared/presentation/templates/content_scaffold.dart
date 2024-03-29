import 'package:flutter/material.dart';

import '../../../core/extensions/theme.dart';
import '../molecules/molecules.dart';

class AuthScaffoldTemplate extends StatelessWidget {
  const AuthScaffoldTemplate({
    super.key,
    this.title,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    required this.child,
  });

  final String? title;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      body: SafeArea(
        child: SingleChildScrollView(
          padding:
              EdgeInsets.all(context.theme.spacingScheme.verticalSpacing * 4),
          child: Column(
            children: [
              DefaultAppbar(title: title),
              SizedBox(
                height: context.theme.spacingScheme.verticalSpacing * 6,
              ),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
