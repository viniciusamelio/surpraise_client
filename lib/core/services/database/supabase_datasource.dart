import '../../core.dart';
import '../../external_dependencies.dart';
import 'filter_parser.dart';

class SupabaseDatasource implements DatabaseDatasource {
  const SupabaseDatasource({
    required this.supabase,
  });
  final SupabaseClient supabase;

  @override
  Future<QueryResult> delete(GetQuery query) async {
    try {
      final List<Json> result = await supabase
          .from(query.sourceName)
          .delete()
          .match({query.fieldName: query.value}).select();
      return QueryResult(
        success: true,
        failure: false,
        registersAffected: result.length,
      );
    } catch (e) {
      return QueryResult(
        success: false,
        failure: true,
        errorMessage: e.toString(),
      );
    }
  }

  @override
  Future<QueryResult> get(GetQuery query) async {
    try {
      var sbquery = supabase.from(query.sourceName).select();

      sbquery = whereParser(
        builder: sbquery,
        operator: query.operator,
        value: query.value,
        fieldName: query.fieldName,
      );

      if (query.filters != null && query.filters!.isNotEmpty) {
        for (final filter in query.filters!) {
          sbquery = sbquery.filter(
            filter.fieldName,
            filter.operator.value,
            filter.value,
          );
        }
      }

      if (query.filters != null && query.filters!.isNotEmpty) {
        for (var filter in query.filters!) {
          if (filter is AndFilter) {
            sbquery = sbquery.filter(
              filter.fieldName,
              filter.operator.value,
              filter.value,
            );
            continue;
          }
          sbquery = sbquery.or(
            "${filter.fieldName}${filterParser(filter.operator)}${filter.value}",
          );
        }
      }

      final List result = await sbquery.select(
        query.select ?? "*",
      );
      return QueryResult(
        success: true,
        failure: false,
        multiData: result.cast<Json>(),
      );
    } catch (e) {
      return QueryResult(
        success: false,
        failure: true,
        errorMessage: e.toString(),
      );
    }
  }

  @override
  Future<QueryResult> getAll(String sourceName) async {
    try {
      final result =
          await supabase.from(sourceName).select<PostgrestListResponse>();
      return QueryResult(
        multiData: result.data,
        registersAffected: result.count,
        success: true,
        failure: false,
      );
    } catch (e) {
      return QueryResult(
        success: false,
        failure: true,
        errorMessage: e.toString(),
      );
    }
  }

  @override
  Future<QueryResult> pop(PopQuery query) {
    throw UnimplementedError();
  }

  @override
  Future<QueryResult> push(PushQuery query) {
    throw UnimplementedError();
  }

  @override
  Future<QueryResult> save(SaveQuery query) async {
    try {
      final result = await supabase
          .from(query.sourceName)
          .upsert(
            query.value,
            options: const FetchOptions(
              count: CountOption.exact,
            ),
          )
          .select();
      return QueryResult(
        success: true,
        failure: false,
        multiData: (result.data as List).cast<Json>(),
        registersAffected: result.count,
      );
    } catch (e) {
      return QueryResult(
        success: false,
        failure: true,
        errorMessage: e.toString(),
      );
    }
  }
}
