import 'package:blurple/tokens/size_tokens.dart';
import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../../../core/external_dependencies.dart';
import '../../../../shared/shared.dart';

enum PraiseCardMode {
  feed,
  profile;

  bool isFeed() => this == PraiseCardMode.feed;
}

class PraiseCardMolecule extends StatelessWidget {
  const PraiseCardMolecule({
    super.key,
    this.mode = PraiseCardMode.feed,
    required this.praise,
  });
  final PraiseDto praise;
  final PraiseCardMode mode;

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
          _CardHeader(
            praise: praise,
            mode: mode,
          ),
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
    required this.mode,
  });

  final PraiseDto praise;
  final PraiseCardMode mode;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final SessionController sessionController = injected();

    final UserDto praised =
        praise.praised ?? sessionController.currentUser.value!;
    return Row(
      children: [
        SizedBox.square(
          dimension: 40,
          child: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(
              getAvatarFromId(
                mode.isFeed() ? praised.id : praise.praiser.id,
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
                mode.isFeed() ? praised.tag : praise.praiser.tag,
                style: theme.fontScheme.p2.copyWith(
                  color: theme.colorScheme.accentColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text.rich(
                TextSpan(
                    text: mode.isFeed() ? "Recebeu um " : "Enviou um ",
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
                        text: TopicValues.fromString(praise.topic).value,
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
