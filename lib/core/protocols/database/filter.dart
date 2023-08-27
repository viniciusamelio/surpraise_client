import 'query.dart';

abstract class AggregateFilter {
  AggregateFilter({
    required this.operator,
    required this.value,
    required this.fieldName,
  });
  final FilterOperator operator;
  final dynamic value;
  final String fieldName;

  factory AggregateFilter.and({
    required FilterOperator operator,
    required value,
    required String fieldName,
  }) =>
      AndFilter(
        fieldName: fieldName,
        value: value,
        operator: operator,
      );

  factory AggregateFilter.or({
    required FilterOperator operator,
    required value,
    required String fieldName,
  }) =>
      OrFilter(
        fieldName: fieldName,
        value: value,
        operator: operator,
      );
}

class AndFilter<T> implements AggregateFilter {
  @override
  final String fieldName;

  @override
  final FilterOperator operator;

  @override
  final T value;

  AndFilter({
    required this.fieldName,
    required this.operator,
    required this.value,
  });
}

class OrFilter<T> implements AggregateFilter {
  @override
  final String fieldName;

  @override
  final FilterOperator operator;

  @override
  final T value;

  OrFilter({
    required this.fieldName,
    required this.operator,
    required this.value,
  });
}
