import 'package:flutter/material.dart';
import 'package:surpraise_client/core/extensions/theme.dart';

import '../molecules/molecules.dart';

class ContentScaffoldTemplate extends StatelessWidget {
  const ContentScaffoldTemplate({
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
              DefaultAppbarMolecule(title: title),
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
