import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../../core/core.dart';
import '../../shared/shared.dart';
import '../feed/feed.dart';
import '../profile/profile.dart';
import '../settings/settings.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  static String routeName = "/main";
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SupabaseGuardRoute {
  late final PageController pageController;

  @override
  void initState() {
    checkSession();
    pageController = PageController(
      initialPage: 0,
    );
    injected<ApplicationEventBus>().on<ProfileEditedEvent>((event) {
      sessionController.updateUser(
        sessionController.currentUser.value!.copyWith(
          name: event.data.name,
          avatarUrl: sessionController.currentUser.value!.avatarUrl,
        ),
      );
    });
    injected<ApplicationEventBus>().on<AvatarRemovedEvent>((event) {
      sessionController.updateUser(
        sessionController.currentUser.value!.copyWith(
          avatarUrl: "",
        ),
      );
    });
    injected<ApplicationEventBus>().on<AvatarUpdatedEvent>((event) {
      sessionController.updateUser(
        sessionController.currentUser.value!.copyWith(
          avatarUrl: getAvatarFromId(sessionController.currentUser.value!.id),
          cachedAvatar: event.data,
        ),
      );
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (sessionController.currentUser.value == null) {
      sessionController.currentUser.set(
        ModalRoute.of(context)!.settings.arguments as UserDto,
      );
      OneSignal.User.addEmail(
        injected<SessionController>().currentUser.value!.email,
      );
      OneSignal.User.addAlias(
        injected<SessionController>().currentUser.value!.tag,
        injected<SessionController>().currentUser.value!.id,
      );
      OneSignal.User.addTags({"segment": "active users"});
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: const FloatingAddButton(),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      bottomNavigationBar: AnimatedBuilder(
          animation: pageController,
          builder: (context, _) {
            return Navbar(
              activeIndex: pageController.page?.toInt() ?? 0,
              onTap: (index) {
                pageController.jumpToPage(index.toInt());
              },
            );
          }),
      body: PageView(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          FeedScreen(
            user: sessionController.currentUser.value!,
          ),
          const ProfileScreen(),
          Container(
            color: context.theme.colorScheme.accentColor,
          ),
          const SettingsScreen(),
        ],
      ),
    );
  }
}
