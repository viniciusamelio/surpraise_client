import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:blurple/tokens/color_tokens.dart';
import 'package:flutter/material.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';

import '../../../core/core.dart';

class Navbar extends StatelessWidget {
  const Navbar({
    super.key,
    required this.activeIndex,
    required this.onTap,
  });

  final int activeIndex;
  final void Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return AnimatedBottomNavigationBar(
        icons: const [
          HeroiconsSolid.home,
          HeroiconsSolid.user,
          HeroiconsSolid.bell,
          HeroiconsSolid.adjustmentsVertical,
        ],
        borderWidth: 1,
        gapLocation: GapLocation.center,
        borderColor: ColorTokens.greyDarker,
        rightCornerRadius: 8,
        leftCornerRadius: 8,
        notchMargin: 12,
        notchSmoothness: NotchSmoothness.defaultEdge,
        activeIndex: activeIndex,
        blurEffect: true,
        backgroundColor: ColorTokens.concrete,
        activeColor: context.theme.colorScheme.accentColor,
        inactiveColor: context.theme.colorScheme.foregroundColor,
        iconSize: 26,
        elevation: 0,
        onTap: (index) {
          if (index != activeIndex) {
            onTap(index);
          }
        },
      );
    });
  }
}
