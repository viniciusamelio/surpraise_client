import 'dart:io';

import 'package:blurple/widgets/buttons/buttons.dart';
import 'package:blurple/widgets/input/base_input.dart';
import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../../../core/external_dependencies.dart';
import '../../../../shared/presentation/molecules/molecules.dart';
import '../controllers/controllers.dart';

class SaveCommunitySheet extends StatefulWidget {
  const SaveCommunitySheet({Key? key, this.community}) : super(key: key);
  final CommunityOutput? community;
  @override
  State<SaveCommunitySheet> createState() => _SaveCommunitySheetState();
}

class _SaveCommunitySheetState extends State<SaveCommunitySheet> {
  late final NewCommunityController controller;
  late final GlobalKey<FormState> formKey;
  late final TextEditingController nameFieldController;
  late final TextEditingController descriptionFieldController;
  @override
  void initState() {
    controller = injected<NewCommunityController>();
    formKey = GlobalKey<FormState>();
    nameFieldController = TextEditingController();
    descriptionFieldController = TextEditingController();
    controller.state.listenState(
      onSuccess: (right) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SuccessSnack(
                  message:
                      "Comunidade ${right.title} ${widget.community == null ? 'criada' : 'editada'}")
              .build(
            context,
          ),
        );
      },
    );
    if (widget.community != null) {
      final community = widget.community;
      controller.id.value = community!.id;
      controller.description.value = community.description;
      controller.name.value = community.title;
      controller.imagePath.value = community.image;
      nameFieldController.text = community.title;
      descriptionFieldController.text = community.description;
    }
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheetMolecule(
      child: Form(
        key: formKey,
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
                      child: ValueListenableBuilder(
                        valueListenable: controller.imagePath,
                        builder: (context, value, child) {
                          if (value.isEmpty) {
                            return child!;
                          }

                          return CircleAvatar(
                            backgroundImage: isURL(value)
                                ? NetworkImage(value) as ImageProvider
                                : FileImage(
                                    File(
                                      value,
                                    ),
                                  ),
                          );
                        },
                        child: CircleAvatar(
                          backgroundColor: context
                              .theme.colorScheme.overlayElevatedWidgetsColor,
                          child: ValueListenableBuilder(
                            valueListenable: controller.imagePath,
                            builder: (context, state, child) {
                              if (state.isEmpty) {
                                return child!;
                              }

                              return const SizedBox.shrink();
                            },
                            child: const Icon(
                              HeroiconsSolid.photo,
                              size: 60,
                            ),
                          ),
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
                        onPressed: () {
                          controller.pickImage();
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox.square(
                dimension: context.theme.spacingScheme.verticalSpacing * 2,
              ),
              BaseInput(
                controller: nameFieldController,
                label: "Nome da comunidade",
                onSaved: (value) {
                  controller.name.value = value ?? "";
                },
                validator: (value) => requiredField(
                  value ?? "",
                ),
              ),
              SizedBox.square(
                dimension: context.theme.spacingScheme.verticalSpacing * 2,
              ),
              BaseInput.large(
                controller: descriptionFieldController,
                label: "Descrição da comunidade",
                maxLines: 3,
                onSaved: (value) => controller.description.value = value ?? "",
                validator: (value) => communityDescription(
                  value ?? "",
                ),
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
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      controller.save(
                        newCommunity: widget.community == null,
                      );
                    }
                  },
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
