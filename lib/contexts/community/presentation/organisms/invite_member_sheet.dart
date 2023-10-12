import 'package:blurple/sizes/spacings.dart';
import 'package:blurple/themes/theme_data.dart';
import 'package:blurple/tokens/color_tokens.dart';
import 'package:blurple/widgets/buttons/buttons.dart';
import 'package:blurple/widgets/input/base_dropdown.dart';
import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../../../core/external_dependencies.dart';
import '../../../../shared/shared.dart';
import '../../community.dart';

class InviteMemberSheet extends StatefulWidget {
  const InviteMemberSheet({
    super.key,
    required this.communityId,
  });
  final String communityId;
  @override
  State<InviteMemberSheet> createState() => _InviteMemberSheetState();
}

class _InviteMemberSheetState extends State<InviteMemberSheet> {
  late final InviteController controller;

  late final GlobalKey<FormState> formKey;
  late final TextEditingController userFieldController;
  late final TextEditingController roleFieldController;
  @override
  void initState() {
    controller = injected();
    formKey = GlobalKey<FormState>();
    userFieldController = TextEditingController();
    roleFieldController = TextEditingController();

    roleFieldController.addListener(() {
      final text = roleFieldController.text;
      if (text != controller.selectedRole.value?.display) {
        controller.selectedRole.set(null);
      }
    });

    controller.state
        .on<SuccessState<Exception, InviteMemberOutput>>((value) async {
      if (mounted) {
        final message =
            "Convite enviado para ${(controller.userSearchState.value as SuccessState).data.tag}";
        SuccessSnack(
          message: message,
        ).show(context: context);
        Navigator.of(context).pop();
      }
    });

    controller.state
        .on<ErrorState<Exception, InviteMemberOutput>>((error) async {
      if (mounted) {
        String message = "Deu ruim ao convidar ${userFieldController.text}";
        if (error.exception is DomainException) {
          message = injected<TranslationService>()
              .get((error.exception as DomainException).message);
        }
        ErrorSnack(
          message: message,
        ).show(context: context);
        Navigator.of(context).pop();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  BlurpleThemeData get theme => context.theme;

  @override
  Widget build(BuildContext context) {
    return BottomSheetMolecule(
      child: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Novo membro",
              style: theme.fontScheme.h3.copyWith(color: Colors.white),
            ),
            SizedBox(
              height: Spacings.lg,
            ),
            AtomObserver(
                atom: controller.userSearchState,
                builder: (context, state) {
                  return UserSearchInput(
                    controller: userFieldController,
                    hint: "@ do usuário",
                    borderColor: state is ErrorState
                        ? theme.colorScheme.dangerColor
                        : state is SuccessState
                            ? theme.colorScheme.successColor
                            : null,
                    iconColor: state is ErrorState
                        ? theme.colorScheme.dangerColor
                        : state is SuccessState
                            ? theme.colorScheme.successColor
                            : null,
                    errorText:
                        state is ErrorState ? "Usuário não encontrado" : null,
                    action: () async {
                      if (userFieldController.text.isEmpty) {
                        return;
                      }
                      await searchUser();
                    },
                  );
                }),
            SizedBox(
              height: Spacings.md,
            ),
            AtomObserver(
                atom: controller.selectedRole,
                builder: (context, role) {
                  return GestureDetector(
                    onTap: searchUser,
                    child: BaseSearchableDropdown<Role>(
                      direction: AxisDirection.up,
                      controller: roleFieldController
                        ..text = role?.display ?? "",
                      hint: "Cargo do membro",
                      itemBuilder: (context, value) => ListTile(
                        tileColor: theme.colorScheme.inputBackgroundColor,
                        title: Text(
                          value.display,
                          style: theme.fontScheme.p2.copyWith(
                            color: theme.colorScheme.foregroundColor,
                          ),
                        ),
                      ),
                      onSuggestionSelected: (value) {
                        controller.selectedRole.set(value);
                      },
                      suggestionsCallback: (pattern) => Role.values.where(
                        (element) => element.name.contains(
                          pattern,
                        ),
                      ),
                    ),
                  );
                }),
            SizedBox(
              height: Spacings.lg,
            ),
            MultiAtomObserver(
                atoms: [
                  controller.selectedRole,
                  controller.userSearchState,
                ],
                builder: (context) {
                  bool buttonEnabled = controller.selectedRole.value != null &&
                      controller.userSearchState.value is SuccessState;
                  return BaseButton.icon(
                    label: "Enviar convite",
                    suffixIcon:
                        const Icon(HeroiconsOutline.arrowRightOnRectangle),
                    backgroundColor: buttonEnabled
                        ? theme.colorScheme.accentColor
                        : ColorTokens.concrete.withOpacity(.5),
                    foregroundColor:
                        buttonEnabled ? Colors.white : Colors.white54,
                    onPressed: () {
                      if (buttonEnabled) {
                        controller.invite(
                          memberId:
                              (controller.userSearchState.value as SuccessState)
                                  .data
                                  .id,
                          role: controller.selectedRole.value!,
                          communityId: widget.communityId,
                        );
                      }
                    },
                  );
                }),
            SizedBox(
              height: Spacings.lg,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> searchUser() {
    return controller.getUserFromTag(
      userFieldController.text.replaceAll(
        "@",
        "",
      ),
    );
  }
}
