import 'package:blurple/themes/theme_data.dart';
import 'package:blurple/tokens/color_tokens.dart';
import 'package:flutter/material.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';

class SuccessSnack extends StatelessWidget {
  const SuccessSnack({
    super.key,
    required this.message,
    this.title = "Sucesso!",
    this.duration = 4,
  });

  final String message;
  final String title;
  final int duration;

  @override
  SnackBar build(BuildContext context) {
    final BlurpleThemeData theme = BlurpleThemeData.of(context);
    return SnackBar(
      backgroundColor: ColorTokens.concrete,
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: duration),
      elevation: 0,
      content: ListTile(
        leading: Icon(
          HeroiconsSolid.checkCircle,
          color: theme.colorScheme.successColor,
        ),
        title: Text(
          title,
          style: theme.fontScheme.p2.copyWith(
            color: theme.colorScheme.successColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          message,
          style: theme.fontScheme.p2.copyWith(
            color: theme.colorScheme.successColor,
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
