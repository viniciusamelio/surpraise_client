import 'package:blurple/widgets/input/base_dropdown.dart';
import 'package:flutter/material.dart';

import '../../../../contexts/community/dtos/dtos.dart';
import '../../../../core/core.dart';

class NewPraiseCommunitySelectionStep extends StatelessWidget {
  const NewPraiseCommunitySelectionStep({
    super.key,
    required this.notifier,
    required this.onCommunitySelected,
  });

  final ValueNotifier<DefaultState<Exception, List<ListUserCommunitiesOutput>>>
      notifier;

  final void Function(FindCommunityOutput community) onCommunitySelected;

  @override
  Widget build(BuildContext context) {
    return Column(
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
            return BaseSearchableDropdown<FindCommunityOutput>(
              suggestionsCallback: (pattern) async {
                final data =
                    state as SuccessState<Exception, List<FindCommunityOutput>>;
                return data.data.where(
                  (element) => element.title
                      .toLowerCase()
                      .contains(pattern.toLowerCase()),
                );
              },
              hint: "Comunidade de quem vai receber o praise",
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
