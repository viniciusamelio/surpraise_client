import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../../../core/external_dependencies.dart';
import '../../../../shared/shared.dart';
import '../../../feed/application/events/events.dart';
import '../../../feed/presentation/molecules/praise_card.dart';
import '../../community.dart';

class PraisesSentScreen extends StatefulWidget {
  const PraisesSentScreen({
    super.key,
    required this.args,
  });
  static String routeName = "/community/praises_sent";
  final PraisesSentArgs args;
  @override
  State<PraisesSentScreen> createState() => _PraisesSentScreenState();
}

class _PraisesSentScreenState extends State<PraisesSentScreen> {
  CommunityOutput get community => widget.args.community;
  FindCommunityMemberOutput get member => widget.args.member;

  late final PraisesSentController controller;
  late final SessionController sessionController;
  late final ApplicationEventBus eventBus;

  @override
  void initState() {
    controller = injected();
    sessionController = injected();
    eventBus = injected();
    fetch();

    eventBus.on<ReactionAddedEvent>(
      (event) {
        controller.addReaction(event.data);
      },
      name: "reactionAddedHandler",
    );
    eventBus.on<ReactionRemovedEvent>(
      (event) {
        controller.removeReaction(event.data);
      },
      name: "reactionRemovedHandler",
    );
    super.initState();
  }

  @override
  dispose() {
    eventBus.removeListener("reactionAddedHandler");
    eventBus.removeListener("reactionRemovedHandler");
    super.dispose();
  }

  void fetch() {
    controller.get(
      communityId: community.id,
      userId: sessionController.currentUser.value!.id,
      praisedId: member.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.theme.colorScheme.backgroundColor,
        elevation: 0,
        title: Text(
          member.name,
          style: context.theme.fontScheme.h3.copyWith(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: AtomObserver(
          atom: controller.state,
          builder: (context, state) {
            if (state is LoadingState) {
              return const LoaderMolecule();
            } else if (state is ErrorState) {
              return ErrorWidgetMolecule(
                message:
                    "Deu ruim ao recuperar os praises enviados para ${member.tag}",
              );
            }
            final data =
                (state as SuccessState<Exception, List<PraiseDto>>).data;
            if (data.isEmpty) {
              return EmptyStateOrganism(
                message:
                    "Parece que você não enviou nenhum praise para ${member.tag} ainda",
              );
            }
            return ListView.separated(
              itemBuilder: (context, index) => PraiseCardMolecule(
                praise: data[index],
                reactionsEnabled: true,
                mode: PraiseCardMode.feed,
                private: data[index].private,
              ),
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemCount: data.length,
            );
          },
        ),
      ),
    );
  }
}

class PraisesSentArgs {
  const PraisesSentArgs({
    required this.community,
    required this.member,
  });

  final CommunityOutput community;
  final FindCommunityMemberOutput member;
}
