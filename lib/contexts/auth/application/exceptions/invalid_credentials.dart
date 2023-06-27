class InvalidCredentialsException implements Exception {
  @override
  String toString() {
    return "There was not possible to sign you in, please, check your credentials and try again";
  }
}
