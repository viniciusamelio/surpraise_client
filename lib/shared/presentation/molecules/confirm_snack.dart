import 'package:blurple/sizes/spacings.dart';
import 'package:blurple/themes/theme_data.dart';
import 'package:blurple/tokens/color_tokens.dart';
import 'package:blurple/widgets/buttons/buttons.dart';
import 'package:flutter/material.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';

class ConfirmSnack extends StatelessWidget {
  const ConfirmSnack({
    super.key,
    required this.leadingIcon,
    required this.message,
    required this.onConfirm,
    this.onCancel,
    this.title = "Confirmar?",
  });

  final String message;
  final String title;
  final Icon leadingIcon;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;

  @override
  SnackBar build(BuildContext context) {
    final BlurpleThemeData theme = BlurpleThemeData.of(context);
    return SnackBar(
      backgroundColor: ColorTokens.shadow,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: theme.colorScheme.borderColor,
          width: .2,
        ),
      ),
      content: ListTile(
        leading: leadingIcon,
        subtitle: Text(
          message,
          style: theme.fontScheme.p2.copyWith(
            color: Colors.white,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox.square(
              dimension: 32,
              child: BorderedIconButton(
                padding: const EdgeInsets.all(0),
                preffixIcon: Icon(
                  HeroiconsMini.xMark,
                  size: 16,
                  color: theme.colorScheme.dangerColor,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  if (onCancel != null) {
                    onCancel!();
                  }
                },
              ),
            ),
            SizedBox(
              width: Spacings.sm,
            ),
            SizedBox.square(
              dimension: 32,
              child: BorderedIconButton(
                padding: const EdgeInsets.all(0),
                preffixIcon: Icon(
                  HeroiconsMini.checkCircle,
                  size: 16,
                  color: theme.colorScheme.successColor,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  onConfirm();
                },
              ),
            ),
          ],
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
