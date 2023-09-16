import 'package:blurple/themes/theme_data.dart';
import 'package:blurple/tokens/color_tokens.dart';
import 'package:blurple/widgets/buttons/buttons.dart';
import 'package:blurple/widgets/input/base_dropdown.dart';
import 'package:blurple/widgets/input/base_input.dart';
import 'package:flutter/material.dart';
import 'package:pressable/pressable.dart';

import '../../../../core/core.dart';
import '../../../../core/external_dependencies.dart';
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
        widget.controller.activeStep.set(2);
        widget.controller.formData.praisedId = right.id;
        widget.controller.formData.praisedTag = right.tag;
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    userFieldController.dispose();
    topicController.dispose();
    super.dispose();
  }

  BlurpleThemeData get theme => context.theme;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return PolymorphicAtomObserver(
        atom: widget.controller.userState,
        types: [
          TypedAtomHandler(
              type: LoadingState,
              builder: (context, state) => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 120,
                        height: 120,
                        child: CircularProgressIndicator(
                          color: context.theme.colorScheme.accentColor,
                        ),
                      ),
                    ],
                  ))
        ],
        defaultBuilder: (userState) {
          return AtomObserver(
              atom: widget.controller.activeStep,
              builder: (context, state) {
                return Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AtomObserver(
                        atom: widget.controller.state,
                        builder: (context, state) {
                          // TODO Extract this widget to reuse it where i cant display a snackbar
                          return Visibility(
                            visible: state is ErrorState,
                            child: Container(
                              height: 80,
                              padding: const EdgeInsets.only(
                                bottom: 16,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black12,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ListTile(
                                isThreeLine: true,
                                leading: Icon(
                                  HeroiconsSolid.xCircle,
                                  color: theme.colorScheme.dangerColor,
                                ),
                                title: Text(
                                  "Oops..",
                                  style: theme.fontScheme.p2.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  "${state is ErrorState ? state.exception is ApplicationException ? (state.exception as ApplicationException).message : state.exception : ''}",
                                  style: theme.fontScheme.p2.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                                trailing: Pressable.scale(
                                  onPressed: () {
                                    widget.controller.state.set(InitialState());
                                  },
                                  child: const Icon(
                                    HeroiconsSolid.xMark,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      UserSearchInput(
                        controller: userFieldController,
                        hint: "@ de quem vai receber o #praise",
                        action: () {
                          widget.controller.getUserFromTag(
                            "@${userFieldController.text.trim().replaceAll('@', '')}",
                          );
                        },
                        enabled: state == 1,
                        borderColor: state == 1
                            ? context.theme.colorScheme.accentColor
                            : Colors.transparent,
                        iconColor: state == 1
                            ? context.theme.colorScheme.accentColor
                            : context.theme.colorScheme.inputForegroundColor,
                        errorText: userState is ErrorState
                            ? "Não conseguimos encontrar nenhum usuário com o @ especificado"
                            : null,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: AbsorbPointer(
                              absorbing: state != 2,
                              child: BaseSearchableDropdown<TopicValues>(
                                hint: "Motivo do #praise",
                                controller: topicController,
                                enabled: state == 2,
                                itemBuilder: (context, value) => ListTile(
                                  tileColor: context
                                      .theme.colorScheme.inputBackgroundColor,
                                  title: Text(
                                    value.name,
                                    style: context.theme.fontScheme.p2.copyWith(
                                      color: context
                                          .theme.colorScheme.foregroundColor,
                                    ),
                                  ),
                                ),
                                onSuggestionSelected: (value) {
                                  widget.controller.formData.topic =
                                      value.value;
                                  topicController.text = value.value;
                                },
                                suggestionsCallback: (pattern) =>
                                    TopicValues.values.where(
                                  (element) => element.name.contains(
                                    pattern,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          AnimatedBuilder(
                              animation: topicController,
                              builder: (context, _) {
                                return Visibility(
                                  visible: state == 2 &&
                                      topicController.text.isNotEmpty,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: SizedBox.square(
                                      dimension: 48,
                                      child: BaseButton.icon(
                                        padding: EdgeInsets.zero,
                                        backgroundColor: ColorTokens.concrete,
                                        icon: Icon(
                                          HeroiconsMini.xMark,
                                          size: 18,
                                          color: context.theme.colorScheme
                                              .inputForegroundColor,
                                        ),
                                        onPressed: () {
                                          widget.controller.formData.topic =
                                              null;
                                          topicController.clear();
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              })
                        ],
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
