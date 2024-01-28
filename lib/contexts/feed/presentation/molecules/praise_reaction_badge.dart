import 'package:animated_emoji/animated_emoji.dart';
import 'package:flutter/material.dart';
import 'package:pressable/pressable.dart';

import '../../../../core/core.dart';
import '../../../../shared/dtos/reaction.dart';
import '../../feed.dart';

class PraiseReactionBadgeMolecule extends StatelessWidget {
  const PraiseReactionBadgeMolecule({
    super.key,
    required this.userReacted,
    required this.reaction,
    required this.reactionCount,
    required this.userId,
    required this.praiseId,
    required this.reactionId,
  });
  final bool userReacted;
  final String reaction;
  final int reactionCount;
  final String userId;
  final String praiseId;
  final String? reactionId;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Pressable.scale(
      onPressed: () {
        final controller = injected<ReactionController>();
        if (controller.reactionState.value is LoadingState) return;

        controller.toggleReaction(
          input: PraiseReactionDto(
            userId: userId,
            praiseId: praiseId,
            reaction: reaction,
            id: reactionId,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 6,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          borderRadius: theme.radiusScheme.buttonRadius.toBorderRadius(),
          color: userReacted
              ? theme.colorScheme.foregroundColor.withOpacity(.05)
              : Colors.transparent,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Opacity(
              opacity: userReacted ? 1 : .6,
              child: AnimatedEmoji(
                AnimatedEmojiData(
                  reaction,
                  name: reaction,
                ),
                size: 24,
                repeat: userReacted,
              ),
            ),
            const SizedBox(
              width: 4,
            ),
            Text(
              reactionCount.toString(),
              style: TextStyle(
                color: userReacted ? Colors.white : null,
              ),
            )
          ],
        ),
      ),
    );
  }
}
