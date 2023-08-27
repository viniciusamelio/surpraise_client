// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'filter.dart';

enum FilterOperator {
  greaterThan(">"),
  equalsOrGreaterThan(">="),
  lesserThan("<"),
  equalsOrLesserThan("<="),
  notEqualsTo("!="),
  equalsTo("=");

  final String value;
  const FilterOperator(this.value);
}

abstract class Query {
  Query({
    required this.sourceName,
  });

  final String sourceName;
}

class GetQuery<T> implements Query {
  GetQuery({
    required this.sourceName,
    required this.operator,
    required this.value,
    required this.fieldName,
    this.filters,
    this.singleResult = true,
  });

  @override
  final String sourceName;

  final FilterOperator operator;
  final String fieldName;
  final T value;

  final bool singleResult;

  final List<AggregateFilter>? filters;

  GetQuery<T> copyWith({
    String? sourceName,
    FilterOperator? operator,
    String? fieldName,
    T? value,
    bool? singleResult,
    List<AggregateFilter>? filters,
  }) {
    return GetQuery<T>(
      sourceName: sourceName ?? this.sourceName,
      operator: operator ?? this.operator,
      fieldName: fieldName ?? this.fieldName,
      value: value ?? this.value,
      singleResult: singleResult ?? this.singleResult,
      filters: filters ?? this.filters,
    );
  }
}

class SaveQuery implements Query {
  SaveQuery({
    required this.sourceName,
    required this.value,
    this.id,
  });

  @override
  final String sourceName;
  final Map<String, dynamic> value;
  final String? id;
}

class PushQuery implements Query {
  PushQuery({
    required this.sourceName,
    required this.value,
    required this.id,
    required this.field,
  });

  @override
  final String sourceName;
  final dynamic value;
  final String id;
  final String field;
}

class PopQuery extends PushQuery {
  PopQuery({
    required super.sourceName,
    required super.value,
    required super.id,
    required super.field,
  });
}
