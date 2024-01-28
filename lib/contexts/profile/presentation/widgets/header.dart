import 'package:blurple/widgets/buttons/buttons.dart';
import 'package:flutter/material.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:sizer/sizer.dart';

import '../../../../colors.dart';
import '../../../../core/core.dart';
import '../../../../shared/dtos/dtos.dart';
import '../../../../shared/presentation/organisms/organisms.dart';
import '../organisms/organisms.dart';

class ProfileHeaderOrganism extends StatelessWidget {
  const ProfileHeaderOrganism({
    super.key,
    required this.user,
    required this.onRemoveAvatarConfirmed,
    required this.uploadAction,
  }) : super();
  final UserDto user;
  final VoidCallback uploadAction;
  final VoidCallback onRemoveAvatarConfirmed;

  Future<Color> getImagePalette(ImageProvider imageProvider) async {
    final PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(imageProvider);
    if (paletteGenerator.dominantColor == null) {
      return paletteGenerator.vibrantColor?.color ?? purple;
    }
    return paletteGenerator.dominantColor!.color;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getImagePalette(
          user.cachedAvatar != null
              ? FileImage(user.cachedAvatar!)
              : NetworkImage(user.avatarUrl!) as ImageProvider,
        ),
        builder: (context, snapshot) {
          final backgroundColor = snapshot.data ?? purple;
          return Stack(
            children: [
              Container(
                height: 13.5.h,
                color: backgroundColor,
                width: double.maxFinite,
              ),
              SizedBox(
                width: double.maxFinite,
                child: Padding(
                  padding: EdgeInsets.only(top: 5.h, left: 24),
                  child: SingleChildScrollView(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          fit: StackFit.passthrough,
                          children: [
                            AvatarMolecule(
                              size: 30.w,
                              iconSize: 66,
                              image: user.cachedAvatar,
                              imageUrl: user.avatarUrl,
                            ),
                            Positioned(
                              bottom: 0,
                              left: 10.w,
                              child: SizedBox.square(
                                dimension: 36,
                                child: BorderedIconButton(
                                  padding: EdgeInsets.all(1.w),
                                  preffixIcon: Icon(
                                    HeroiconsSolid.cloudArrowUp,
                                    color:
                                        context.theme.colorScheme.accentColor,
                                    size: 24,
                                  ),
                                  onPressed: uploadAction,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 2.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                                      color:
                                          backgroundColor.computeLuminance() <
                                                  .5
                                              ? Colors.white
                                              : Colors.black,
                                    ),
                                  ),
                                  Positioned(
                                    right: -26,
                                    top: 0,
                                    child: SizedBox.square(
                                      dimension: 20,
                                      child: BorderedIconButton(
                                        onPressed: () {},
                                        borderRadius: 4,
                                        backgroundColor: context
                                            .theme.colorScheme.backgroundColor,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.all(4),
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
                            SizedBox(
                              height: 1.h,
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 2.h),
                              child: Text(
                                user.tag,
                                style: context.theme.fontScheme.h3.copyWith(
                                  color: context
                                      .theme.colorScheme.inputForegroundColor,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }
}
