import 'package:blurple/sizes/spacings.dart';
import 'package:blurple/tokens/color_tokens.dart';
import 'package:blurple/widgets/badge/base_badge.dart';
import 'package:blurple/widgets/tab/tab.dart';
import 'package:blurple/widgets/tab/tab_item.dart';
import 'package:flutter/material.dart';
import 'package:pressable/pressable.dart';
import '../../../../core/core.dart';
import '../../../../core/external_dependencies.dart';
import '../../../../shared/shared.dart';
import '../../../community/community.dart';
import '../../../community/dtos/find_community_dto.dart';
import '../../../feed/presentation/molecules/molecules.dart';
import '../../profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  static const String routeName = "/profile";
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final ProfileController controller;
  late final SessionController sessionController;
  late final PageController pageController;

  @override
  void initState() {
    pageController = PageController();
    sessionController = injected();
    controller = injected();
    controller.getCommunities(sessionController.currentUser!.id);
    controller.getPraises(sessionController.currentUser!.id);
    injected<ApplicationEventBus>().on<CommunityAddedEvent>(
      (_) {
        controller.getCommunities(sessionController.currentUser!.id);
      },
      name: "CommunityAddedHandler",
    );
    injected<ApplicationEventBus>().on<LeftCommunityEvent>(
      (event) {
        controller.getCommunities(sessionController.currentUser!.id);
      },
      name: "LeftCommunityHandler",
    );
    super.initState();
  }

  @override
  void dispose() {
    injected<ApplicationEventBus>().removeListener("CommunityAddedHandler");
    injected<ApplicationEventBus>().removeListener("LeftCommunityHandler");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenPadding = EdgeInsets.symmetric(
      horizontal: Spacings.xxl,
    );
    return Scaffold(
      body: Column(
        children: [
          ProfileHeaderOrganism(
            user: sessionController.currentUser!,
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: screenPadding,
            child: BlurpleTabBar(
              onChangeActive: (index) => pageController.jumpToPage(index),
              items: const [
                DefaultTabItem(
                  isActive: true,
                  child: Text("Meus praises"),
                ),
                DefaultTabItem(
                  isActive: false,
                  child: Text("Comunidades"),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: screenPadding,
              child: PageView(
                controller: pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  AtomObserver(
                    atom: controller.state,
                    builder: (context, state) {
                      if (state is LoadingState) {
                        return const LoaderMolecule();
                      } else if (state is ErrorState) {
                        return const ErrorWidgetMolecule(
                          message: "Deu ruim ao recuperar seus #praises",
                        );
                      }

                      final List<PraiseDto> data = (state as SuccessState).data;
                      return SizedBox(
                        child: ListView.separated(
                          itemCount: data.length,
                          physics: const BouncingScrollPhysics(),
                          separatorBuilder: (context, index) => SizedBox(
                            height: Spacings.md,
                          ),
                          itemBuilder: (context, index) {
                            return PraiseCardMolecule(
                              praise: data[index],
                              mode: PraiseCardMode.profile,
                            );
                          },
                        ),
                      );
                    },
                  ),
                  ValueListenableBuilder(
                    valueListenable: controller.communitiesState,
                    builder: (context, state, _) {
                      if (state is LoadingState) {
                        return const CircularProgressIndicator();
                      }

                      final List<CommunityOutput> data =
                          (state as SuccessState).data;
                      return SizedBox(
                        child: ListView.separated(
                          itemCount: data.length,
                          physics: const BouncingScrollPhysics(),
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            final item = data[index];
                            return _CommunityTileMolecule(item: item);
                          },
                        ),
                      );
                    },
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
                            injected<SessionController>().currentUser?.id ==
                                item.ownerId,
                        child: Padding(
                          padding: EdgeInsets.only(
                            bottom: Spacings.sm,
                          ),
                          child: Transform.scale(
                            scale: .8,
                            child: BaseBadge.text(
                              label: "Admin",
                              accentColor:
                                  context.theme.colorScheme.successColor,
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
