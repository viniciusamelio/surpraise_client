import 'dart:async';

import 'package:blurple/sizes/spacings.dart';
import 'package:blurple/widgets/tab/tab.dart';
import 'package:blurple/widgets/tab/tab_item.dart';
import 'package:flutter/material.dart';
import '../../../../core/core.dart';
import '../../../../core/external_dependencies.dart';
import '../../../../shared/shared.dart';
import '../../../community/community.dart';
import '../../profile.dart';
import '../organisms/organisms.dart';

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
  late final StreamController<EditUserOutput> editedUserStream;
  late final ApplicationEventBus eventBus;
  @override
  void initState() {
    editedUserStream = StreamController.broadcast();
    pageController = PageController();
    eventBus = injected();
    sessionController = injected();
    controller = injected();
    controller.getCommunities(sessionController.currentUser.value!.id);
    controller.getPraises(sessionController.currentUser.value!.id);
    eventBus.on<CommunityAddedEvent>(
      (_) {
        controller.getCommunities(sessionController.currentUser.value!.id);
      },
      name: "CommunityAddedHandler",
    );
    eventBus.on<LeftCommunityEvent>(
      (event) {
        controller.getCommunities(sessionController.currentUser.value!.id);
      },
      name: "LeftCommunityHandler",
    );
    eventBus.on<AvatarRemovedEvent>(
      (event) async {
        sessionController.currentUser.value!.removeAvatar();
        await sessionController.updateUser(
          sessionController.currentUser.value!.copyWith(
            avatarUrl: "",
            cachedAvatar: null,
          ),
        );
        final user = sessionController.currentUser.value!;
        eventBus.add(
          ProfileEditedEvent(
            EditUserOutput(
              tag: user.tag,
              name: user.name,
              email: user.email,
              id: user.id,
            ),
          ),
        );
      },
      name: "AvatarRemovedHandler",
    );
    super.initState();
  }

  @override
  void dispose() {
    injected<ApplicationEventBus>().removeListener("CommunityAddedHandler");
    injected<ApplicationEventBus>().removeListener("LeftCommunityHandler");
    injected<ApplicationEventBus>().removeListener("AvatarRemovedHandler");
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
          MultiAtomObserver(
            atoms: [
              sessionController.currentUser,
              controller.updateAvatarState,
            ],
            builder: (context) {
              final user = sessionController.currentUser;
              final updateAvatarState = controller.updateAvatarState.value;

              if (updateAvatarState is LoadingState) {
                return const LoaderMolecule();
              }

              return ProfileHeaderOrganism(
                user: user.value!,
                uploadAction: () {
                  controller.updateAvatar();
                },
                onRemoveAvatarConfirmed: () {
                  controller.removeAvatar();
                },
              );
            },
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: screenPadding,
            child: BlurpleTabBar(
              onChangeActive: (index) => pageController.jumpToPage(index),
              items: [
                DefaultTabItem(
                  isActive: true,
                  inactiveChild: Text(
                    "Meus praises",
                    style: TextStyle(
                      color: context.theme.colorScheme.inputForegroundColor,
                    ),
                  ),
                  child: const Text(
                    "Meus praises",
                  ),
                ),
                DefaultTabItem(
                  isActive: false,
                  inactiveChild: Text(
                    "Comunidades",
                    style: TextStyle(
                      color: context.theme.colorScheme.inputForegroundColor,
                    ),
                  ),
                  child: const Text(
                    "Comunidades",
                  ),
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
                  ReceivedPraisesTabOrganism(
                    state: controller.state,
                  ),
                  CommunitiesTabOrganism(
                    state: controller.communitiesState,
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
