import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../../core/core.dart';
import '../../shared/shared.dart';
import '../feed/feed.dart';
import '../notification/notification.dart';
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
  late final ApplicationEventBus eventBus;

  @override
  void initState() {
    checkSession();
    eventBus = injected<ApplicationEventBus>();
    pageController = PageController(
      initialPage: 0,
    );
    setupListeners();

    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (sessionController.currentUser.value == null) {
      sessionController.currentUser.set(
        ModalRoute.of(context)!.settings.arguments as UserDto,
      );
      injected<NotificationsController>()
        ..getNotifications()
        ..listen();
      OneSignal.login(injected<SessionController>().currentUser.value!.tag);
      OneSignal.User.addEmail(
        injected<SessionController>().currentUser.value!.email,
      );
      OneSignal.User.addTagWithKey(
        "user_tag",
        injected<SessionController>().currentUser.value!.tag,
      );
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    final bus = eventBus;
    bus.removeListener("ProfileEditedHandler");
    bus.removeListener("AvatarRemovedHandler");
    bus.removeListener("AvatarUpdatedHandler");
    bus.removeListener("ReadNotificationsHandler");
    super.dispose();
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
          const NotificationsScreen(),
          const SettingsScreen(),
        ],
      ),
    );
  }

  void setupListeners() {
    eventBus.on<ProfileEditedEvent>(
      (event) {
        sessionController.updateUser(
          sessionController.currentUser.value!.copyWith(
            name: event.data.name,
            avatarUrl: sessionController.currentUser.value!.avatarUrl,
          ),
        );
      },
      name: "ProfileEditedHandler",
    );
    eventBus.on<AvatarRemovedEvent>(
      (event) {
        sessionController.updateUser(
          sessionController.currentUser.value!.copyWith(
            avatarUrl: "",
          ),
        );
      },
      name: "AvatarRemovedHandler",
    );
    eventBus.on<AvatarUpdatedEvent>(
      (event) {
        sessionController.updateUser(
          sessionController.currentUser.value!.copyWith(
            avatarUrl: getAvatarFromId(sessionController.currentUser.value!.id),
            cachedAvatar: event.data,
          ),
        );
      },
      name: "AvatarUpdatedHandler",
    );
    eventBus.on<ReadNotificationsEvent>(
      (event) {
        final unreadNotifications =
            injected<NotificationsController>().unreadNotifications;

        if (unreadNotifications.value > 20) {
          injected<NotificationsController>().unreadNotifications.set(
                unreadNotifications.value - 20,
              );
        }
        injected<NotificationsController>().unreadNotifications.set(0);
      },
      name: "ReadNotificationsHandler",
    );
  }
}
