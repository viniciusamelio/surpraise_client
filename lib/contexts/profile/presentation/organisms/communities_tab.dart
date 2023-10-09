import 'package:blurple/sizes/spacings.dart';
import 'package:blurple/tokens/color_tokens.dart';
import 'package:blurple/widgets/badge/base_badge.dart';
import 'package:flutter/material.dart';
import 'package:pressable/pressable.dart';

import '../../../../core/core.dart';
import '../../../../core/external_dependencies.dart';
import '../../../../shared/shared.dart';
import '../../../community/community.dart';
import '../../../community/dtos/dtos.dart';

class CommunitiesTabOrganism extends StatelessWidget {
  const CommunitiesTabOrganism({
    super.key,
    required this.state,
  });
  final ValueNotifier<DefaultState<Exception, List<CommunityOutput>>> state;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: state,
      builder: (context, state, _) {
        if (state is LoadingState) {
          return const LoaderMolecule();
        } else if (state is ErrorState) {
          return const ErrorWidgetMolecule(
            message: "Deu ruim ao recuperar suas comunidadas",
          );
        }

        final List<CommunityOutput> data = (state as SuccessState).data;
        return SizedBox(
          child: ListView.separated(
            itemCount: data.length,
            physics: const BouncingScrollPhysics(),
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final item = data[index];
              return _CommunityTileMolecule(item: item);
            },
          ),
        );
      },
    );
  }
}

class _CommunityTileMolecule extends StatelessWidget {
  const _CommunityTileMolecule({
    required this.item,
  });

  final CommunityOutput item;

  @override
  Widget build(BuildContext context) {
    return Pressable.scale(
      onPressed: () {
        Navigator.of(context).pushNamed(
          CommunityDetailsScreen.routeName,
          arguments: item,
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: Spacings.md - 2,
          horizontal: Spacings.md,
        ),
        decoration: BoxDecoration(
          color: ColorTokens.concrete,
          borderRadius: BorderRadius.circular(
            8,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: context.theme.colorScheme.accentColor,
                  width: 3,
                ),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: CachedNetworkImageProvider(
                    item.image,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: Spacings.sm,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          item.title,
                          style: context.theme.fontScheme.p2
                              .copyWith(color: Colors.white),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Visibility(
                        visible:
                            [Role.admin, Role.moderator].contains(item.role),
                        child: Padding(
                          padding: EdgeInsets.only(
                            bottom: Spacings.sm,
                          ),
                          child: Transform.scale(
                            scale: .8,
                            child: BaseBadge.text(
                              label: item.role.display,
                              accentColor: item.role == Role.admin
                                  ? context.theme.colorScheme.successColor
                                  : context.theme.colorScheme.infoColor,
                              child: Container(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: Spacings.xs,
                  ),
                  Text(
                    item.description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: context.theme.fontScheme.p1,
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Icon(
                HeroiconsSolid.chevronRight,
                size: 24,
                color: context.theme.colorScheme.accentColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
