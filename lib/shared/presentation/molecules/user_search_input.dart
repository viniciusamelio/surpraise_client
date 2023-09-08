import 'package:blurple/widgets/buttons/buttons.dart';
import 'package:blurple/widgets/input/base_input.dart';
import 'package:flutter/material.dart';

import '../../../core/core.dart';

class UserSearchInput extends StatelessWidget {
  const UserSearchInput({
    super.key,
    required this.controller,
    required this.hint,
    this.enabled = true,
    required this.action,
    this.borderColor,
    this.iconColor,
    this.errorText,
  });

  final TextEditingController controller;
  final String hint;
  final bool enabled;
  final VoidCallback action;
  final Color? borderColor;
  final Color? iconColor;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Focus(
          onFocusChange: (_) => action(),
          child: BaseInput(
            hintText: hint,
            hintStyle: context.theme.fontScheme.input,
            controller: controller,
            maxLines: 1,
            enabled: enabled,
            suffixIcon: SizedBox(
              width: 18,
              height: 18,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: BorderedIconButton(
                  onPressed: action,
                  padding: const EdgeInsets.all(2),
                  borderSide: BorderSide(
                    width: 2,
                    color: borderColor ?? Colors.transparent,
                  ),
                  preffixIcon: Icon(
                    Icons.search,
                    size: 16,
                    color: iconColor ??
                        context.theme.colorScheme.inputForegroundColor,
                  ),
                ),
              ),
            ),
            onEditingCompleted: action,
          ),
        ),
        errorText == null
            ? const SizedBox.shrink()
            : const SizedBox(
                height: 12,
              ),
        Visibility(
          visible: errorText != null,
          child: Text(
            errorText ?? "",
            style: context.theme.fontScheme.p1.copyWith(
              color: context.theme.colorScheme.dangerColor,
            ),
          ),
        ),
      ],
    );
  }
}
