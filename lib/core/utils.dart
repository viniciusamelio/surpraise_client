import 'package:flutter/material.dart';

import '../env.dart';

String getAvatarFromId(String id) {
  return "${Env.sbUrl}/storage/v1/object/public/${Env.avatarBucket}/$id.png";
}

Future<T?> showCustomModalBottomSheet<T>({
  required BuildContext context,
  required Widget child,
  BoxConstraints? constraints,
}) async {
  return await showModalBottomSheet<T>(
    isScrollControlled: true,
    context: context,
    constraints: constraints,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    builder: (context) => child,
  );
}

extension NumtoSpacings on num {
  toBorderRadius() {
    return BorderRadius.circular(toDouble());
  }

  toPaddingAll() {
    return EdgeInsets.all(toDouble());
  }

  toPaddingSymmetric() {
    return EdgeInsets.symmetric(horizontal: toDouble());
  }
}

extension Iterables<E> on Iterable<E> {
  Map<K, List<E>> groupBy<K>(K Function(E) keyFunction) => fold(
      <K, List<E>>{},
      (Map<K, List<E>> map, E element) =>
          map..putIfAbsent(keyFunction(element), () => <E>[]).add(element));
}
