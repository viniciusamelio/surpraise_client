import 'package:flutter/material.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';
import 'package:popover/popover.dart';
import '../../../contexts/community/community.dart';
import '../../../core/core.dart';
import '../presentation.dart';

class FloatingAddButton extends StatelessWidget {
  const FloatingAddButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showPopover(
          context: context,
          direction: PopoverDirection.top,
          backgroundColor: context.theme.colorScheme.elevatedWidgetsColor,
          bodyBuilder: (context) {
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _MenuItemRowMolecule(
                    label: "Nova comunidade",
                    icon: HeroiconsSolid.userGroup,
                    action: () {
                      Navigator.of(context).pop();
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        useSafeArea: true,
                        enableDrag: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        builder: (context) => const SaveCommunitySheet(),
                      );
                    },
                  ),
                  _MenuItemRowMolecule(
                    label: "Novo praise",
                    icon: HeroiconsSolid.hashtag,
                    action: () {
                      Navigator.of(context).pop();
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        useSafeArea: true,
                        enableDrag: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        builder: (context) => const NewPraiseSheet(),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
      elevation: 0,
      disabledElevation: 0,
      backgroundColor: context.theme.colorScheme.accentColor,
      foregroundColor: context.theme.colorScheme.borderColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          16,
        ),
      ),
      mini: true,
      child: const Icon(
        HeroiconsOutline.plus,
        size: 18,
      ),
    );
  }
}

class _MenuItemRowMolecule extends StatelessWidget {
  const _MenuItemRowMolecule({
    required this.icon,
    required this.label,
    required this.action,
  });
  final IconData icon;
  final VoidCallback action;
  final String label;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: action,
      splashColor: context.theme.colorScheme.accentColor.withOpacity(.4),
      highlightColor: context.theme.colorScheme.accentColor.withOpacity(.2),
      borderRadius: BorderRadius.circular(
        context.theme.radiusScheme.buttonRadius,
      ),
      child: Padding(
        padding: context.theme.spacingScheme.inputPadding,
        child: Row(
          children: [
            Icon(
              icon,
              size: 24,
            ),
            SizedBox(
              width: context.theme.spacingScheme.verticalSpacing,
            ),
            Text(label),
          ],
        ),
      ),
    );
  }
}
