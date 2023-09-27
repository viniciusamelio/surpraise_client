class UploadFailedException implements Exception {
  const UploadFailedException({
    this.message = "Something went wrong uploading your file",
  });

  final String message;
}

class FileNotFoundException implements Exception {
  const FileNotFoundException({
    this.message = "File not found",
  });
  final String message;
}

class GetFileException implements Exception {
  const GetFileException({
    this.message = "Something went wrong getting your file",
  });
  final String message;
}

class RemoveFileException implements Exception {
  const RemoveFileException({
    this.message = "Something went wrong removing your file",
  });
  final String message;
}
