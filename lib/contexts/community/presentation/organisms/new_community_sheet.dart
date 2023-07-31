import 'package:blurple/widgets/buttons/buttons.dart';
import 'package:blurple/widgets/input/base_input.dart';
import 'package:flutter/material.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';

import '../../../../core/core.dart';
import '../../../../shared/presentation/molecules/molecules.dart';

class NewCommunitySheet extends StatefulWidget {
  const NewCommunitySheet({Key? key}) : super(key: key);

  @override
  State<NewCommunitySheet> createState() => _NewCommunitySheetState();
}

class _NewCommunitySheetState extends State<NewCommunitySheet> {
  @override
  Widget build(BuildContext context) {
    return BottomSheetMolecule(
      child: Form(
        child: SingleChildScrollView(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  SizedBox(
                    height: 120,
                    width: 120,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: context.theme.colorScheme.inputForegroundColor,
                          width: 2,
                        ),
                      ),
                      child: CircleAvatar(
                        backgroundColor: context
                            .theme.colorScheme.overlayElevatedWidgetsColor,
                        child: const Icon(
                          HeroiconsSolid.photo,
                          size: 60,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -4,
                    right: 4,
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: BorderedIconButton(
                        preffixIcon: Icon(
                          HeroiconsSolid.plus,
                          color: context.theme.colorScheme.accentColor,
                        ),
                        borderSide: BorderSide(
                          color: context.theme.colorScheme.accentColor,
                        ),
                        padding: const EdgeInsets.all(4),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox.square(
                dimension: context.theme.spacingScheme.verticalSpacing * 2,
              ),
              const BaseInput(
                label: "Nome da comunidade",
              ),
              SizedBox.square(
                dimension: context.theme.spacingScheme.verticalSpacing * 2,
              ),
              BaseInput.large(
                label: "Descrição da comunidade",
                maxLines: 3,
              ),
              SizedBox.square(
                dimension: context.theme.spacingScheme.verticalSpacing * 3,
              ),
              SizedBox(
                width: double.maxFinite,
                child: BorderedButton(
                  text: "Enviar",
                  borderSide: BorderSide(
                    color: context.theme.colorScheme.accentColor,
                  ),
                  onPressed: () {},
                  foregroundColor: context.theme.colorScheme.accentColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
