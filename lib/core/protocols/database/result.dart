class QueryResult {
  QueryResult({
    required this.success,
    required this.failure,
    this.errorMessage,
    this.data,
    this.registersAffected,
    this.multiData,
  });

  bool success;
  bool failure;
  String? errorMessage;
  Map<String, dynamic>? data;
  List<Map<String, dynamic>>? multiData;
  int? registersAffected;
}
