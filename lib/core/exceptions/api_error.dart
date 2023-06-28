class APIException implements Exception {
  const APIException({
    required this.message,
  });
  final String message;

  @override
  String toString() {
    return message;
  }
}
