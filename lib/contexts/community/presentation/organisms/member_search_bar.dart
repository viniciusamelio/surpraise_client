import 'package:blurple/widgets/buttons/buttons.dart';
import 'package:blurple/widgets/input/base_input.dart';
import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../../../core/external_dependencies.dart';
import '../../community.dart';

class MemberSearchBarOrganism extends StatefulWidget {
  const MemberSearchBarOrganism({
    super.key,
    required this.controller,
  });

  final CommunityDetailsController controller;

  @override
  State<MemberSearchBarOrganism> createState() =>
      _MemberSearchBarOrganismState();
}

class _MemberSearchBarOrganismState extends State<MemberSearchBarOrganism> {
  CommunityDetailsController get controller => widget.controller;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return AtomObserver(
      atom: controller.showSearchbar,
      builder: (context, state) {
        return AnimatedSize(
          curve: Curves.bounceInOut,
          duration: const Duration(milliseconds: 300),
          child: Visibility(
            visible: state,
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: BaseInput(
                hintText: "Pesquisar @ do membro",
                hintStyle: theme.fontScheme.input,
                onChanged: (value) {
                  controller.memberFilter.set(value);
                },
                suffixIcon: Padding(
                  padding: const EdgeInsets.all(4),
                  child: SizedBox.square(
                    dimension: 24,
                    child: BorderedIconButton(
                      padding: const EdgeInsets.all(0),
                      onPressed: () {
                        controller.memberFilter.set("");
                        controller.showSearchbar.set(
                          false,
                        );
                      },
                      borderSide: BorderSide.none,
                      preffixIcon: const Icon(
                        HeroiconsMini.xMark,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
