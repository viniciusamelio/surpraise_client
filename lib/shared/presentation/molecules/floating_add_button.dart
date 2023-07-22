import 'package:flutter/material.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';
import 'package:popover/popover.dart';
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
                    action: () {},
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
                        builder: (context) => ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height * .7,
                          ),
                          child: const NewPraiseSheet(),
                        ),
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
      child: const Icon(HeroiconsOutline.plus),
    );
  }
}

class _MenuItemRowMolecule extends StatelessWidget {
  const _MenuItemRowMolecule({
    Key? key,
    required this.icon,
    required this.label,
    required this.action,
  }) : super(key: key);
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
