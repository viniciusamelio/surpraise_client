import 'dart:io';

import 'package:flutter/material.dart';

import '../../../core/extensions/theme.dart';
import '../../../core/external_dependencies.dart';

class AvatarMolecule extends StatelessWidget {
  const AvatarMolecule({
    super.key,
    this.iconSize = 30,
    this.image,
    required this.size,
    required this.imageUrl,
  });
  final String? imageUrl;
  final File? image;
  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: Visibility(
        visible: imageUrl != null && imageUrl!.isNotEmpty || image != null,
        replacement: Container(
          height: size,
          width: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: context.theme.colorScheme.elevatedWidgetsColor,
          ),
          child: Icon(
            HeroiconsMini.user,
            size: iconSize,
          ),
        ),
        child: CircleAvatar(
          backgroundImage: image != null
              ? FileImage(image!) as ImageProvider
              : CachedNetworkImageProvider(
                  imageUrl ?? '',
                ),
        ),
      ),
    );
  }
}
