import 'package:blurple/sizes/spacings.dart';
import 'package:blurple/themes/theme_data.dart';
import 'package:blurple/widgets/buttons/buttons.dart';
import 'package:blurple/widgets/input/base_dropdown.dart';
import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../../../core/external_dependencies.dart';
import '../../../../shared/shared.dart';

class InviteMemberSheet extends StatefulWidget {
  const InviteMemberSheet({super.key});

  @override
  State<InviteMemberSheet> createState() => _InviteMemberSheetState();
}

class _InviteMemberSheetState extends State<InviteMemberSheet> {
  late final GlobalKey<FormState> formKey;
  late final TextEditingController userFieldController;
  late final TextEditingController roleFieldController;
  @override
  void initState() {
    formKey = GlobalKey<FormState>();
    userFieldController = TextEditingController();
    roleFieldController = TextEditingController();
    super.initState();
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
            UserSearchInput(
              controller: userFieldController,
              hint: "@ do usuário",
              action: () {},
            ),
            SizedBox(
              height: Spacings.md,
            ),
            BaseSearchableDropdown<Role>(
              controller: roleFieldController,
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
              onSuggestionSelected: (value) {},
              suggestionsCallback: (pattern) => Role.values.where(
                (element) => element.name.contains(
                  pattern,
                ),
              ),
            ),
            SizedBox(
              height: Spacings.lg,
            ),
            BaseButton.icon(
              label: "Enviar convite",
              suffixIcon: const Icon(HeroiconsOutline.arrowRightOnRectangle),
              backgroundColor: theme.colorScheme.accentColor,
              foregroundColor: Colors.white,
              onPressed: () {},
            ),
            SizedBox(
              height: Spacings.lg,
            ),
          ],
        ),
      ),
    );
  }
}
