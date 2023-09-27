import 'package:blurple/tokens/color_tokens.dart';
import 'package:blurple/widgets/buttons/buttons.dart';
import 'package:flutter/material.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';

import '../../../../core/core.dart';
import '../../../../shared/dtos/dtos.dart';
import '../../../../shared/presentation/molecules/confirm_snack.dart';
import '../../../../shared/presentation/organisms/organisms.dart';
import '../organisms/organisms.dart';

class ProfileHeaderOrganism extends StatelessWidget {
  const ProfileHeaderOrganism({
    Key? key,
    required this.user,
    required this.onRemoveAvatarConfirmed,
    required this.uploadAction,
  }) : super(key: key);
  final UserDto user;
  final VoidCallback uploadAction;
  final VoidCallback onRemoveAvatarConfirmed;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 285,
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
                      AvatarMolecule(
                        size: 180,
                        iconSize: 66,
                        image: user.avatar,
                        imageUrl: user.avatarUrl,
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
                                dimension: 36,
                                child: BorderedIconButton(
                                  padding: const EdgeInsets.all(2),
                                  preffixIcon: Icon(
                                    HeroiconsSolid.cloudArrowUp,
                                    color:
                                        context.theme.colorScheme.accentColor,
                                    size: 24,
                                  ),
                                  onPressed: uploadAction,
                                ),
                              ),
                              const SizedBox(
                                width: 6,
                              ),
                              SizedBox.square(
                                dimension: 36,
                                child: BorderedIconButton(
                                  padding: const EdgeInsets.all(2),
                                  preffixIcon: Icon(
                                    Icons.close,
                                    color:
                                        context.theme.colorScheme.dangerColor,
                                    size: 24,
                                  ),
                                  onPressed: () async {
                                    ConfirmSnack(
                                            leadingIcon: Icon(
                                              HeroiconsMini.camera,
                                              color: context.theme.colorScheme
                                                  .inputForegroundColor,
                                            ),
                                            message:
                                                "Tem certeza que quer remover o avatar?",
                                            onConfirm: onRemoveAvatarConfirmed)
                                        .show(
                                      context: context,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
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
