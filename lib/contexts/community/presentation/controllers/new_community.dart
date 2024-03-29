import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../../../core/external_dependencies.dart';
import '../../../../env.dart';
import '../../../../shared/presentation/controllers/session.dart';
import '../../application/application.dart';

abstract class NewCommunityController
    extends BaseStateController<CreateCommunityOutput> {
  ValueNotifier<String> get name;
  ValueNotifier<String> get description;
  ValueNotifier<String> get imagePath;
  ValueNotifier<String?> get id;

  Future<void> save({
    bool newCommunity = true,
  });
  Future<void> pickImage();

  void dispose();
}

class DefaultNewCommunityController
    with BaseState<Exception, CreateCommunityOutput>
    implements NewCommunityController {
  DefaultNewCommunityController({
    required SessionController sessionController,
    required ImageManager imageManager,
    required ImageController imageController,
    required CreateCommunityUsecase createCommunityUsecase,
    required UpdateCommunityUsecase updateCommunityUsecase,
  })  : _imageManager = imageManager,
        _updateCommunityUsecase = updateCommunityUsecase,
        _createCommunityUsecase = createCommunityUsecase,
        _imageController = imageController,
        _sessionController = sessionController {
    setDefaultErrorHandling();
  }
  final SessionController _sessionController;
  final ImageManager _imageManager;
  final ImageController _imageController;
  final CreateCommunityUsecase _createCommunityUsecase;
  final UpdateCommunityUsecase _updateCommunityUsecase;

  @override
  final ValueNotifier<String> description = ValueNotifier("");

  @override
  final ValueNotifier<String> imagePath = ValueNotifier("");

  @override
  final ValueNotifier<String> name = ValueNotifier("");

  @override
  final ValueNotifier<String?> id = ValueNotifier(null);

  @override
  Future<void> save({
    newCommunity = true,
  }) async {
    state.set(LoadingState());
    String? imageUrl = imagePath.value;
    if (imagePath.value.isNotEmpty && !isURL(imagePath.value)) {
      final id = DateTime.now().microsecond;
      final uploadedFileOrError = await _imageController.upload(
        UploadImageDto(
          filename: id.toString(),
          bucket: Env.communitiesBucket,
          file: File(imagePath.value),
        ),
      );

      if (uploadedFileOrError.isLeft()) {
        state.set(
          ErrorState(
            uploadedFileOrError.fold((left) => left, (right) => null)!,
          ),
        );
        return;
      }

      imageUrl = uploadedFileOrError.fold((left) => "", (right) => right);
    }
    final outputOrError = await _saveCommunity(
      newCommunity: newCommunity,
      imageUrl: imageUrl,
    );
    state.set(
      outputOrError.fold(
        (left) => ErrorState(left),
        (right) {
          injected<ApplicationEventBus>().add(
            CommunitySavedEvent(
              right,
            ),
          );
          return SuccessState(right);
        },
      ),
    );
  }

  Future<Either<Exception, CreateCommunityOutput>> _saveCommunity({
    bool newCommunity = true,
    String? imageUrl,
  }) async {
    if (newCommunity) {
      return await _createCommunityUsecase(
        CreateCommunityInput(
          description: description.value,
          ownerId: _sessionController.currentUser.value!.id,
          title: name.value,
          imageUrl: imageUrl!,
        ),
      );
    }

    final updatedCommunityOrError = await _updateCommunityUsecase(
      UpdateCommunityInput(
        description: description.value,
        ownerId: _sessionController.currentUser.value!.id,
        title: name.value,
        imageUrl: imageUrl!,
        id: id.value,
      ),
    );
    if (updatedCommunityOrError.isLeft()) {
      return Left(
        updatedCommunityOrError.fold((left) => left, (right) => null)!,
      );
    }
    final updateCommunityOutput = updatedCommunityOrError.fold(
      (left) => null,
      (right) => right,
    )!;
    return Right(
      CreateCommunityOutput(
        id: updateCommunityOutput.id,
        description: updateCommunityOutput.description,
        title: updateCommunityOutput.title,
        members: [
          {},
        ],
        ownerId: _sessionController.currentUser.value!.id,
      ),
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
    state.removeListeners();
    state.set(InitialState());
    description.value = "";
    imagePath.value = "";
    name.value = "";
  }
}
