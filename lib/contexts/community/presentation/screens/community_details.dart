import 'dart:async';

import 'package:blurple/sizes/radius.dart';
import 'package:blurple/sizes/spacings.dart';
import 'package:blurple/themes/theme_data.dart';
import 'package:blurple/tokens/color_tokens.dart';
import 'package:blurple/widgets/badge/base_badge.dart';
import 'package:blurple/widgets/buttons/buttons.dart';
import 'package:flutter/material.dart';
import 'package:pressable/pressable.dart';

import '../../../../core/core.dart';
import '../../../../core/external_dependencies.dart';
import '../../../../shared/shared.dart';
import '../../community.dart';

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
  late final StreamController<CreateCommunityOutput> updatedCommunity;
  late Role role;
  late final ApplicationEventBus eventBus;

  @override
  void initState() {
    controller = injected();
    controller.getMembers(id: widget.community.id);
    role = widget.community.role;
    updatedCommunity = StreamController.broadcast();
    eventBus = injected();
    controller.leaveState.listenState(onSuccess: (_) {
      eventBus.add(const LeftCommunityEvent());
      if (mounted) {
        Navigator.pop(context);
      }
    }, onError: (error) {
      if (mounted) {
        String message = "Deu ruim ao sair da comunidade";
        if (error is DomainException) {
          message = injected<TranslationService>().get(error.message);
        }
        ErrorSnack(message: message).show(context: context);
      }
    });
    eventBus.on<CommunitySavedEvent>(
      (event) {
        if (mounted) {
          updatedCommunity.add(
            event.data,
          );
          Navigator.pop(context);
        }
      },
      name: "UpdatedCommunityHandler",
    );
    eventBus.on<MemberRemovedEvent>(
      (event) {
        final data = ((controller.state.value as SuccessState).data
            as List<FindCommunityMemberOutput>);
        data.removeWhere((element) => element.id == event.data.id);
        controller.state.set(
          SuccessState(
            data,
          ),
        );
      },
      name: "RemoveMemberHandler",
    );

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    eventBus.removeListener("UpdatedCommunityHandler");
    eventBus.removeListener("RemoveMemberHandler");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            StreamBuilder<CreateCommunityOutput>(
              stream: updatedCommunity.stream,
              initialData: CreateCommunityOutput(
                id: widget.community.id,
                description: widget.community.description,
                title: widget.community.title,
                members: [
                  {},
                ],
                ownerId: widget.community.ownerId,
              ),
              builder: (context, snapshot) {
                return _HeaderOrganism(
                  theme: theme,
                  community: CommunityOutput(
                    id: snapshot.data!.id,
                    ownerId: snapshot.data!.ownerId,
                    description: snapshot.data!.description,
                    title: snapshot.data!.title,
                    image:
                        "${widget.community.image}?when=${DateTime.now().microsecondsSinceEpoch}",
                    role: role,
                  ),
                );
              },
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
                                  MemberSearchBarOrganism(
                                    controller: controller,
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
                                            Pressable.scale(
                                              onPressed: () {
                                                if (currentUserCanRemoveThisMember(
                                                  community: widget.community,
                                                  member: members[index],
                                                )) {
                                                  showCustomModalBottomSheet(
                                                    context: context,
                                                    child: RemoveMemberSheet(
                                                      member: members[index],
                                                      community:
                                                          widget.community,
                                                    ),
                                                  );
                                                }
                                              },
                                              child: SizedBox.square(
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
                        role: widget.community.role,
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
              width:
                  [Role.admin, Role.moderator].contains(role) ? Spacings.sm : 0,
            ),
            Visibility(
              visible: [Role.admin, Role.moderator].contains(role),
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
      padding: const EdgeInsets.symmetric(horizontal: 12),
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
                          image: CachedNetworkImageProvider(community.image),
                        ),
                        border: Border.all(
                          width: 2,
                          color: theme.colorScheme.accentColor,
                        ),
                      ),
                    ),
                  ],
                ),
                Visibility(
                  visible: community.role == Role.admin,
                  child: Positioned(
                    bottom: 0,
                    right: (MediaQuery.of(context).size.width / 2) - 28,
                    child: SizedBox.square(
                      dimension: 36,
                      child: BorderedIconButton(
                        padding: const EdgeInsets.all(2),
                        preffixIcon: Icon(
                          HeroiconsSolid.pencilSquare,
                          color: context.theme.colorScheme.accentColor,
                          size: 24,
                        ),
                        onPressed: () {
                          showCustomModalBottomSheet(
                            context: context,
                            child: SaveCommunitySheet(
                              community: community,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
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
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: Spacings.xs,
            ),
            Text(
              community.description,
              style: theme.fontScheme.p1,
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
