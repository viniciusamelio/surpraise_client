import 'package:blurple/widgets/input/base_input.dart';
import 'package:flutter/material.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';

import '../../../../../core/core.dart';
import '../../controllers/signup_controller.dart';

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
  late final TextEditingController nameController, emailController;

  @override
  void initState() {
    nameController = TextEditingController(text: controller.formData.name);
    emailController = TextEditingController(text: controller.formData.email);
    super.initState();
  }

  bool get socialLogin => controller.formData.email != null;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          BaseInput(
            label: translations.name,
            enabled: !socialLogin,
            controller: nameController,
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
            label: translations.email,
            enabled: !socialLogin,
            controller: emailController,
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
            label: translations.tag,
            onSaved: (value) => controller.formData.tag = value!,
            validator: (value) => tag(value ?? ""),
            preffixIcon: const Icon(
              HeroiconsSolid.atSymbol,
            ),
          ),
          SizedBox(
            height: context.theme.spacingScheme.verticalSpacing,
          ),
          Visibility(
            visible: !socialLogin,
            child: Column(
              children: [
                BaseInput(
                  label: translations.password,
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
              ],
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: ValueListenableBuilder(
              valueListenable: controller.profilePicture,
              builder: (context, picture, _) {
                final bool selectedFile = picture != null;
                return InkWell(
                  onTap: () async {
                    final image = await injected<ImageManager>().select();
                    controller.profilePicture.value =
                        image ?? controller.profilePicture.value;
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
                          translations.profilePictureLabel,
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
                                width: 80,
                                fit: BoxFit.fitWidth,
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
