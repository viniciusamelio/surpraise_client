import 'package:blurple/tokens/color_tokens.dart';
import 'package:blurple/widgets/buttons/buttons.dart';
import 'package:flutter/material.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';

import '../../../../core/core.dart';
import '../../../../shared/dtos/dtos.dart';
import '../organisms/organisms.dart';

class ProfileHeaderOrganism extends StatelessWidget {
  const ProfileHeaderOrganism({
    Key? key,
    required this.user,
  }) : super(key: key);
  final UserDto user;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      width: double.maxFinite,
      child: Stack(
        children: [
          Container(
            height: 125,
            width: double.maxFinite,
            color: context.theme.colorScheme.accentColor,
          ),
          SizedBox(
            width: double.maxFinite,
            child: Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      SizedBox(
                        height: 180,
                        width: 180,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                            user.avatarUrl!,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -12,
                        child: SizedBox(
                          width: 180,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox.square(
                                dimension: 24,
                                child: BorderedIconButton(
                                  padding: const EdgeInsets.all(2),
                                  preffixIcon: Icon(
                                    HeroiconsSolid.cloudArrowUp,
                                    color:
                                        context.theme.colorScheme.accentColor,
                                    size: 12,
                                  ),
                                  onPressed: () {},
                                ),
                              ),
                              const SizedBox(
                                width: 6,
                              ),
                              SizedBox.square(
                                dimension: 24,
                                child: BorderedIconButton(
                                  padding: const EdgeInsets.all(2),
                                  preffixIcon: Icon(
                                    Icons.close,
                                    color:
                                        context.theme.colorScheme.dangerColor,
                                    size: 12,
                                  ),
                                  onPressed: () {},
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      showCustomModalBottomSheet(
                        context: context,
                        child: const EditNameSheetTabOrganism(),
                      );
                    },
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Text(
                          user.name,
                          style: context.theme.fontScheme.h3.copyWith(
                            color: ColorTokens.greyLighter,
                          ),
                        ),
                        Positioned(
                          right: -18,
                          top: 0,
                          child: SizedBox.square(
                            dimension: 14,
                            child: BorderedIconButton(
                              onPressed: () {},
                              borderRadius: 2,
                              backgroundColor:
                                  context.theme.colorScheme.accentColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.all(0),
                              preffixIcon: const Icon(
                                Icons.edit,
                                size: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    user.tag,
                    style: context.theme.fontScheme.h3.copyWith(
                      color: context.theme.colorScheme.inputForegroundColor,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
