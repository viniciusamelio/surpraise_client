import 'package:flutter/material.dart';

import '../env.dart';

String getAvatarFromId(String id) {
  return "${Env.sbUrl}/storage/v1/object/public/${Env.avatarBucket}/$id.png";
}

Future<T?> showCustomModalBottomSheet<T>({
  required BuildContext context,
  required Widget child,
}) async {
  return await showModalBottomSheet<T>(
    isScrollControlled: true,
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    builder: (context) => child,
  );
}
