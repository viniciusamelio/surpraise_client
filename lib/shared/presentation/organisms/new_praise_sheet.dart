import 'package:blurple/widgets/buttons/buttons.dart';
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
    communitiesController
        .getCommunities(sessionController.currentUser.value!.id);

    communitiesController.state.listenState(
      onSuccess: (right) {
        final lastInteractedCommunity =
            sessionController.currentUser.value!.lastInteractedCommunity;
        if (lastInteractedCommunity != null &&
            right.any((element) => element.id == lastInteractedCommunity.id)) {
          controller.formData.communityId = lastInteractedCommunity.id;
          controller.formData.communityName = lastInteractedCommunity.title;
          controller.activeStep.set(1);
        } else if (right.length == 1) {
          controller.formData.communityId = right.first.id;
          controller.formData.communityName = right.first.title;

          controller.activeStep.set(1);
        }
      },
    );
    controller.activeStep.listen(
      (value) {
        if (mounted) {
          pageController.jumpToPage(value);
        }
      },
    );
    controller.state.listenState(
      onSuccess: (right) {
        if (right.praiseData != null) {
          injected<SupabaseCloudClient>().supabase.functions.invoke(
                "notificator",
                body: {
                  "praise": {
                    ...right.praiseData!,
                    "private": controller.privatePraise.value,
                  }
                },
                responseType: ResponseType.text,
              );
        }
        const SuccessSnack(
          message: "#praise enviado!",
        ).show(
          context: navigatorKey.currentContext!,
        );
        Future.delayed(const Duration(seconds: 2))
            .whenComplete(() => Navigator.of(context).pop());
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    // player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheetMolecule(
      child: PolymorphicAtomObserver<DefaultState<Exception, void>>(
          atom: controller.state,
          types: [
            TypedAtomHandler<LoadingState<Exception, void>>(
              builder: (context, state) => const LoaderMolecule(),
            ),
          ],
          defaultBuilder: (state) {
            if (state is SuccessState) {
              return Center(
                child: LottieBuilder.asset(
                  "assets/animations/praise.json",
                  height: 300,
                  width: 300,
                  repeat: true,
                ),
              );
            }
            return Stack(
              fit: StackFit.passthrough,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Icon(
                            HeroiconsMini.xMark,
                            size: 32,
                            color: context.theme.colorScheme.foregroundColor,
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
                              sessionController
                                  .setLastInteractedCommunity(community);
                              controller.formData.communityId = community.id;
                              controller.formData.communityName =
                                  community.title;
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
                          dotColor: context
                              .theme.colorScheme.inputForegroundColor
                              .withOpacity(.5),
                          radius: 6,
                        ),
                      ),
                    ),
                  ],
                ),
                AtomObserver(
                    atom: controller.activeStep,
                    builder: (context, page) {
                      return Visibility(
                        visible: page != 0,
                        child: Positioned(
                          left: -32,
                          top: -26,
                          child: BaseButton.icon(
                            onPressed: () {
                              controller.activeStep.set(
                                controller.activeStep.value - 1,
                              );
                            },
                            backgroundColor: Colors.transparent,
                            label: "Voltar",
                            icon: Icon(
                              Icons.chevron_left,
                              size: 40,
                              color: context
                                  .theme.colorScheme.inputForegroundColor,
                            ),
                          ),
                        ),
                      );
                    }),
              ],
            );
          }),
    );
  }
}
