import 'package:animated_emoji/emoji.dart';
import 'package:animated_emoji/emoji_data.dart';
import 'package:animated_emoji/emojis.g.dart';
import 'package:flutter/material.dart';
import 'package:pressable/pressable.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../../feed.dart';

class PraiseReactionOrganism extends StatefulWidget {
  const PraiseReactionOrganism({
    super.key,
    required this.praise,
    this.reactionsToBeHidden = const [],
  });
  final PraiseDto praise;
  final List<String> reactionsToBeHidden;
  @override
  State<PraiseReactionOrganism> createState() => _PraiseReactionOrganismState();
}

class _PraiseReactionOrganismState extends State<PraiseReactionOrganism> {
  late final List<AnimatedEmojiData> emojiData;

  @override
  void initState() {
    emojiData = [
      AnimatedEmojis.clinkingGlasses,
      AnimatedEmojis.rocket,
      AnimatedEmojis.purpleHeart,
      AnimatedEmojis.armMechanical,
      AnimatedEmojis.fire,
      AnimatedEmojis.heartEyes,
      AnimatedEmojis.clap,
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Container(
      padding: theme.spacingScheme.inputPadding,
      decoration: BoxDecoration(
        borderRadius: theme.radiusScheme.buttonRadius.toBorderRadius(),
        color: Colors.black54,
      ),
      child: Wrap(
        // mainAxisSize: MainAxisSize.min,
        children: emojiData
            .where(
                (element) => !widget.reactionsToBeHidden.contains(element.id))
            .map(
              (e) => Pressable.scale(
                onPressed: () {
                  onEmojiSelected(e);
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: AnimatedEmoji(
                    e,
                    size: 30,
                    repeat: true,
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  void onEmojiSelected(AnimatedEmojiData emoji) {
    final controller = injected<ReactionController>();
    if (controller.reactionState.value is LoadingState) return;

    controller
        .toggleReaction(
          input: PraiseReactionDto(
            userId: injected<SessionController>().currentUser.value!.id,
            praiseId: widget.praise.id,
            reaction: emoji.id,
          ),
        )
        .whenComplete(
          () => Navigator.of(context).pop(),
        );
  }
}
