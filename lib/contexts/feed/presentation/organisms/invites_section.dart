import 'package:blurple/sizes/spacings.dart';
import 'package:blurple/tokens/color_tokens.dart';
import 'package:blurple/widgets/buttons/buttons.dart';
import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../../../core/external_dependencies.dart';
import '../../../../shared/shared.dart';
import '../../dtos/dtos.dart';
import '../controllers/controllers.dart';

class InvitesSectionOrganism extends StatelessWidget {
  const InvitesSectionOrganism({
    super.key,
    required this.data,
    required this.answerInviteController,
  });

  final List<InviteDto> data;
  final AnswerInviteController answerInviteController;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Container(
      height: 64,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: ColorTokens.concrete,
        borderRadius: BorderRadius.circular(8),
      ),
      child: PageView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: data.length,
        itemBuilder: (context, index) {
          final invite = data[index];
          return SizedBox(
            width: MediaQuery.of(context).size.width - 32,
            child: ListTile(
              leading: Icon(
                HeroiconsSolid.envelopeOpen,
                color: theme.colorScheme.accentColor,
                size: 24,
              ),
              title: Text(
                "Você recebeu um convite para a comunidade ${invite.communityTitle} como ${invite.role.display}",
                style: theme.fontScheme.p1,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox.square(
                    dimension: 32,
                    child: BorderedIconButton(
                      padding: const EdgeInsets.all(0),
                      preffixIcon: Icon(
                        HeroiconsMini.exclamationTriangle,
                        size: 16,
                        color: theme.colorScheme.warningColor,
                      ),
                      onPressed: () {
                        ConfirmSnack(
                          leadingIcon: Icon(
                            HeroiconsMini.exclamationTriangle,
                            size: 24,
                            color: theme.colorScheme.warningColor,
                          ),
                          message: "Deseja mesmo recusar o convite??",
                          onConfirm: () {
                            answerInviteController.answerInvite(
                              inviteId: invite.id,
                              accept: false,
                            );
                          },
                        ).show(
                          context: context,
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    width: Spacings.sm,
                  ),
                  SizedBox.square(
                    dimension: 32,
                    child: BorderedIconButton(
                      padding: const EdgeInsets.all(0),
                      preffixIcon: Icon(
                        HeroiconsMini.checkCircle,
                        size: 16,
                        color: theme.colorScheme.successColor,
                      ),
                      onPressed: () {
                        ConfirmSnack(
                          leadingIcon: Icon(
                            HeroiconsMini.envelopeOpen,
                            size: 24,
                            color: theme.colorScheme.accentColor,
                          ),
                          message: "Deseja mesmo aceitar o convite??",
                          onConfirm: () {
                            answerInviteController.answerInvite(
                              inviteId: invite.id,
                              accept: true,
                            );
                          },
                        ).show(
                          context: context,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
