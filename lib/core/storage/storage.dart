import 'package:ez_either/ez_either.dart';

import '../core.dart';
import '../external_dependencies.dart';
import 'exception.dart';

class SupabaseStorageService implements StorageService {
  const SupabaseStorageService({
    required SupabaseCloudClient supabaseClient,
  }) : _supabase = supabaseClient;

  final SupabaseCloudClient _supabase;
  @override
  AsyncAction<String> getImage({
    required String bucketId,
    required String fileId,
  }) async {
    try {
      final result = await _supabase.getImage(
        fileId: fileId,
        bucketId: bucketId,
      );
      return Right(
        "$result.png",
      );
    } catch (e) {
      return Left(const GetFileException());
    }
  }

  @override
  AsyncAction<String> uploadImage(StorageImageDto imageDto) async {
    try {
      final url = await _supabase.uploadImage(
        bucketId: imageDto.bucketId,
        fileId: imageDto.id,
        fileToSave: imageDto.file,
      );
      return Right(url);
    } catch (e) {
      return Left(const UploadFailedException());
    }
  }
}
