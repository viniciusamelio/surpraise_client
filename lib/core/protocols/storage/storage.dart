// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import '../../core.dart';

class StorageImageDto {
  const StorageImageDto({
    required this.bucketId,
    required this.file,
    required this.id,
  });

  final String bucketId;
  final File file;
  final String id;
}

abstract class StorageService {
  AsyncAction<String> uploadImage(StorageImageDto imageDto);
  AsyncAction<void> deleteImage({
    required String bucketId,
    required String fileId,
  });
  AsyncAction<String> getImage({
    required String bucketId,
    required String fileId,
  });
}
