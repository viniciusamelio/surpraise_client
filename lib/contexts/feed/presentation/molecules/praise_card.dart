import 'package:blurple/tokens/size_tokens.dart';
import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../../../shared/dtos/dtos.dart';

class PraiseCardMolecule extends StatelessWidget {
  const PraiseCardMolecule({
    super.key,
    required this.praise,
  });
  final PraiseDto praise;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.elevatedWidgetsColor,
        borderRadius: BorderRadius.circular(theme.radiusScheme.buttonRadius),
      ),
      child: Column(
        children: [
          _CardHeader(praise: praise),
          Divider(
            color: theme.colorScheme.inputForegroundColor,
            height: 28,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Text(
              praise.message,
              style: theme.fontScheme.p1,
            ),
          ),
          SizedBox(
            height: SizeTokens.md,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              "#${praise.communityName}",
              style: theme.fontScheme.p1.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CardHeader extends StatelessWidget {
  const _CardHeader({
    required this.praise,
  });

  final PraiseDto praise;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Row(
      children: [
        SizedBox.square(
          dimension: 40,
          child: CircleAvatar(
            backgroundImage: NetworkImage(
              getAvatarFromId(
                praise.praised!.id,
              ),
            ),
          ),
        ),
        const SizedBox.square(
          dimension: 10,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                praise.praised!.name,
                style: theme.fontScheme.p2.copyWith(
                  color: theme.colorScheme.accentColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text.rich(
                TextSpan(
                    text: "Recebeu um ",
                    style: theme.fontScheme.p1,
                    children: [
                      TextSpan(
                        text: "#praise ",
                        style: theme.fontScheme.p1.copyWith(
                          color: theme.colorScheme.accentColor,
                        ),
                      ),
                      TextSpan(
                        text: "por ",
                        style: theme.fontScheme.p1,
                      ),
                      TextSpan(
                        text: praise.topic,
                        style: theme.fontScheme.p1.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ]),
              ),
            ],
          ),
        )
      ],
    );
  }
}
