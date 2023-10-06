import 'package:blurple/widgets/input/base_dropdown.dart';
import 'package:flutter/material.dart';

import '../../../../contexts/community/dtos/dtos.dart';
import '../../../../core/core.dart';
import '../../../../core/external_dependencies.dart';

class NewPraiseCommunitySelectionStep extends StatelessWidget {
  const NewPraiseCommunitySelectionStep({
    super.key,
    required this.notifier,
    required this.onCommunitySelected,
  });

  final AtomNotifier<DefaultState<Exception, List<CommunityOutput>>> notifier;

  final void Function(CommunityOutput community) onCommunitySelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
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
        AtomObserver(
          atom: notifier,
          builder: (context, state) {
            return BaseSearchableDropdown<CommunityOutput>(
              suggestionsCallback: (pattern) async {
                final data =
                    state as SuccessState<Exception, List<CommunityOutput>>;
                return data.data.where(
                  (element) => element.title
                      .toLowerCase()
                      .contains(pattern.toLowerCase()),
                );
              },
              direction: AxisDirection.up,
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
