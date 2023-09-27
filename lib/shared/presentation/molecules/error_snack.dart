import 'package:blurple/themes/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';

class ErrorSnack extends StatelessWidget {
  const ErrorSnack({
    super.key,
    required this.message,
  });

  final String message;

  @override
  SnackBar build(BuildContext context) {
    final BlurpleThemeData theme = BlurpleThemeData.of(context);
    return SnackBar(
      backgroundColor: theme.colorScheme.dangerColor,
      behavior: SnackBarBehavior.floating,
      content: ListTile(
        leading: const Icon(HeroiconsSolid.xCircle, color: Colors.white),
        title: Text(
          "Oops..",
          style: theme.fontScheme.p2.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          message,
          style: theme.fontScheme.p2.copyWith(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Future<void> show({
    required BuildContext context,
  }) async {
    ScaffoldMessenger.of(context).showSnackBar(
      build(context),
    );
  }
}
