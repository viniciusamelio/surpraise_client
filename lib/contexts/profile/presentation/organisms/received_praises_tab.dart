import 'package:blurple/sizes/spacings.dart';
import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../../../core/external_dependencies.dart';
import '../../../../shared/shared.dart';
import '../../../feed/presentation/molecules/molecules.dart';

class ReceivedPraisesTabOrganism extends StatelessWidget {
  const ReceivedPraisesTabOrganism({
    super.key,
    required this.state,
    required this.scrollController,
    required this.loadedPraises,
  });

  final AtomNotifier<DefaultState<Exception, List<PraiseDto>>> state;
  final ScrollController scrollController;
  final List<PraiseDto> loadedPraises;

  @override
  Widget build(BuildContext context) {
    return AtomObserver(
      atom: state,
      builder: (context, state) {
        if (state is LoadingState) {
          return const LoaderMolecule();
        } else if (state is ErrorState) {
          return const ErrorWidgetMolecule(
            message: "Deu ruim ao recuperar seus #praises",
          );
        }

        final List<PraiseDto> data = loadedPraises;
        return SizedBox(
          child: ListView.separated(
            itemCount: data.length,
            controller: scrollController,
            physics: const BouncingScrollPhysics(),
            separatorBuilder: (context, index) => SizedBox(
              height: Spacings.md,
            ),
            itemBuilder: (context, index) {
              return PraiseCardMolecule(
                praise: data[index],
                mode: PraiseCardMode.profile,
              );
            },
          ),
        );
      },
    );
  }
}
