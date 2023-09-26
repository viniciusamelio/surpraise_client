import 'package:blurple/sizes/radius.dart';
import 'package:blurple/sizes/spacings.dart';
import 'package:blurple/themes/theme_data.dart';
import 'package:blurple/tokens/color_tokens.dart';
import 'package:blurple/widgets/badge/base_badge.dart';
import 'package:blurple/widgets/buttons/buttons.dart';
import 'package:blurple/widgets/input/base_input.dart';
import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../../../core/external_dependencies.dart';
import '../../../../shared/presentation/controllers/session.dart';
import '../../../../shared/presentation/molecules/molecules.dart';
import '../../community.dart';
import '../../dtos/dtos.dart';

class CommunityDetailsScreen extends StatefulWidget {
  const CommunityDetailsScreen({
    super.key,
    required this.community,
  });
  static const String routeName = "/community";
  final CommunityOutput community;
  @override
  State<CommunityDetailsScreen> createState() => _CommunityDetailsScreenState();
}

class _CommunityDetailsScreenState extends State<CommunityDetailsScreen> {
  BlurpleThemeData get theme => context.theme;
  late final CommunityDetailsController controller;
  late bool owner;

  @override
  void initState() {
    controller = injected();
    controller.getMembers(id: widget.community.id);
    owner = injected<SessionController>().currentUser.value?.id ==
        widget.community.ownerId;
    controller.leaveState.on<SuccessState>((_) {
      injected<ApplicationEventBus>().add(const LeftCommunityEvent());
      Navigator.pop(context);
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            _HeaderOrganism(
              theme: theme,
              community: widget.community,
            ),
            PolymorphicAtomObserver<
                DefaultState<Exception, List<FindCommunityMemberOutput>>>(
              atom: controller.state,
              types: [
                TypedAtomHandler(
                  type:
                      LoadingState<Exception, List<FindCommunityMemberOutput>>,
                  builder: (context, state) => const LoaderMolecule(),
                ),
                TypedAtomHandler(
                  type: ErrorState<Exception, List<FindCommunityMemberOutput>>,
                  builder: (context, state) => const SizedBox.shrink(),
                ),
                TypedAtomHandler(
                    type: SuccessState<Exception,
                        List<FindCommunityMemberOutput>>,
                    builder: (context, value) {
                      final List<FindCommunityMemberOutput> data =
                          (value as SuccessState).data;

                      return AtomObserver(
                          atom: controller.memberFilter,
                          builder: (context, filter) {
                            final members = data
                                .where(
                                  (element) =>
                                      element.name.toLowerCase().contains(
                                            filter.toLowerCase().trim(),
                                          ) ||
                                      element.tag.toLowerCase().contains(
                                            filter.toLowerCase().trim(),
                                          ),
                                )
                                .toList();
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: Spacings.lg,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    height: Spacings.xxl * 2,
                                  ),
                                  actionsRow(
                                    members: members,
                                    context: context,
                                  ),
                                  AtomObserver(
                                    atom: controller.showSearchbar,
                                    builder: (context, state) {
                                      return AnimatedSize(
                                        curve: Curves.bounceInOut,
                                        duration:
                                            const Duration(milliseconds: 300),
                                        child: Visibility(
                                          visible: state,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8),
                                            child: BaseInput(
                                              hintText: "Pesquisar @ do membro",
                                              hintStyle: theme.fontScheme.input,
                                              onChanged: (value) {
                                                controller.memberFilter
                                                    .set(value);
                                              },
                                              suffixIcon: Padding(
                                                padding:
                                                    const EdgeInsets.all(4),
                                                child: SizedBox.square(
                                                  dimension: 24,
                                                  child: BorderedIconButton(
                                                    padding:
                                                        const EdgeInsets.all(0),
                                                    onPressed: () {
                                                      controller.memberFilter
                                                          .set("");
                                                      controller.showSearchbar
                                                          .set(
                                                        false,
                                                      );
                                                    },
                                                    borderSide: BorderSide.none,
                                                    preffixIcon: const Icon(
                                                      HeroiconsMini.xMark,
                                                      size: 20,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  SizedBox(
                                    height: Spacings.xl,
                                  ),
                                  SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height * .6,
                                    child: GridView.builder(
                                      physics: const BouncingScrollPhysics(),
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                      ),
                                      itemCount: members.length,
                                      semanticChildCount: members.length,
                                      itemBuilder: (context, index) => SizedBox(
                                        height: 62,
                                        width: 62,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SizedBox.square(
                                              dimension: 50,
                                              child: CircleAvatar(
                                                backgroundImage:
                                                    CachedNetworkImageProvider(
                                                  getAvatarFromId(
                                                    members[index].id,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: Spacings.xs,
                                            ),
                                            Text(
                                              members[index].tag,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: theme.colorScheme
                                                    .inputForegroundColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          });
                    })
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget actionsRow({
    required List<FindCommunityMemberOutput> members,
    required BuildContext context,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        BaseBadge.text(
          label: members.length.toString(),
          topSpacing: -20,
          rightSpacing: -24,
          child: const Text(
            "Membros",
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
        Row(
          children: [
            SizedBox.square(
              dimension: 36,
              child: BorderedIconButton(
                onPressed: () {
                  ConfirmSnack(
                    leadingIcon: Icon(
                      HeroiconsMini.arrowLeftOnRectangle,
                      size: 24,
                      color: theme.colorScheme.dangerColor,
                    ),
                    message:
                        "Tem certeza que deseja sair de ${widget.community.title}?",
                    onConfirm: () async {
                      await controller.leave(
                        communityId: widget.community.id,
                      );
                    },
                  ).show(
                    context: context,
                  );
                },
                padding: EdgeInsets.zero,
                foregroundColor: theme.colorScheme.dangerColor,
                preffixIcon: Icon(
                  HeroiconsOutline.arrowLeftOnRectangle,
                  size: 22,
                  color: theme.colorScheme.dangerColor,
                ),
              ),
            ),
            SizedBox(
              width: Spacings.sm,
            ),
            SizedBox.square(
              dimension: 36,
              child: BorderedIconButton(
                onPressed: () {
                  controller.showSearchbar.set(!controller.showSearchbar.value);
                },
                padding: EdgeInsets.zero,
                foregroundColor: theme.colorScheme.dangerColor,
                preffixIcon: Icon(
                  HeroiconsOutline.magnifyingGlass,
                  size: 22,
                  color: theme.colorScheme.accentColor,
                ),
              ),
            ),
            SizedBox(
              width: owner ? Spacings.sm : 0,
            ),
            Visibility(
              visible: owner,
              child: SizedBox.square(
                dimension: 36,
                child: BorderedIconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      builder: (context) => InviteMemberSheet(
                        communityId: widget.community.id,
                      ),
                    );
                  },
                  padding: EdgeInsets.zero,
                  foregroundColor: theme.colorScheme.dangerColor,
                  preffixIcon: Icon(
                    HeroiconsOutline.squaresPlus,
                    size: 22,
                    color: theme.colorScheme.successColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _HeaderOrganism extends StatelessWidget {
  const _HeaderOrganism({
    required this.theme,
    required this.community,
  });

  final BlurpleThemeData theme;
  final CommunityOutput community;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .4,
      decoration: BoxDecoration(
        color: ColorTokens.concrete,
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(
            RadiusTokens.xxl,
          ),
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 180,
                      width: 180,
                      margin: const EdgeInsets.only(top: 30),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: CachedNetworkImageProvider(
                            community.image,
                          ),
                        ),
                        border: Border.all(
                          width: 1,
                          color: theme.colorScheme.accentColor,
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  right: 40,
                  top: 30,
                  child: SizedBox.square(
                    dimension: 36,
                    child: BorderedIconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      padding: const EdgeInsets.all(4),
                      preffixIcon: Icon(
                        Icons.close,
                        size: 24,
                        color: theme.colorScheme.dangerColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: Spacings.md,
            ),
            Text(
              community.title,
              style: theme.fontScheme.p2.copyWith(color: Colors.white),
            ),
            SizedBox(
              height: Spacings.xs,
            ),
            Text(
              community.description,
              style: theme.fontScheme.p1,
            )
          ],
        ),
      ),
    );
  }
}
