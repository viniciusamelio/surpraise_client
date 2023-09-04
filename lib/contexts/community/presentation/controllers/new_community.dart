import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../../../env.dart';
import '../../../../shared/presentation/controllers/session.dart';
import '../../application/application.dart';

abstract class NewCommunityController
    extends BaseStateController<CreateCommunityOutput> {
  ValueNotifier<String> get name;
  ValueNotifier<String> get description;
  ValueNotifier<String> get imagePath;

  Future<void> save();
  Future<void> pickImage();

  void dispose();
}

class DefaultNewCommunityController
    with BaseState<Exception, CreateCommunityOutput>
    implements NewCommunityController {
  DefaultNewCommunityController({
    required CommunityRepository communityRepository,
    required SessionController sessionController,
    required ImageManager imageManager,
    required ImageController imageController,
  })  : _communityRepository = communityRepository,
        _imageManager = imageManager,
        _imageController = imageController,
        _sessionController = sessionController;
  final CommunityRepository _communityRepository;
  final SessionController _sessionController;
  final ImageManager _imageManager;
  final ImageController _imageController;

  @override
  final ValueNotifier<String> description = ValueNotifier("");

  @override
  final ValueNotifier<String> imagePath = ValueNotifier("");

  @override
  final ValueNotifier<String> name = ValueNotifier("");

  @override
  Future<void> save() async {
    state.value = LoadingState();
    String? imageUrl;
    if (imagePath.value.isNotEmpty) {
      final id = DateTime.now().microsecond;
      final uploadedFileOrError = await _imageController.upload(
        UploadImageDto(
          filename: id.toString(),
          bucket: Env.communitiesBucket,
          file: File(imagePath.value),
        ),
      );

      if (uploadedFileOrError.isLeft()) {
        ErrorState(
          uploadedFileOrError.fold((left) => left, (right) => null)!,
        );
        return;
      }

      imageUrl = uploadedFileOrError.fold((left) => null, (right) => right);
    }
    final outputOrError = await _communityRepository.createCommunity(
      CreateCommunityInput(
        description: description.value,
        ownerId: _sessionController.currentUser!.id,
        title: name.value,
        imageUrl: imageUrl!,
      ),
    );
    state.value = outputOrError.fold(
      (left) => ErrorState(left),
      (right) => SuccessState(right),
    );
  }

  @override
  Future<void> pickImage() async {
    final image = await _imageManager.select();
    if (image != null) {
      imagePath.value = image.path;
    }
  }

  @override
  void dispose() {
    state.value = InitialState();
    description.value = "";
    imagePath.value = "";
    name.value = "";
  }
}