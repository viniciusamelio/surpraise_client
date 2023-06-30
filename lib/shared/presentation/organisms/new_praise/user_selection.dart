import 'package:blurple/widgets/buttons/buttons.dart';
import 'package:blurple/widgets/input/base_input.dart';
import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../../shared.dart';

class NewPraiseUserSelectionStep extends StatefulWidget {
  const NewPraiseUserSelectionStep({
    super.key,
    required this.controller,
  });

  final PraiseController controller;

  @override
  State<NewPraiseUserSelectionStep> createState() =>
      _NewPraiseUserSelectionStepState();
}

class _NewPraiseUserSelectionStepState
    extends State<NewPraiseUserSelectionStep> {
  late final TextEditingController userFieldController;
  @override
  void initState() {
    userFieldController = TextEditingController();
    widget.controller.userState.listenState(
      onSuccess: (right) {
        widget.controller.activeStep.value = 2;
        widget.controller.formData.praisedId = right.id;
        userFieldController.text = right.tag;
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return DefaultStateBuilder(
        state: widget.controller.userState,
        onLoading: (state) => const CircularProgressIndicator(),
        builder: (context, userState) {
          return ValueListenableBuilder(
              valueListenable: widget.controller.activeStep,
              builder: (context, state, _) {
                return Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      BaseInput(
                        hintText: "@ de quem vai receber o #praise",
                        hintStyle: context.theme.fontScheme.input,
                        controller: userFieldController,
                        enabled: state == 1,
                        suffixIcon: SizedBox(
                          width: 18,
                          height: 18,
                          child: BorderedIconButton(
                            onPressed: () {
                              widget.controller.getUserFromTag(
                                  "@${userFieldController.text.trim().replaceAll('@', '')}");
                            },
                            padding: const EdgeInsets.all(2),
                            preffixIcon: Icon(
                              Icons.search,
                              size: 14,
                              color: context.theme.colorScheme.successColor,
                            ),
                          ),
                        ),
                        onFieldSubmitted: (value) {
                          widget.controller.getUserFromTag(value);
                        },
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      BaseInput(
                        hintText: "Motivo do #praise",
                        hintStyle: context.theme.fontScheme.input,
                        enabled: state == 2,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      BaseInput.large(
                        hintText: "Solta a matraca e elogie com vontade!",
                        minLines: 3,
                        hintStyle: context.theme.fontScheme.input,
                        enabled: state == 2,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: BorderedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              formKey.currentState!.save();
                            }
                          },
                          padding: const EdgeInsets.all(12),
                          borderSide: BorderSide(
                              color: context.theme.colorScheme.accentColor),
                          child: Text(
                            "#praise  >",
                            style: context.theme.fontScheme.input.copyWith(
                              color: context.theme.colorScheme.accentColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              });
        });
  }
}
