import '../core.dart';
import '../external_dependencies.dart';

class SupabaseRealtimeQuery implements RealtimeQuery {
  const SupabaseRealtimeQuery({
    required SupabaseClient supabaseClient,
  }) : _supabaseClient = supabaseClient;

  final SupabaseClient _supabaseClient;

  @override
  void run({
    required String primaryKeyName,
    required String source,
    required ListenableField where,
    required void Function() callback,
  }) {
    _supabaseClient
        .from(source)
        .stream(primaryKey: [primaryKeyName])
        .eq(
          where.fieldName,
          where.value,
        )
        .listen(
          (event) {
            callback();
          },
        );
  }
}
