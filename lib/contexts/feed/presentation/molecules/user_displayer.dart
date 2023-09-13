import 'package:flutter/material.dart';
import '../../../../core/core.dart';
import '../../../../shared/dtos/user.dart';

class UserDisplayer extends StatelessWidget {
  const UserDisplayer({
    super.key,
    required this.user,
  });

  final UserDto user;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 100),
          child: Text.rich(
            TextSpan(
              text: "Bem vindo,\n",
              style: context.theme.fontScheme.h2.copyWith(
                color: context.theme.colorScheme.foregroundColor,
                fontWeight: FontWeight.w300,
              ),
              children: [
                TextSpan(
                  text: "${user.name.split(' ').first} !",
                  style: context.theme.fontScheme.h1.copyWith(
                    color: context.theme.colorScheme.foregroundColor,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox.square(
          dimension: 66,
          child: CircleAvatar(
            backgroundImage: NetworkImage(
              user.avatarUrl!,
            ),
          ),
        )
      ],
    );
  }
}
