import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../../core/extensions/theme.dart';
import '../../../../../translations/locale_sync.dart';

class LoginDisplayerOrganism extends StatefulWidget {
  const LoginDisplayerOrganism({super.key});

  @override
  State<LoginDisplayerOrganism> createState() => _LoginDisplayerOrganismState();
}

class _LoginDisplayerOrganismState extends State<LoginDisplayerOrganism>
    with SingleTickerProviderStateMixin {
  late final AnimationController animatedTextController;
  late final ValueNotifier<String> animatedTextContent;
  late final List<String> animatedTextContents;

  @override
  void initState() {
    animatedTextContents = [
      "#valorize",
      "#agradeça",
      "#surpreenda",
      "#lembre",
    ];
    animatedTextController = AnimationController(
        vsync: this, animationBehavior: AnimationBehavior.preserve)
      ..loop(
        period: const Duration(minutes: 10),
      );
    animatedTextContent = ValueNotifier(animatedTextContents.first);
    super.initState();
  }

  @override
  void dispose() {
    animatedTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleSync.of(context).welcome,
          style: context.theme.fontScheme.h1.copyWith(
            color: context.theme.colorScheme.foregroundColor,
          ),
        ).animate().fade(
              curve: Curves.bounceInOut,
              delay: const Duration(milliseconds: 400),
            ),
        SizedBox(
          height: context.theme.spacingScheme.verticalSpacing,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: ValueListenableBuilder<String>(
            valueListenable: animatedTextContent,
            builder: (context, value, _) => Text(
              value,
              style: context.theme.fontScheme.h3.copyWith(
                color: context.theme.colorScheme.inputForegroundColor,
              ),
            )
                .animate(
                  controller: animatedTextController,
                  onComplete: (controller) {
                    late String value;
                    final index =
                        animatedTextContents.indexOf(animatedTextContent.value);
                    if (index + 1 < animatedTextContents.length) {
                      value = animatedTextContents[index + 1];
                    } else {
                      value = animatedTextContents.first;
                    }
                    animatedTextContent.value = value;

                    controller
                      ..reset()
                      ..forward();
                  },
                )
                .fade(delay: const Duration(milliseconds: 400))
                .moveY(
                    duration: const Duration(
                  seconds: 2,
                )),
          ),
        )
      ],
    );
  }
}
