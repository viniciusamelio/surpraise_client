import 'package:blurple/widgets/buttons/buttons.dart';
import 'package:blurple/widgets/input/base_input.dart';
import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../../../core/external_dependencies.dart';
import '../../../../shared/shared.dart';
import '../controllers/controllers.dart';

class EditNameSheetTabOrganism extends StatefulWidget {
  const EditNameSheetTabOrganism({super.key});

  @override
  State<EditNameSheetTabOrganism> createState() =>
      _EditNameSheetTabOrganismState();
}

class _EditNameSheetTabOrganismState extends State<EditNameSheetTabOrganism> {
  late final TextEditingController nameController;
  late final SessionController sessionController;
  late final GlobalKey<FormState> formKey;
  late final EditProfileController controller;

  @override
  void initState() {
    sessionController = injected();
    nameController = TextEditingController(
      text: sessionController.currentUser!.name,
    );
    formKey = GlobalKey<FormState>();
    controller = injected();

    controller.state.on<SuccessState>((value) {
      if (mounted) {
        const SuccessSnack(message: "Perfil atualizado").show(context: context);
        Navigator.of(context).pop();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheetMolecule(
      child: AtomObserver(
          atom: controller.state,
          builder: (context, state) {
            if (state is LoadingState) {
              return const LoaderMolecule();
            }
            return Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Editar nome",
                    style: context.theme.fontScheme.h3.copyWith(
                      color: context.theme.colorScheme.inputForegroundColor,
                    ),
                  ),
                  SizedBox(
                    height: context.theme.spacingScheme.verticalSpacing,
                  ),
                  BaseInput(
                    controller: nameController,
                    validator: (v) => name(v ?? ""),
                    hintText: "Nome",
                  ),
                  SizedBox(
                    height: context.theme.spacingScheme.verticalSpacing * 2,
                  ),
                  BaseButton.text(
                    text: "Enviar",
                    backgroundColor: context.theme.colorScheme.accentColor,
                    foregroundColor: Colors.white,
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        controller.update(
                          EditUserInput(
                            id: sessionController.currentUser!.id,
                            name: nameController.text,
                            tag: sessionController.currentUser!.tag,
                            email: sessionController.currentUser!.email,
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            );
          }),
    );
  }
}
