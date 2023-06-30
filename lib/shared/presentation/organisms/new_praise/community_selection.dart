import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../../../core/core.dart';

class NewPraiseCommunitySelectionStep extends StatelessWidget {
  const NewPraiseCommunitySelectionStep({
    super.key,
    required this.notifier,
    required this.onCommunitySelected,
  });

  final ValueNotifier<DefaultState<Exception, List<FindCommunityOutput>>>
      notifier;

  final void Function(FindCommunityOutput community) onCommunitySelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Vamos começar selecionando a comunidade de quem vai receber o praise",
          style: context.theme.fontScheme.p2.copyWith(
            fontSize: 16,
          ),
        ),
        const SizedBox(
          height: 32,
        ),
        DefaultStateBuilder(
          state: notifier,
          builder: (context, state) {
            return TypeAheadField<FindCommunityOutput>(
              suggestionsCallback: (pattern) async {
                final data =
                    state as SuccessState<Exception, List<FindCommunityOutput>>;
                return data.data.where(
                  (element) => element.title
                      .toLowerCase()
                      .contains(pattern.toLowerCase()),
                );
              },
              textFieldConfiguration: TextFieldConfiguration(
                decoration: InputDecoration(
                  hintText: "Comunidade de quem vai receber o praise",
                  filled: true,
                  contentPadding: context.theme.spacingScheme.inputPadding,
                  fillColor: context.theme.colorScheme.inputBackgroundColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      4,
                    ),
                  ),
                ),
              ),
              hideSuggestionsOnKeyboardHide: true,
              itemBuilder: (context, item) {
                return ListTile(
                  tileColor: context.theme.colorScheme.inputBackgroundColor,
                  title: Text(
                    item.title,
                    style: context.theme.fontScheme.p2.copyWith(
                      color: context.theme.colorScheme.foregroundColor,
                    ),
                  ),
                  subtitle: Text(
                    item.description,
                    style: context.theme.fontScheme.p1,
                  ),
                );
              },
              onSuggestionSelected: onCommunitySelected,
            );
          },
        ),
      ],
    );
  }
}
