import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../../../core/external_dependencies.dart';
import '../../../../shared/dtos/dtos.dart';
import '../organisms/praise_reaction.dart';

class PraiseOptionsPopoverMolecule extends StatelessWidget {
  const PraiseOptionsPopoverMolecule({super.key, required this.praise});
  final PraiseDto praise;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: context.theme.spacingScheme.inputPadding,
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * .6,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          context.theme.radiusScheme.buttonRadius,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTapDown: (details) {
              Navigator.of(context).pop();
              showPopover(
                context: context,
                backgroundColor: context.theme.colorScheme.elevatedWidgetsColor,
                bodyBuilder: (context) =>
                    PraiseReactionOrganism(praise: praise),
              );
            },
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  Icons.emoji_emotions,
                  color: context.theme.colorScheme.foregroundColor
                      .withOpacity(.75),
                  size: 24,
                ),
                Positioned(
                  bottom: 16,
                  right: -8,
                  child: Icon(
                    HeroiconsSolid.plusCircle,
                    color: context.theme.colorScheme.accentColor,
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
