import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../contexts/community/community.dart';
import '../../../core/core.dart';
import '../../shared.dart';

class NewPraiseSheet extends StatefulWidget {
  const NewPraiseSheet({super.key});

  @override
  State<NewPraiseSheet> createState() => _NewPraiseSheetState();
}

class _NewPraiseSheetState extends State<NewPraiseSheet> {
  late final PraiseController controller;
  late final GetCommunitiesController communitiesController;
  late final SessionController sessionController;
  late final PageController pageController;

  @override
  void initState() {
    pageController = PageController();
    sessionController = injected();
    controller = injected();
    communitiesController = injected();
    communitiesController.getCommunities(sessionController.currentUser!.id);
    controller.activeStep.addListener(
      () {
        pageController.jumpToPage(controller.activeStep.value);
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    controller.activeStep.value = 0;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(16),
        ),
        color: context.theme.colorScheme.elevatedWidgetsColor,
      ),
      padding: const EdgeInsets.only(
        bottom: 12,
        top: 24,
        right: 24,
        left: 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: pageController,
              children: [
                NewPraiseCommunitySelectionStep(
                  notifier: communitiesController.state,
                  onCommunitySelected: (community) {
                    controller.formData.communityId = community.id;
                    controller.activeStep.value = 1;
                  },
                ),
                NewPraiseUserSelectionStep(
                  controller: controller,
                ),
                NewPraiseUserSelectionStep(
                  controller: controller,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          ValueListenableBuilder(
            valueListenable: controller.activeStep,
            builder: (context, index, _) => SmoothPageIndicator(
              controller: pageController,
              count: 3,
              effect: WormEffect(
                activeDotColor: context.theme.colorScheme.accentColor,
                dotColor: context.theme.colorScheme.inputForegroundColor
                    .withOpacity(.5),
                radius: 6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
