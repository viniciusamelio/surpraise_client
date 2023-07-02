import 'package:blurple/widgets/buttons/buttons.dart';
import 'package:blurple/widgets/input/base_dropdown.dart';
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
  late final TextEditingController topicController;
  @override
  void initState() {
    topicController = TextEditingController();
    userFieldController =
        TextEditingController(text: widget.controller.formData.praisedTag);
    widget.controller.userState.listenState(
      onSuccess: (right) {
        widget.controller.activeStep.value = 2;
        widget.controller.formData.praisedId = right.id;
        widget.controller.formData.praisedTag = right.tag;
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
                return SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        BaseInput(
                          hintText: "@ de quem vai receber o #praise",
                          hintStyle: context.theme.fontScheme.input,
                          controller: userFieldController,
                          maxLines: 1,
                          enabled: state == 1,
                          suffixIcon: SizedBox(
                            width: 18,
                            height: 18,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: BorderedIconButton(
                                onPressed: () {
                                  widget.controller.getUserFromTag(
                                    "@${userFieldController.text.trim().replaceAll('@', '')}",
                                  );
                                },
                                padding: const EdgeInsets.all(2),
                                borderSide: BorderSide(
                                  width: 2,
                                  color: state == 1
                                      ? context.theme.colorScheme.accentColor
                                      : Colors.transparent,
                                ),
                                preffixIcon: Icon(
                                  Icons.search,
                                  size: 16,
                                  color: state == 1
                                      ? context.theme.colorScheme.accentColor
                                      : context.theme.colorScheme
                                          .inputForegroundColor,
                                ),
                              ),
                            ),
                          ),
                          onEditingCompleted: () {
                            widget.controller.getUserFromTag(
                                "@${userFieldController.text.trim().replaceAll('@', '')}");
                          },
                        ),
                        userState is ErrorState
                            ? const SizedBox.shrink()
                            : const SizedBox(
                                height: 12,
                              ),
                        Visibility(
                          visible: userState is ErrorState,
                          child: Text(
                            "Não conseguimos encontrar nenhum usuário com o @ especificado",
                            style: context.theme.fontScheme.p1.copyWith(
                              color: context.theme.colorScheme.dangerColor,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        BaseSearchableDropdown<TopicValues>(
                          hint: "Motivo do #praise",
                          controller: topicController,
                          enabled: state == 2,
                          itemBuilder: (context, value) => ListTile(
                            tileColor:
                                context.theme.colorScheme.inputBackgroundColor,
                            title: Text(
                              value.name,
                              style: context.theme.fontScheme.p2.copyWith(
                                color:
                                    context.theme.colorScheme.foregroundColor,
                              ),
                            ),
                          ),
                          onSuggestionSelected: (value) {
                            widget.controller.formData.topic = value.value;
                            topicController.text = value.value;
                          },
                          suggestionsCallback: (pattern) =>
                              TopicValues.values.where(
                            (element) => element.name.contains(
                              pattern,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        BaseInput.large(
                          hintText: "Solta a matraca e elogie com vontade!",
                          validator: (value) => message(value ?? ""),
                          onSaved: (value) =>
                              widget.controller.formData.message = value!,
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
                              if (state == 2 &&
                                  formKey.currentState!.validate()) {
                                if (widget.controller.formData.topic == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const ErrorSnack(
                                            message:
                                                "Precisamos de um motivo para o praise")
                                        .build(context),
                                  );
                                  return;
                                }
                                formKey.currentState!.save();
                                widget.controller.sendPraise(
                                  injected<SessionController>().currentUser!.id,
                                );
                              }
                            },
                            padding: const EdgeInsets.all(12),
                            borderSide: BorderSide(
                              color: state == 2
                                  ? context.theme.colorScheme.accentColor
                                  : context
                                      .theme.colorScheme.inputForegroundColor,
                            ),
                            child: Text(
                              "#praise  >",
                              style: context.theme.fontScheme.input.copyWith(
                                color: state == 2
                                    ? context.theme.colorScheme.accentColor
                                    : context
                                        .theme.colorScheme.inputForegroundColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              });
        });
  }
}

enum TopicValues {
  kind("#kindness"),
  tech("#tech"),
  finance("#finance");

  final String value;
  const TopicValues(this.value);
}
