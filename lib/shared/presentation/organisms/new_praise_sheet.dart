import 'package:flutter/material.dart';

import '../../../contexts/community/community.dart';
import '../../../core/core.dart';
import '../../../core/external_dependencies.dart';
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
    controller.activeStep.listen(
      (value) {
        if (mounted) {
          pageController.jumpToPage(value);
        }
      },
    );
    controller.state.listenState(
      onSuccess: (right) {
        const SuccessSnack(message: "Praise enviado!").show(context: context);
        Navigator.of(context).pop();
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheetMolecule(
      child: PolymorphicAtomObserver<DefaultState<Exception, void>>(
          atom: controller.state,
          types: [
            TypedAtomHandler(
              type: LoadingState,
              builder: (context, state) => const LoaderMolecule(),
            ),
          ],
          defaultBuilder: (state) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        HeroiconsMini.xMark,
                        size: 32,
                      ),
                    )
                  ],
                ),
                Flexible(
                  child: PageView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: pageController,
                    children: [
                      NewPraiseCommunitySelectionStep(
                        notifier: communitiesController.state,
                        onCommunitySelected: (community) {
                          controller.formData.communityId = community.id;
                          controller.activeStep.set(1);
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
                AtomObserver(
                  atom: controller.activeStep,
                  builder: (context, index) => SmoothPageIndicator(
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
            );
          }),
    );
  }
}
