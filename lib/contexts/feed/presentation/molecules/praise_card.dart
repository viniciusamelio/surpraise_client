import 'package:blurple/themes/theme_data.dart';
import 'package:blurple/tokens/size_tokens.dart';
import 'package:flutter/material.dart';
import 'package:pressable/pressable.dart';

import '../../../../colors.dart';
import '../../../../core/core.dart';
import '../../../../core/external_dependencies.dart';
import '../../../../shared/shared.dart';
import '../organisms/praise_reaction.dart';
import 'molecules.dart';

enum PraiseCardMode {
  feed,
  profile;

  bool isFeed() => this == PraiseCardMode.feed;
}

class PraiseCardMolecule extends StatelessWidget {
  const PraiseCardMolecule({
    super.key,
    this.mode = PraiseCardMode.feed,
    this.private = false,
    this.reactionsEnabled = false,
    required this.praise,
  });
  final PraiseDto praise;
  final PraiseCardMode mode;
  final bool private;
  final bool reactionsEnabled;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Pressable.scale(
      onLongPressed: () {
        if (reactionsEnabled) {
          showPopover(
            context: context,
            backgroundColor: context.theme.colorScheme.elevatedWidgetsColor,
            bodyBuilder: (context) => PraiseReactionOrganism(praise: praise),
          );
        }
      },
      child: Container(
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
              private: private,
            ),
            Divider(
              color: theme.colorScheme.inputForegroundColor,
              height: 28,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Text(
                praise.message,
                style: theme.fontScheme.p2,
              ),
            ),
            SizedBox(
              height: SizeTokens.md,
            ),
            Visibility(
              visible: mode.isFeed() && reactionsEnabled,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: _PraiseReactionsRow(praise: praise),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: SizeTokens.sm,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "#${praise.communityName}",
                textAlign: TextAlign.right,
                style: theme.fontScheme.p1.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PraiseReactionsRow extends StatelessWidget {
  const _PraiseReactionsRow({
    required this.praise,
  });

  final PraiseDto praise;

  @override
  Widget build(BuildContext context) {
    final List<String> emojisAlreadyReactByUser = [];

    return Wrap(
      runSpacing: 4,
      spacing: 4,
      children: [
        ...praise.reactions.groupBy((item) => item.reaction).values.map(
          (e) {
            final reactionMadeByUser = e.where((element) =>
                element.userId ==
                injected<SessionController>().currentUser.value!.id);

            final userReactedWithThis = reactionMadeByUser.isNotEmpty;
            if (userReactedWithThis) {
              emojisAlreadyReactByUser.add(reactionMadeByUser.first.reaction);
            }

            return PraiseReactionBadgeMolecule(
              userReacted: userReactedWithThis,
              reaction: e.first.reaction,
              reactionId: reactionMadeByUser.firstOrNull?.id,
              reactionCount: e.length,
              userId: injected<SessionController>().currentUser.value!.id,
              praiseId: e.first.praiseId,
            );
          },
        ),
        Visibility(
          visible:
              praise.reactions.groupBy((item) => item.reaction).values.length <
                  7,
          child: Pressable.scale(
            onPressed: () {
              showPopover(
                context: context,
                backgroundColor: context.theme.colorScheme.elevatedWidgetsColor,
                bodyBuilder: (context) => PraiseReactionOrganism(
                  praise: praise,
                  reactionsToBeHidden: emojisAlreadyReactByUser,
                ),
              );
            },
            child: _AddReactionButton(praise: praise),
          ),
        ),
      ],
    );
  }
}

class _AddReactionButton extends StatelessWidget {
  const _AddReactionButton({
    required this.praise,
  });

  final PraiseDto praise;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: praise.reactions.isEmpty ? .5 : 1,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: context.theme.colorScheme.inputBackgroundColor
                  .withOpacity(.5),
              borderRadius: 8.toBorderRadius(),
            ),
            child: Icon(
              Icons.emoji_emotions,
              color: context.theme.colorScheme.foregroundColor.withOpacity(.6),
              size: 24,
            ),
          ),
          Positioned(
            bottom: 24,
            right: -8,
            child: Icon(
              HeroiconsSolid.plusCircle,
              color: context.theme.colorScheme.accentColor,
              size: 16,
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
    required this.private,
  });

  final PraiseDto praise;
  final PraiseCardMode mode;
  final bool private;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final SessionController sessionController = injected();

    final UserDto praised =
        praise.praised ?? sessionController.currentUser.value!;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox.square(
          dimension: 40,
          child: CircleAvatar(
            backgroundImage:
                sessionController.currentUser.value!.id == praise.praiser.id
                    ? NetworkImage(
                        getAvatarFromId(
                          praise.praiser.id,
                        ),
                      ) as ImageProvider
                    : CachedNetworkImageProvider(
                        getAvatarFromId(
                          praise.praiser.id,
                        ),
                      ),
          ),
        ),
        const SizedBox.square(
          dimension: 8,
        ),
        Visibility(
          visible: mode.isFeed(),
          replacement: profileHeader(praised, theme),
          child: feedHeader(theme),
        ),
      ],
    );
  }

  Widget profileHeader(UserDto praised, BlurpleThemeData theme) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            (mode.isFeed() ? praised.tag : praise.praiser.tag).toLowerCase(),
            style: theme.fontScheme.p2.copyWith(
              color: !private ? theme.colorScheme.accentColor : purple,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text.rich(
            TextSpan(
              text: mode.isFeed() ? "Recebeu um " : "Te enviou um ",
              style: theme.fontScheme.p1,
              children: [
                TextSpan(
                  text: !private ? "#praise " : "#praise_privado ",
                  style: theme.fontScheme.p1.copyWith(
                    color:
                        !private ? theme.colorScheme.accentColor : Colors.white,
                    fontWeight: private ? FontWeight.bold : null,
                  ),
                ),
                TextSpan(text: mode.isFeed() ? "de " : ""),
                TextSpan(
                  text: mode.isFeed()
                      ? "${praise.praiser.tag.toLowerCase()} "
                      : "",
                  style: theme.fontScheme.p1.copyWith(
                    color: purple,
                    fontWeight: FontWeight.bold,
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget feedHeader(BlurpleThemeData theme) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                praise.praiser.tag.toLowerCase(),
                style: theme.fontScheme.p2.copyWith(
                  color: theme.colorScheme.accentColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(right: 4),
                    child: Icon(
                      HeroiconsMini.arrowRight,
                      size: 16,
                    ),
                  ),
                  Visibility(
                    visible: praise.extraPraiseds.isEmpty,
                    replacement: Wrap(
                      children: [
                        SizedBox.square(
                          dimension: 20,
                          child: CircleAvatar(
                            backgroundImage: CachedNetworkImageProvider(
                              getAvatarFromId(
                                praise.praised?.id ?? "",
                              ),
                            ),
                          ),
                        ),
                        ...praise.extraPraiseds.map(
                          (e) => SizedBox.square(
                            dimension: 20,
                            child: CircleAvatar(
                              backgroundImage: CachedNetworkImageProvider(
                                getAvatarFromId(
                                  e,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        SizedBox.square(
                          dimension: 20,
                          child: CircleAvatar(
                            backgroundImage: CachedNetworkImageProvider(
                              getAvatarFromId(
                                praise.praised?.id ?? "",
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          praise.praised?.tag.toLowerCase() ?? "",
                          style: theme.fontScheme.p1.copyWith(
                            color: purple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Visibility(
                          visible: private,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: purple.withOpacity(.75),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              HeroiconsMini.cubeTransparent,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          Text(
            TopicValues.fromString(praise.topic).value,
            style: theme.fontScheme.p1.copyWith(
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
