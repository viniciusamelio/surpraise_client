import 'dart:io';

import 'package:atom_notifier/atom_notifier.dart';

import '../protocols/protocols.dart';
import '../types.dart';

class UploadImageDto {
  const UploadImageDto({
    required this.filename,
    required this.bucket,
    required this.file,
  });

  final String filename;
  final String bucket;
  final File file;
}

abstract class ImageController {
  Future<File?> pickFile();
  AsyncAction<String> upload(UploadImageDto input);

  AtomAppState get state;
}

class DefaultImageController implements ImageController {
  DefaultImageController({
    required ImageUploader imageUploader,
    required ImageManager imageManager,
  })  : _imageUploader = imageUploader,
        _imageManager = imageManager;
  final ImageUploader _imageUploader;
  final ImageManager _imageManager;

  final AtomNotifier<AtomAppState> _state = AtomNotifier(InitialState());

  @override
  AtomAppState get state => _state.value;

  @override
  AsyncAction<String> upload(UploadImageDto input) async {
    _state.set(LoadingState());
    final result = await _imageUploader.upload(
      file: input.file,
      bucket: input.bucket,
      fileName: input.filename,
    );
    result.fold(
      _state.fromError,
      _state.fromSuccess,
    );
    return result;
  }

  @override
  Future<File?> pickFile() async {
    return await _imageManager.select();
  }
}
