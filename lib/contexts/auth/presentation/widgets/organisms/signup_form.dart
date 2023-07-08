import 'dart:io';

import 'package:blurple/widgets/input/base_input.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';
import '../../controllers/signup_controller.dart';

import '../../../../../core/core.dart';

class SignupFormOrganism extends StatefulWidget {
  const SignupFormOrganism({
    super.key,
    required this.formKey,
    required this.controller,
  });

  final FormKey formKey;
  final SignupController controller;

  @override
  State<SignupFormOrganism> createState() => _SignupFormOrganismState();
}

class _SignupFormOrganismState extends State<SignupFormOrganism> {
  SignupController get controller => widget.controller;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          BaseInput(
            label: "Nome",
            onSaved: (value) => controller.formData.name = value!,
            validator: (value) => name(value ?? ""),
            preffixIcon: const Icon(
              HeroiconsSolid.user,
            ),
          ),
          SizedBox(
            height: context.theme.spacingScheme.verticalSpacing,
          ),
          BaseInput(
            label: "E-mail",
            onSaved: (value) => controller.formData.email = value!,
            validator: (value) => email(value ?? ""),
            preffixIcon: const Icon(
              HeroiconsSolid.envelope,
            ),
          ),
          SizedBox(
            height: context.theme.spacingScheme.verticalSpacing,
          ),
          BaseInput(
            label: "Tag",
            onSaved: (value) => controller.formData.tag = value!,
            validator: (value) => tag(value ?? ""),
            preffixIcon: const Icon(
              HeroiconsSolid.atSymbol,
            ),
          ),
          SizedBox(
            height: context.theme.spacingScheme.verticalSpacing,
          ),
          BaseInput(
            label: "Password",
            onSaved: (value) => controller.formData.password = value!,
            validator: (value) => password(value ?? ""),
            preffixIcon: const Icon(
              HeroiconsSolid.lockClosed,
            ),
            obscureText: true,
            maxLines: 1,
          ),
          SizedBox(
            height: context.theme.spacingScheme.verticalSpacing * 2,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: ValueListenableBuilder(
              valueListenable: controller.profilePicture,
              builder: (context, picture, _) {
                final bool selectedFile = picture != null;
                return InkWell(
                  onTap: () async {
                    // Todo: Create file service
                    final file = await openFile(acceptedTypeGroups: [
                      const XTypeGroup(
                        uniformTypeIdentifiers: [
                          "image/png",
                          "image/jpeg",
                          "image/jpg"
                        ],
                        extensions: ["png", "jpg", "jpeg"],
                      ),
                    ]);
                    if (file != null) {
                      controller.profilePicture.value = File.fromRawPath(
                        await file.readAsBytes(),
                      );
                    }
                  },
                  child: Container(
                    padding: context.theme.spacingScheme.elevatedPadding,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        context.theme.radiusScheme.inputRadius,
                      ),
                      border: Border.all(
                        color: context.theme.colorScheme.borderColor,
                        width: .3,
                      ),
                      color: context.theme.colorScheme.inputBackgroundColor,
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Selecione sua foto de perfil",
                          style: context.theme.fontScheme.p2.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(
                          height:
                              context.theme.spacingScheme.verticalSpacing * 1.5,
                        ),
                        !selectedFile
                            ? Icon(
                                Icons.image_not_supported,
                                color: context
                                    .theme.colorScheme.inputForegroundColor
                                    .withOpacity(.75),
                                size: 42,
                              )
                            : Image.memory(
                                picture.readAsBytesSync(),
                              ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
