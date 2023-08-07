import 'package:flutter/material.dart';

import '../../shared/shared.dart';
import '../feed/feed.dart';
import '../profile/profile.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  static String routeName = "/main";
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late final PageController pageController;

  @override
  void initState() {
    pageController = PageController(
      initialPage: 0,
    );
    super.initState();
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
        children: const [
          FeedScreen(),
          ProfileScreen(),
        ],
      ),
    );
  }
}
