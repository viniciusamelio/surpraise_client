import 'package:blurple/tokens/color_tokens.dart';
import 'package:blurple/widgets/badge/base_badge.dart';
import 'package:flutter/material.dart';

import '../../../contexts/notification/notification.dart';
import '../../../core/core.dart';
import '../../../core/external_dependencies.dart';

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
      return AtomObserver(
          atom: injected<NotificationsController>().unreadNotifications,
          builder: (context, state) {
            return BaseBadge.text(
              label: state.toString(),
              rightSpacing: MediaQuery.of(context).size.width * .22,
              topSpacing: -10,
              backgroundColor: state > 0 ? null : Colors.transparent,
              accentColor: state > 0
                  ? context.theme.colorScheme.warningColor
                  : Colors.transparent,
              child: AnimatedBottomNavigationBar(
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
              ),
            );
          });
    });
  }
}
