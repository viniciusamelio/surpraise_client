import '../../external_dependencies.dart';

PostgrestFilterBuilder<dynamic> whereParser<T>({
  required PostgrestBuilder<T, T> builder,
  required FilterOperator operator,
  required T value,
  required String fieldName,
}) {
  switch (operator) {
    case FilterOperator.equalsTo:
      return PostgrestFilterBuilder(builder).eq(fieldName, value);
    case FilterOperator.greaterThan:
      return PostgrestFilterBuilder(builder).gt(fieldName, value);
    case FilterOperator.lesserThan:
      return PostgrestFilterBuilder(builder).lt(fieldName, value);
    case FilterOperator.equalsOrGreaterThan:
      return PostgrestFilterBuilder(builder).gte(fieldName, value);
    case FilterOperator.equalsOrLesserThan:
      return PostgrestFilterBuilder(builder).lte(fieldName, value);
    case FilterOperator.notEqualsTo:
      return PostgrestFilterBuilder(builder).neq(fieldName, value);
    case FilterOperator.inValues:
      return PostgrestFilterBuilder(builder).contains(fieldName, value);
  }
}

String filterParser(FilterOperator operator) {
  switch (operator) {
    case FilterOperator.equalsTo:
      return "eq";
    case FilterOperator.greaterThan:
      return "gt";
    case FilterOperator.lesserThan:
      return "lt";
    case FilterOperator.equalsOrGreaterThan:
      return "gte";
    case FilterOperator.equalsOrLesserThan:
      return "lte";
    case FilterOperator.notEqualsTo:
      return "neq";
    case FilterOperator.inValues:
      return "in";
  }
}
