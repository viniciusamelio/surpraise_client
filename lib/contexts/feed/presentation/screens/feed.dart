import 'dart:async';

import 'package:blurple/sizes/spacings.dart';
import 'package:blurple/themes/theme_data.dart';
import 'package:blurple/widgets/buttons/buttons.dart';
import 'package:flutter/material.dart';
import '../../../../core/external_dependencies.dart';
import '../../../community/community.dart';
import '../../../praise/praise.dart';
import '../../application/events/events.dart';
import '../../dtos/dtos.dart';
import '../../feed.dart';
import '../molecules/molecules.dart';
import '../../../../core/core.dart';

import '../../../../shared/shared.dart';
import '../organisms/organisms.dart';
import 'feed_scroll_controller.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({
    super.key,
    required this.user,
  });
  static const String routeName = '/feed';

  final UserDto user;
  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  late final SessionController sessionController;
  late final FeedController controller;
  late final AnswerInviteController answerInviteController;
  late final StreamController<EditUserOutput> profileEditedStream;
  late final FeedScrollController scrollController;
  late final ApplicationEventBus eventBus;

  @override
  void initState() {
    initDependencies();
    setupListeners();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (controller.state.value is InitialState) {
      final userId = sessionController.currentUser.value!.id;
      controller.getInvites(userId);
      controller.getPraises(userId);
      controller.listenToInvites(userId);
      controller.listenToPraises(userId);
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    eventBus.removeListener("inviteAnsweredHandler");
    eventBus.removeListener("praiseSentHandler");
    eventBus.removeListener("editedProfileHandler");
    eventBus.removeListener("leftCommunityHandler");

    super.dispose();
  }

  BlurpleThemeData get theme => context.theme;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () async {
              await controller
                  .getLatestPraises(sessionController.currentUser.value!.id);
            },
            color: theme.colorScheme.infoColor,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              controller: scrollController,
              padding: EdgeInsets.all(
                Spacings.lg,
              ),
              child: Column(
                children: [
                  const UserDisplayer(),
                  SizedBox(
                    height: Spacings.lg,
                  ),
                  Text.rich(
                    TextSpan(
                      text: "Aqui você consegue ver os ",
                      style: context.theme.fontScheme.p2.copyWith(fontSize: 16),
                      children: [
                        TextSpan(
                          text: "#praises ",
                          style: context.theme.fontScheme.p2.copyWith(
                            fontSize: 16,
                            color: context.theme.colorScheme.accentColor,
                            fontWeight: FontWeight.w700,
                          ),
                          children: [
                            TextSpan(
                              style: context.theme.fontScheme.p2
                                  .copyWith(fontSize: 16),
                              text:
                                  "recentes.\nQue tal mandar um pra aquele parça que sempre te ajuda no trampo? ",
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: Spacings.lg,
                  ),
                  AtomObserver(
                    atom: controller.invitesState,
                    builder: (context, state) {
                      if (state is! SuccessState) {
                        return const SizedBox.shrink();
                      }
                      final List<InviteDto> data = (state as SuccessState).data;
                      if (data.isEmpty) return const SizedBox.shrink();
                      return InvitesSectionOrganism(
                        data: data,
                        answerInviteController: answerInviteController,
                      );
                    },
                  ),
                  PolymorphicAtomObserver<
                      DefaultState<Exception, List<PraiseDto>>>(
                    atom: controller.state,
                    types: [
                      TypedAtomHandler(
                        type: ErrorState<Exception, List<PraiseDto>>,
                        builder: (context, state) {
                          return Column(
                            children: [
                              const ErrorWidgetMolecule(
                                message: "Deu ruim ao recuperar seu feed",
                              ),
                              SizedBox(
                                height: Spacings.md,
                              ),
                              BorderedButton(
                                onPressed: () {
                                  controller.getPraises(
                                    sessionController.currentUser.value!.id,
                                  );
                                },
                                foregroundColor: theme.colorScheme.dangerColor,
                                text: "Tentar novamente",
                              ),
                            ],
                          );
                        },
                      ),
                      TypedAtomHandler(
                        type: SuccessState<Exception, List<PraiseDto>>,
                        builder: (context, state) {
                          final List<PraiseDto> data =
                              controller.loadedPraises.value;

                          if (data.isEmpty) {
                            return Column(
                              children: [
                                LottieBuilder.asset(
                                  "assets/animations/empty-state.json",
                                  height: 280,
                                ),
                                Text(
                                  "Parece que você não tem novos #praises por aqui, que tal começar enviando um?! É só apertar o botão abaixo",
                                  style: context.theme.fontScheme.p2.copyWith(
                                    fontSize: 18,
                                    color: context
                                        .theme.colorScheme.foregroundColor,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            );
                          }
                          return StreamBuilder<void>(
                              stream: controller.newFeedItems.stream,
                              builder: (context, snapshot) {
                                return SizedBox(
                                  height: (160 * data.length).toDouble(),
                                  child: ListView.separated(
                                    itemCount: data.length,
                                    shrinkWrap: false,
                                    physics: const BouncingScrollPhysics(),
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(
                                      height: 20,
                                    ),
                                    itemBuilder: (context, index) =>
                                        PraiseCardMolecule(
                                      praise: data[index],
                                    ),
                                  ),
                                );
                              });
                        },
                      ),
                    ],
                    defaultBuilder: (state) {
                      return const LoaderMolecule();
                    },
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: MediaQuery.of(context).size.height / 2 - 160,
            child: Visibility(
              visible: false,
              child: GestureDetector(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.horizontal(
                          left: Radius.circular(8)),
                      color: context.theme.colorScheme.elevatedWidgetsColor),
                  child: Icon(
                    Icons.filter_alt_outlined,
                    size: 24,
                    color: context.theme.colorScheme.accentColor.withAlpha(200),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void initDependencies() {
    profileEditedStream = StreamController.broadcast();
    scrollController = FeedScrollController();
    sessionController = injected();
    controller = injected();
    answerInviteController = injected();
    eventBus = injected();
  }

  void setupListeners() {
    eventBus.on<InviteAnsweredEvent>(
      (event) {
        final List<InviteDto> invites = (controller.invitesState.value
                as SuccessState<Exception, List<InviteDto>>)
            .data;
        invites.removeWhere((element) => element.id == event.data);
        controller.invitesState.set(
          SuccessState(invites),
        );
        const SuccessSnack(
          message: "Convite respondido",
          duration: 2,
        ).show(context: context);
        resetFeed();
      },
      name: "inviteAnsweredHandler",
    );

    eventBus.on<LeftCommunityEvent>(
      (event) {
        resetFeed();
      },
      name: "leftCommunityHandler",
    );

    eventBus.on<PraiseSentEvent>(
      (event) async {
        controller.getLatestPraises(sessionController.currentUser.value!.id);
      },
      name: "praiseSentHandler",
    );

    controller.state.listenState(
      onSuccess: (right) {
        if (scrollController.positions.isNotEmpty) scrollController.restore();
      },
    );

    scrollController.addListener(() async {
      if (scrollController.positions.isNotEmpty &&
          scrollController.position.atEdge) {
        bool isTop = scrollController.position.pixels == 0;
        if (!isTop &&
            controller.state.value is SuccessState &&
            (controller.state.value as SuccessState).data.length > 0 &&
            (controller.state.value as SuccessState).data.length ==
                controller.max) {
          scrollController.saveCurrentPosition();
          controller.offset.set(controller.offset.value + controller.max);
          controller.getPraises(sessionController.currentUser.value!.id);
        }
      }
    });
  }

  void resetFeed() {
    controller.offset.set(0);
    controller.loadedPraises.value.clear();
    controller.getPraises(
      sessionController.currentUser.value!.id,
    );
  }
}
