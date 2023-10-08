import 'package:blurple/sizes/spacings.dart';
import 'package:blurple/themes/theme_data.dart';
import 'package:blurple/widgets/buttons/buttons.dart';
import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../../../core/external_dependencies.dart';
import '../../../../shared/presentation/molecules/molecules.dart';
import '../../application/application.dart';
import '../../dtos/dtos.dart';
import '../controllers/remove_member.dart';

class RemoveMemberSheet extends StatefulWidget {
  const RemoveMemberSheet({
    super.key,
    required this.member,
    required this.community,
  });
  final FindCommunityMemberOutput member;
  final CommunityOutput community;
  @override
  State<RemoveMemberSheet> createState() => _RemoveMemberSheetState();
}

class _RemoveMemberSheetState extends State<RemoveMemberSheet> {
  FindCommunityMemberOutput get member => widget.member;
  BlurpleThemeData get theme => context.theme;

  late final RemoveMemberController controller;

  @override
  void initState() {
    controller = injected();
    controller.state.listenState(
      onSuccess: (right) {
        if (mounted) {
          const SuccessSnack(message: "Usuário removido")
              .show(context: context);
          injected<ApplicationEventBus>().add(
            MemberRemovedEvent(
              widget.member,
            ),
          );
          Navigator.of(context).pop();
        }
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    controller.state.removeListeners();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheetMolecule(
      child: PolymorphicAtomObserver<DefaultState<Exception, void>>(
        atom: controller.state,
        types: [
          TypedAtomHandler(
            type: LoadingState<Exception, void>,
            builder: (context, state) => const LoaderMolecule(),
          )
        ],
        defaultBuilder: (context) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text.rich(
              TextSpan(text: "Remover ", children: [
                TextSpan(
                    text: member.tag,
                    style: theme.fontScheme.h3
                        .copyWith(color: theme.colorScheme.accentColor)),
                const TextSpan(text: " da comunidade?"),
              ]),
              style: theme.fontScheme.h3.copyWith(
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: Spacings.xxl,
            ),
            BorderedButton(
              text: "Confirmar",
              foregroundColor: theme.colorScheme.successColor,
              onPressed: () {
                controller.removeMember(
                  member: member,
                  community: widget.community,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
