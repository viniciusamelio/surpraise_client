export "./supabase_realtime.dart";

abstract interface class RealtimeQuery {
  void run({
    required String primaryKeyName,
    required String source,
    required ListenableField where,
    required void Function() callback,
  });
}

class ListenableField<T> {
  const ListenableField({
    required this.fieldName,
    required this.value,
  });
  final String fieldName;
  final T value;
}
