class InvalidResponseException implements Exception {
  const InvalidResponseException({
    required this.message,
  });

  final String message;
}
