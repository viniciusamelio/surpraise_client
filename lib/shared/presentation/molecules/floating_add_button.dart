import 'package:flutter/material.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';
import '../../../core/core.dart';
import '../presentation.dart';

class FloatingAddButton extends StatelessWidget {
  const FloatingAddButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
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
      elevation: 0,
      disabledElevation: 0,
      backgroundColor: context.theme.colorScheme.accentColor,
      foregroundColor: context.theme.colorScheme.borderColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          16,
        ),
      ),
      child: const Icon(HeroiconsOutline.plusCircle),
    );
  }
}
