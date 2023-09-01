import 'dart:io';

import 'package:ez_either/ez_either.dart';

import '../../core.dart';

class DefaultImageUploader implements ImageUploader {
  DefaultImageUploader({
    required SupabaseCloudClient supabaseCloudClient,
  }) : _supabaseCloudClient = supabaseCloudClient;
  final SupabaseCloudClient _supabaseCloudClient;

  @override
  AsyncAction<String> upload({
    required File file,
    required String bucket,
    required String fileName,
  }) async {
    try {
      final result = await _supabaseCloudClient.uploadImage(
        bucketId: bucket,
        fileId: "${DateTime.now().microsecondsSinceEpoch}-$fileName",
        fileToSave: file,
      );

      return Right(result);
    } catch (e) {
      return Left(
        Exception(
          "Something went wrong uploading your file",
        ),
      );
    }
  }
}
