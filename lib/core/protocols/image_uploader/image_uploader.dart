import 'dart:io';

import '../../core.dart';

abstract class ImageUploader {
  AsyncAction<String> upload({
    required File file,
    required String bucket,
    required String fileName,
  });
}
