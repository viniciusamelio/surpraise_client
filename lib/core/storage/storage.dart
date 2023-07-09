import 'dart:io';

import 'package:ez_either/ez_either.dart';

import '../core.dart';
import 'exception.dart';

class AppwriteStorageService implements StorageService {
  const AppwriteStorageService({
    required AppWriteService appWriteService,
    required IdService uuidService,
  })  : _appWriteService = appWriteService,
        _uuidService = uuidService;
  final AppWriteService _appWriteService;
  final IdService _uuidService;

  @override
  AsyncAction<String> uploadImage(StorageImageDto imageDto) async {
    try {
      final id = await _uuidService.generate();
      final result = await _appWriteService.uploadImage(
        bucketId: imageDto.bucketId,
        fileId: id,
        fileToSave: imageDto.file,
      );
      return Right(result);
    } catch (e) {
      return Left(const UploadFailedException());
    }
  }

  @override
  AsyncAction<File> getImage({
    required String bucketId,
    required String fileId,
  }) async {
    try {
      final result = await _appWriteService.getImage(
        bucketId: bucketId,
        fileId: fileId,
      );
      if (result == null) {
        return Left(const FileNotFoundException());
      }
      return Right(result);
    } catch (e) {
      return Left(
        const GetFileException(),
      );
    }
  }
}
