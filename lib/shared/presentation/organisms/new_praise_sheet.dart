import 'package:blurple/widgets/buttons/buttons.dart';
import 'package:blurple/widgets/input/base_input.dart';
import 'package:flutter/material.dart';
// import '../../shared.dart';
import '../../../core/core.dart';

class NewPraiseSheet extends StatelessWidget {
  const NewPraiseSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    // final PraiseController controller = injected();

    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        color: context.theme.colorScheme.elevatedWidgetsColor,
      ),
      padding: const EdgeInsets.only(bottom: 12, top: 24, right: 24, left: 24),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BaseInput(
              hintText: "@ de quem vai receber o #praise",
              hintStyle: context.theme.fontScheme.input,
            ),
            const SizedBox(
              height: 12,
            ),
            BaseInput(
              hintText: "Motivo do #praise",
              hintStyle: context.theme.fontScheme.input,
            ),
            const SizedBox(
              height: 12,
            ),
            BaseInput.large(
              hintText: "Solta a matraca e elogie com vontade!",
              minLines: 3,
              hintStyle: context.theme.fontScheme.input,
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
                borderSide:
                    BorderSide(color: context.theme.colorScheme.accentColor),
                child: Text(
                  "#praise  >",
                  style: context.theme.fontScheme.input.copyWith(
                    color: context.theme.colorScheme.accentColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
