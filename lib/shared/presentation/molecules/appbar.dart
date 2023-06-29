import 'package:blurple/widgets/buttons/buttons.dart';
import 'package:flutter/material.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';

import '../../../core/extensions/theme.dart';

class DefaultAppbar extends StatelessWidget {
  const DefaultAppbar({
    super.key,
    this.action,
    required this.title,
  });

  final String? title;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Visibility(
          visible: Navigator.of(context).canPop(),
          child: SizedBox.square(
            dimension: 48,
            child: BaseButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
              },
              padding: const EdgeInsets.all(0),
              backgroundColor: context.theme.colorScheme.elevatedWidgetsColor,
              icon: const Icon(
                HeroiconsSolid.chevronLeft,
                size: 24,
              ),
            ),
          ),
        ),
        Text(
          title ?? "",
          style: context.theme.fontScheme.h3.copyWith(
            color: context.theme.colorScheme.inputForegroundColor,
          ),
        ),
        SizedBox.square(
          dimension: 48,
          child: action ?? const SizedBox.shrink(),
        ),
      ],
    );
  }
}
