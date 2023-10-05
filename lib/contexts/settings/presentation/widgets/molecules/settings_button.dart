import 'package:blurple/sizes/spacings.dart';
import 'package:blurple/widgets/buttons/buttons.dart';
import 'package:flutter/widgets.dart';

import '../../../../../core/extensions/theme.dart';

class SettingsButton extends StatelessWidget {
  const SettingsButton({
    super.key,
    required this.onPressed,
    required this.label,
    required this.icon,
    required this.foregroundColor,
  });
  final VoidCallback onPressed;
  final String label;
  final Icon icon;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    final buttonPadding = EdgeInsets.symmetric(
      horizontal: Spacings.xl,
      vertical: Spacings.md,
    );
    final theme = context.theme;

    return BorderedIconButton(
      onPressed: onPressed,
      text: label,
      preffixIcon: icon,
      padding: buttonPadding,
      foregroundColor: foregroundColor,
      borderRadius: 4,
      backgroundColor: theme.colorScheme.elevatedWidgetsColor.withOpacity(.8),
      borderSide: const BorderSide(
        width: 1,
        color: Color(0xFF343336),
      ),
    );
  }
}
