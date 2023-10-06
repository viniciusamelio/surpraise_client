import 'package:blurple/sizes/spacings.dart';
import 'package:blurple/themes/theme_data.dart';
import 'package:blurple/widgets/buttons/buttons.dart';
import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../../../shared/presentation/molecules/molecules.dart';
import '../../dtos/dtos.dart';

class RemoveMemberSheet extends StatefulWidget {
  const RemoveMemberSheet({
    super.key,
    required this.member,
  });
  final FindCommunityMemberOutput member;
  @override
  State<RemoveMemberSheet> createState() => _RemoveMemberSheetState();
}

class _RemoveMemberSheetState extends State<RemoveMemberSheet> {
  FindCommunityMemberOutput get member => widget.member;
  BlurpleThemeData get theme => context.theme;
  @override
  Widget build(BuildContext context) {
    return BottomSheetMolecule(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text.rich(
            TextSpan(text: "Remover ", children: [
              TextSpan(
                  text: member.tag,
                  style: theme.fontScheme.h3
                      .copyWith(color: theme.colorScheme.accentColor)),
              const TextSpan(text: " da comunidade?"),
            ]),
            style: theme.fontScheme.h3.copyWith(
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: Spacings.xxl,
          ),
          BorderedButton(
            text: "Confirmar",
            foregroundColor: theme.colorScheme.successColor,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
