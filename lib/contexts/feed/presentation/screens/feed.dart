import 'package:blurple/sizes/spacings.dart';
import 'package:blurple/themes/theme_data.dart';
import 'package:flutter/material.dart';
import '../../../../core/external_dependencies.dart';
import '../../../praise/praise.dart';
import '../../application/events/events.dart';
import '../../dtos/dtos.dart';
import '../../feed.dart';
import '../molecules/molecules.dart';
import '../../../../core/core.dart';

import '../../../../shared/shared.dart';
import '../organisms/organisms.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({
    super.key,
    required this.user,
  });
  static const String routeName = '/feed/';

  final UserDto user;
  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  late final SessionController sessionController;
  late final FeedController controller;
  late final AnswerInviteController answerInviteController;

  @override
  void initState() {
    sessionController = injected();
    controller = injected();
    answerInviteController = injected();

    injected<ApplicationEventBus>().on<InviteAnsweredEvent>(
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
      },
      name: "inviteAnsweredHandler",
    );

    injected<ApplicationEventBus>().on<PraiseSentEvent>((event) {
      controller.getPraises(sessionController.currentUser!.id);
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    sessionController.currentUser = widget.user;
    if (controller.state.value is InitialState) {
      controller.getPraises(sessionController.currentUser!.id);
      controller.getInvites(sessionController.currentUser!.id);
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    injected<ApplicationEventBus>().removeListener("inviteAnsweredHandler");
    super.dispose();
  }

  BlurpleThemeData get theme => context.theme;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.all(
              Spacings.lg,
            ),
            child: Column(
              children: [
                UserDisplayer(
                  user: sessionController.currentUser!,
                ),
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
                    if (state is! SuccessState) return const SizedBox.shrink();
                    final List<InviteDto> data = (state as SuccessState).data;
                    if (data.isEmpty) return const SizedBox.shrink();
                    return InvitesSectionOrganism(
                      data: data,
                      answerInviteController: answerInviteController,
                    );
                  },
                ),
                AtomObserver<DefaultState>(
                  atom: controller.state,
                  builder: (context, state) {
                    if (state is LoadingState || state is InitialState) {
                      return const CircularProgressIndicator();
                    } else if (state is ErrorState) {
                      return const ErrorWidgetMolecule(
                        message: "Deu ruim ao recuperar seu feed",
                      );
                    }

                    final List<PraiseDto> data = (state as SuccessState).data;

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
                              color: context.theme.colorScheme.foregroundColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      );
                    }
                    return SizedBox(
                      height: (300 * data.length).toDouble(),
                      child: ListView.separated(
                        itemCount: data.length,
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 20,
                        ),
                        itemBuilder: (context, index) =>
                            PraiseCardMolecule(praise: data[index]),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            bottom: MediaQuery.of(context).size.height / 2 - 160,
            child: GestureDetector(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    borderRadius:
                        const BorderRadius.horizontal(left: Radius.circular(8)),
                    color: context.theme.colorScheme.elevatedWidgetsColor),
                child: Icon(
                  Icons.filter_alt_outlined,
                  size: 24,
                  color: context.theme.colorScheme.accentColor.withAlpha(200),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
