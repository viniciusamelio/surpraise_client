class SupabaseUserSignupException implements Exception {
  const SupabaseUserSignupException([
    this.message = "Something went wrong signing you up",
  ]);

  final String message;
}

class SupabaseUserSigninException implements Exception {
  const SupabaseUserSigninException([
    this.message = "Something went wrong signing you in",
  ]);

  final String message;
}

class SupabaseUploadImageException implements Exception {
  const SupabaseUploadImageException([
    this.message = "Something went wrong uploading your image",
  ]);

  final String message;
}
