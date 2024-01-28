import 'package:blurple/widgets/buttons/buttons.dart';
import 'package:boxy/flex.dart';
import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../../../core/external_dependencies.dart';
import '../../../../shared/shared.dart';
import '../presentation.dart';

class MemberOptionsSheet extends StatelessWidget {
  const MemberOptionsSheet({
    super.key,
    required this.canRemove,
    required this.member,
    required this.community,
  });

  final bool canRemove;
  final FindCommunityMemberOutput member;
  final CommunityOutput community;

  @override
  Widget build(BuildContext context) {
    return BottomSheetMolecule(
      child: SizedBox(
        width: 80.w,
        child: BoxyColumn(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (canRemove)
              BaseButton.icon(
                label: "Remover",
                backgroundColor: Colors.black45,
                foregroundColor: Colors.white,
                onPressed: () {
                  Navigator.of(context).pop();
                  showCustomModalBottomSheet(
                    context: context,
                    child: RemoveMemberSheet(
                      member: member,
                      community: community,
                    ),
                  );
                },
                icon: const Icon(HeroiconsSolid.trash),
              ),
            SizedBox.square(
              dimension: context.theme.spacingScheme.verticalSpacing,
            ),
            BaseButton.icon(
              label: "Ver praises enviados",
              backgroundColor: Colors.black45,
              foregroundColor: Colors.white,
              onPressed: () {
                Navigator.of(context).pushNamed(
                  PraisesSentScreen.routeName,
                  arguments: PraisesSentArgs(
                    community: community,
                    member: member,
                  ),
                );
              },
              icon: const Icon(HeroiconsSolid.magnifyingGlass),
            ),
            SizedBox.square(
              dimension: context.theme.spacingScheme.verticalSpacing,
            ),
          ],
        ),
      ),
    );
  }
}
