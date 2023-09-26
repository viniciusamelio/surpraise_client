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
  @override
  void initState() {
    editedUserStream = StreamController.broadcast();
    pageController = PageController();
    sessionController = injected();
    controller = injected();
    controller.getCommunities(sessionController.currentUser.value!.id);
    controller.getPraises(sessionController.currentUser.value!.id);
    injected<ApplicationEventBus>().on<CommunityAddedEvent>(
      (_) {
        controller.getCommunities(sessionController.currentUser.value!.id);
      },
      name: "CommunityAddedHandler",
    );
    injected<ApplicationEventBus>().on<LeftCommunityEvent>(
      (event) {
        controller.getCommunities(sessionController.currentUser.value!.id);
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
          AtomObserver(
            atom: sessionController.currentUser,
            builder: (context, user) {
              return ProfileHeaderOrganism(
                user: user!,
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
